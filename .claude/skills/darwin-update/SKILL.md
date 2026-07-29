---
name: darwin-update
description: "nix-darwin の flake update + switch を実行。キャッシュミスで重いソースビルドが発生するパッケージは自動で pin し、過去の pin はキャッシュが追いつけば自動解除する。外部 flake のバイナリキャッシュ設定のずれも検出する。"
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

**外部 flake 由来（pin では解決しない）:**
- nixpkgs 以外の flake が提供するパッケージ（llm-agents の codex 等）
- `nixpkgs-<pkg>` pin の対象外。Step 3b で扱う

**自前パッケージ（対処不可、報告のみ）:**
- 自分の flake や `packages.nix` 内で定義したもの
- `nixpkgs.follows` している以上、nixpkgs 更新のたびリビルドされる

重いソースビルドがなければ Step 5 に進む。
（以前 pin されていたパッケージがここに現れなければ、キャッシュが追いついたので unpin 成功。）

判断に迷う derivation は、どのパッケージに属するか実際に辿って確認する:

```bash
nix-store -q --referrers <drv>
```

### Step 3b: 外部 flake のバイナリキャッシュ設定を確認

外部 flake 由来のパッケージがソースビルドになっている場合、
**まず「キャッシュ設定が古い」を疑う。構成（overlay の選択など）を変える前に確認すること。**

外部 flake は自前のバイナリキャッシュを持つことがあり、その移行に追従できていないと
すべてキャッシュミスになる。まず対象 flake の `nixConfig` を読む:

```bash
SRC=$(nix flake prefetch <flake-url> --json --accept-flake-config \
  | python3 -c "import json,sys;print(json.load(sys.stdin)['storePath'])")
grep -A8 -i nixconfig "$SRC/flake.nix"
```

手元の設定と突き合わせ、URL や公開鍵が変わっていたら更新する。
**substituter の設定は2箇所にあるので両方直す:**

| 場所 | 効く範囲 |
| --- | --- |
| `nix/flake.nix` の `nixConfig` | `--accept-flake-config` 付きの `nix` CLI |
| `nix/modules/darwin/nix-conf.nix` の `determinateNix.customSettings` | システム全体（`/etc/nix/nix.custom.conf`） |

修正後に dry-run し直して解消を確認する。

それでも残る場合、パッケージの取得経路（overlay 経由 / flake output 経由）を
変えれば直るように見えることがあるが、**先に derivation が同一か確認する**:

```bash
nix path-info --derivation "<flake-url>#<pkg>"
```

dry-run に出ている `.drv` と同じパスなら取得経路は無関係で、上流のビルドがまだ
キャッシュに無いだけ。この場合は構成を変えず、ビルドが走ることをユーザーに報告する。

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

### Step 5: 事前ビルド + darwin-switch

sudo が必要なのは activation だけで、**ビルド自体は一般ユーザーで実行できる**。
重いビルドが残っている場合は先に済ませておくと、switch は activation のみになり数十秒で終わる。
ユーザーが sudo のターミナルを長時間占有せずに済む。

```bash
nix build "./nix#darwinConfigurations.${PROFILE}.system" --accept-flake-config --no-link
```

`--no-link` を付けてリポジトリに `result` シンボリックリンクを作らないこと。

ビルド完了後、ユーザーにターミナルで実行してもらう:

```
! just darwin-switch
```

switch が成功したら、`/nix/var/nix/profiles/system` の generation が
新しくなっているか確認してからユーザーに報告する。

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

Step 3b でキャッシュ設定も直した場合はそれも件名に入れ、
本文に「何が変わって何がキャッシュミスしていたか」を書く:

```
nix: flake update (numtide のキャッシュ URL を更新、nh を pin)
```

flake update と無関係な未コミット変更が残っていることがある。
巻き込まずに、扱いをユーザーに確認する。

## 注意事項

- `nix/flake.nix` を編集する際は既存のコードスタイル・コメントスタイルに合わせる
- overlay の順序を崩さない（外部 flake の overlay は最後に来る）
- pin の input には `nixpkgs.follows` を付けない（キャッシュヒットのため意図的に独立させる）
- darwin-switch は `just darwin-switch` 経由で実行する（sudo / HOME の設定が justfile に集約されているため）

### `nix build` と `just darwin-switch` を同時に走らせない

同じ derivation のロックを取り合って**両方とも停止する**ことがある。
先に `nix build` を投げたなら、完了を待ってから switch を実行してもらう。

停止しているかの見分け方（すべて該当すれば止まっている）:

```bash
ps -ax -o user,command | grep '^_nixbld'   # ビルドプロセスが1つも無い
find /nix/store -maxdepth 1 -newermt '-3 minutes' | wc -l   # 新しい store path が増えない
uptime                                      # load average が下がりきっている
```

片方を kill するとロックが解けて再開する。

### 原因は推測で断定せず、実測してから報告する

このフローは「ビルドされる/されない」の判断が中心で、思い込みで構成を変えると
無駄な変更と誤った報告につながる。以下は必ず実測する:

- ソースビルドの原因 → derivation path を突き合わせて同一性を確認する
- ビルドが進んでいない → `_nixbld*` プロセスと store path の増加を確認する
- ビルド失敗かどうか → `/nix/var/log/nix/drvs/` のログを読む
  （非致命的な `ERROR:` 出力もあるので、後続フェーズが動いているかまで見る）

derivation の出力がビルド済みか確認するとき、`nix derivation show` が返す
`outputs.out.path` には `/nix/store/` 接頭辞が付かないことがある。
そのまま存在確認すると全部「未ビルド」に見えるので、接頭辞を補ってから判定する。
