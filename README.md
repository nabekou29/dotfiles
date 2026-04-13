# dotfiles

My dotfiles managed by [chezmoi](https://www.chezmoi.io/)

## セットアップ

### 1. Determinate Nix のインストール

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. chezmoi の初期化

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nabekou29
```

### 3. nix-darwin の初回セットアップ

初回は `darwin-rebuild` / `just` がまだインストールされていないため、`nix run` でブートストラップする。

```sh
nix run nix-darwin -- switch --flake "$HOME/.local/share/chezmoi/nix#default"
```

### 4. 以降の更新

`just` がインストールされた後は以下のコマンドで更新できる。

```sh
just darwin-switch   # 設定を反映
just darwin-update   # flake 更新 + 設定を反映
```
