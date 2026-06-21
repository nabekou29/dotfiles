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

### Step 1: 状態記録 + 既存 pin の一括解除

`nix/flake.nix` を読み、`nixpkgs-<pkg>` パターンの input を探す。

#### 1a. 既存 pin の rev を記録

各 pin の rev を控える（Step 4 で再 pin が必要な場合に使う）。

#### 1b. root nixpkgs の rev を記録

flake update 前の nixpkgs rev を取得する（新規 pin 時に使う）:

```bash
python3 -c "
import json
lock = json.load(open('nix/flake.lock'))
key = lock['nodes']['root']['inputs']['nixpkgs']
print(lock['nodes'][key]['locked']['rev'])
"
```

#### 1c. 既存 pin をすべて解除

1. `nix/flake.nix` の inputs から `nixpkgs-<pkg>` を削除
2. `nix/flake.nix` の overlay から該当パッケージの差し替えを削除
3. pin に付随するコメントも削除
4. `nix flake lock nix/` を実行（flake.nix から消えた input は自動的に lock からも除去される）

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
- `system-applications`, `system-path`, `Brewfile`

**重いソースビルド（pin 対象）:**
- C++/Rust/Go 等の大規模ソースビルドが必要なパッケージ
- Facebook 系ライブラリチェーン（mvfst, wangle, fbthrift, fb303, edencommon, watchman）
- 大規模 Rust クレート（mise 等）
- derivation 名からパッケージ名とビルド言語を推定して判断

重いソースビルドがなければ Step 5 に進む。
（以前 pin されていたパッケージがここに現れなければ、キャッシュが追いついたので unpin 成功。）

### Step 4: 重いパッケージを pin

pin 対象のパッケージごとに mise パターンで pin する。

**pin に使う revision の選択:**
- Step 1a で記録した既存 pin rev があればそれを使う（キャッシュ済みと実証済み）
- 新規パッケージは Step 1b で記録した pre-update nixpkgs rev を使う

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

まだ残っていれば、pre-update rev でキャッシュが効かない可能性がある。
その場合は既存 pin rev や、さらに古い revision を試す。

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
