# Chezmoi Dotfiles Repository

## Repository Structure

- `dot_config/claude/` — ユーザーグローバルの Claude Code 設定（`~/.config/claude/` にデプロイされる）
- `.claude/` — このリポジトリ固有の Claude Code プロジェクト設定

## chezmoi の管理方式

ファイルはシンボリックリンク方式で管理される。

## 設定の配置ルール

| 対象                                  | 配置先               | 例                                      |
| ------------------------------------- | -------------------- | --------------------------------------- |
| chezmoi リポジトリ固有の hook・ルール | `.claude/`           | `rm` の禁止、`chezmoi apply` のブロック |
| 全プロジェクト共通の Claude Code 設定 | `dot_config/claude/` | keybindings, skills, global hooks       |
