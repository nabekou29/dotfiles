# Chezmoi Dotfiles Repository

## Repository Structure

- `dot_config/claude/` — ユーザーグローバルの Claude Code 設定（`~/.config/claude/` にデプロイされる）
- `.claude/` — このリポジトリ固有の Claude Code プロジェクト設定

## chezmoi の管理方式

ファイルはシンボリックリンク方式で管理される。

## コミットメッセージ

Conventional Commits は使わない。`scope: 説明` 形式を使う。

```
nvim: diffview のキーバインドを追加
nix: herdr をフォークに切り替え
wezterm: kitty keyboard protocol を有効化
```

## 設定の配置ルール

| 対象                                  | 配置先               | 例                                      |
| ------------------------------------- | -------------------- | --------------------------------------- |
| chezmoi リポジトリ固有の hook・ルール | `.claude/`           | `rm` の禁止、`chezmoi apply` のブロック |
| 全プロジェクト共通の Claude Code 設定 | `dot_config/claude/` | keybindings, skills, global hooks       |
