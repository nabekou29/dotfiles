---
name: darwin-update
description: "nix-darwin の flake update + switch を実行。キャッシュミスで重いソースビルドが発生するパッケージは自動で pin し、過去の pin はキャッシュが追いつけば自動解除する。"
---

# darwin-update

chezmoi dotfiles リポジトリの nix-darwin 環境を更新する skill。
ソースビルド回避のための pin 管理を全自動で行う。

## 前提

- 作業ディレクトリ: `~/.local/share/chezmoi`
- flake.nix の場所: `nix/flake.nix`
- プロファイル: `nix/profile` ファイルに `work` または `private` が書かれている
- justfile に `darwin-switch` / `darwin-update` レシピがある

## フロー

以下のステップを順番に実行する。各ステップで何をしているかユーザーに報告する。

### Step 1: 既存 pin の解除チェック

`nix/flake.nix` を読み、`nixpkgs-<pkg>` パターンの input を探す。
見つかったら、最新 nixpkgs でそのパッケージがキャッシュ済みか確認する:

```bash
# 最新 nixpkgs-unstable での derivation がキャッシュにあるか確認
nix build --dry-run 'nixpkgs#<pkg>' --accept-flake-config 2>&1
```

`will be built` に当該パッケージの derivation が**含まれなければ**キャッシュ済み。
キャッシュ済みなら以下を自動実行:

1. `nix/flake.nix` の inputs から `nixpkgs-<pkg>` を削除
2. `nix/flake.nix` の overlay から該当パッケージの差し替えを削除
3. pin に付随するコメントも削除
4. `nix flake lock nix/` を実行（flake.nix から消えた input は自動的に lock からも除去される）

解除したことをユーザーに報告する。

### Step 2: flake update

```bash
nix flake update --flake nix/
```

### Step 3: dry-run 分析

```bash
PROFILE=$(cat nix/profile)
nix build "./nix#darwinConfigurations.${PROFILE}.system" --dry-run --accept-flake-config 2>&1
```

出力を分析する。`will be built` に列挙される derivation を以下に分類:

**無視する derivation（毎回リビルドされるローカル設定系）:**
- `home-manager-*`, `activation-*`, `etc.drv`, `user-environment`
- `darwin-system-*`, `home-manager-path`, `home-manager-files`
- `home-manager-generation`, `*-fonts*`, `*hm_*`

**重いソースビルド（pin 対象）:**
- C++/Rust/Go 等の大規模ソースビルドが必要なパッケージ
- Facebook 系ライブラリチェーン（mvfst, wangle, fbthrift, fb303, edencommon, watchman）
- 大規模 Rust クレート（mise 等）
- derivation 名からパッケージ名とビルド言語を推定して判断

重いソースビルドがなければ Step 5 に進む。

### Step 4: 重いパッケージを pin

pin 対象のパッケージごとに mise パターンで pin する。

pin に使う revision は、**flake update 前の flake.lock に記録されていた nixpkgs の rev**。
flake update 実行前に `python3 -c "import json; print(json.load(open('nix/flake.lock'))['nodes']['nixpkgs']['locked']['rev'])"` で取得しておく。

#### 4a. flake.nix の inputs に追加

```nix
# <pkg> はキャッシュ済み revision に pin してソースビルドを回避
nixpkgs-<pkg>.url = "github:nixos/nixpkgs/<rev>";
```

#### 4b. overlay に追加

既存の overlay ブロック内に追加:

```nix
<pkg> = inputs.nixpkgs-<pkg>.legacyPackages.${prev.stdenv.hostPlatform.system}.<pkg>;
```

#### 4c. flake.lock を更新

```bash
nix flake lock nix/
```

#### 4d. 再確認

pin 後に再度 `nix build --dry-run` を実行して、重いソースビルドが解消されたか確認する。
まだ残っていれば 4a に戻る。

pin したことをユーザーに報告する。

### Step 5: darwin-switch

sudo が必要なため、ユーザーにターミナルで実行してもらう:

```
! just darwin-switch
```

switch が成功したらユーザーに報告する。

### Step 6: 変更をコミット

pin の追加・解除で `nix/flake.nix` や `nix/flake.lock` に変更があればコミットする。
コミットメッセージの形式:

```
nix: flake update (pin: watchman, unpin: mise)
```

pin も unpin もなければ:

```
nix: flake update
```

## 注意事項

- `nix/flake.nix` を編集する際は既存のコードスタイル・コメントスタイルに合わせる
- overlay の順序を崩さない（llm-agents.overlays.default は最後に来る）
- pin の input には `nixpkgs.follows` を付けない（キャッシュヒットのため意図的に独立させる）
- darwin-switch は `just darwin-switch` 経由で実行する（sudo / HOME の設定が justfile に集約されているため）
