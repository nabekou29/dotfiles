# dotfiles

[mise](https://mise.jdx.dev/) の bootstrap 機能と Homebrew で管理する macOS の dotfiles。

## 構成

- `home/` — `$HOME` に symlink される設定ツリー
- `mise.toml` — dotfiles・macOS 設定・タスクの宣言
- `templates/` — シークレットを埋め込んで生成するファイル
- `scripts/` — bootstrap
- `karabiner/` — Karabiner 設定のビルド元

## セットアップ

```sh
ghq get nabekou29/dotfiles
cd ~/ghq/github.com/nabekou29/dotfiles
./scripts/bootstrap.sh
```

profile (work / private) を聞かれる。シークレットの取得に 1Password CLI の認証が必要。
