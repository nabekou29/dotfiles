# dotfiles

My dotfiles managed by [chezmoi](https://www.chezmoi.io/) + [mise](https://mise.jdx.dev/) + Homebrew

- dotfiles の配置・シークレット埋め込み・フック: chezmoi
- dev ツール (ランタイム / LSP / linter): mise (`~/.config/mise/config.toml`)
- シェルユーティリティ / GUI アプリ / フォント: Homebrew (`~/.config/homebrew/Brewfile`)

## セットアップ

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nabekou29
```

- profile (work / private) を聞かれるので入力する
- シークレット埋め込みに 1Password CLI の認証が必要
- 初回 apply が Homebrew と mise を導入し、`mise run bootstrap` で
  Brewfile / mise tools / macOS 設定 / Touch ID sudo まで適用される

## 以降の更新

```sh
mise run apply    # Brewfile と mise tools を適用
mise run update   # brew と mise tools を更新
```

## プロジェクトの dev shell 用 (任意)

nix の dev shell (`use flake`) を使うプロジェクトで作業する場合は Determinate Nix を入れる:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

direnv + nix-direnv の設定は chezmoi が配置する。
