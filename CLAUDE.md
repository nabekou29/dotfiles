# Dotfiles Repository

## Repository Structure

- `home/` — `$HOME` に symlink される設定ツリー（`home/.config/nvim` → `~/.config/nvim`）
- `home/.config/claude/` — ユーザーグローバルの Claude Code 設定
- `templates/` — シークレット埋め込みで生成するファイル（`op inject`）
- `scripts/` — bootstrap 等の手続き的な処理
- `mise.toml` — dotfiles・macOS 設定・タスクの宣言
- `.claude/` — このリポジトリ固有の Claude Code プロジェクト設定

## 管理方式

`mise.toml` の `[dotfiles]` が `$HOME` のパスと `home/` 以下のソースの対応を宣言する。
反映は `mise bootstrap dotfiles apply`、マシン全体の収束は `mise bootstrap --yes`。

symlink の粒度は2種類ある。

- **ディレクトリ単位** — 純粋な設定ディレクトリ。中のファイルを追加・削除しても
  エントリを触らずに反映される
- **glob (`dir/*`)** — アプリがログ・状態・生成物を書いたり、マシン固有のファイルが
  同居する場合（claude / herdr / zsh / mise / homebrew / hunk / `.local/bin`）。
  ディレクトリ単位にすると それらがリポジトリに流れ込むため。何が張られるかは
  `home/` 以下の中身がそのまま宣言になる

glob の代償として、`home/` 側に足したものは `mise dotfiles apply` を再実行するまで
張られず、消してもリンク切れは残る（mise は prune しない）。

`~/.config/claude/` 直下だけは glob にできない。`skills` をディレクトリ丸ごと
張ってしまい `~/.config/claude/skills/*` の宣言と衝突するため、個別に列挙している。

`~/.zshenv` だけは symlink ではなく `op inject` で生成する実ファイル。

## コミットメッセージ

Conventional Commits は使わない。`scope: 説明` 形式を使う。

```
nvim: diffview のキーバインドを追加
mise: macOS defaults を bootstrap ネイティブに移植
wezterm: kitty keyboard protocol を有効化
```

## 設定の配置ルール

| 対象                                    | 配置先                  | 例                                |
| --------------------------------------- | ----------------------- | --------------------------------- |
| このリポジトリ固有の hook・ルール       | `.claude/`              | リポジトリ固有の禁止コマンド      |
| 全プロジェクト共通の Claude Code 設定   | `home/.config/claude/`  | keybindings, skills, global hooks |
