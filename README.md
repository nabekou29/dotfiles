# dotfiles

[mise](https://mise.jdx.dev/) の bootstrap 機能と Homebrew で管理している dotfiles。

- `home/` — `$HOME` に symlink される設定ツリー（実名。`mise.toml` の `[dotfiles]` が対応を宣言）
- `templates/` — シークレットを埋め込んで生成するファイル（1Password の `op inject`）
- `mise.toml` — dotfiles・macOS 設定・タスクの宣言
- `home/.config/mise/config.toml` — dev ツール（ランタイム / LSP / linter）の定義
- `home/.config/homebrew/Brewfile` — CLI ユーティリティ / GUI アプリ / フォント / Mac App Store

## セットアップ

```sh
ghq get nabekou29/dotfiles
cd ~/ghq/github.com/nabekou29/dotfiles
./scripts/bootstrap.sh
```

profile (work/private) を聞かれる。シークレットの取得に 1Password CLI の認証が必要。

## 日常の操作

| やること | コマンド |
| --- | --- |
| symlink 済みディレクトリ内のファイル追加・削除 | 不要（symlink 越しに反映される） |
| 新しい設定を管理下に置く | `mise.toml` に `[dotfiles]` エントリを追加して `mise bootstrap dotfiles apply` |
| 管理をやめる | `mise bootstrap dotfiles unapply <target>` してエントリを削除 |
| マシン全体を宣言に合わせる | `mise bootstrap --yes` |
| パッケージを適用・更新 | `mise run packages` / `mise run update` |
| 適用前に差分を見る | `mise bootstrap plan` / `mise bootstrap dotfiles status` |

## プロファイル (work / private)

`~/.config/mise/miserc.toml` の `env` 指定が単一ソース（マシン固有なので repo では管理しない）。

```toml
env = ["private"]
```

Brewfile はこの値を読んで profile ごとのパッケージを出し分ける。

## プロジェクトの dev shell を使う場合

nix の dev shell（`use flake`）を使うプロジェクトがあるなら Determinate Nix を入れる。
direnv と nix-direnv の設定は dotfiles 側で用意済み。

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
