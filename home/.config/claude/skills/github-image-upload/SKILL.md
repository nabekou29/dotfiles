---
name: github-image-upload
description: GitHub に画像をアップロードし Markdown 画像リンクを返す。PR 作成や Issue 作成時に画像を添付したい場合に使用。
scripts:
  sh: ~/.config/claude/skills/github-image-upload/scripts/upload.sh
---

## ユーザー入力

```text
$ARGUMENTS
```

`$ARGUMENTS` にはアップロードする画像ファイルのパスを指定する。
オプションで第2引数にリポジトリ（`owner/repo` 形式）を指定可能。省略時は `gh repo view` で自動検出する。

## 概要

playwright-cli で GitHub の Issue 作成画面（`/issues/new?title=&body=`）を開き、ファイル添付 UI 経由で画像をアップロードする。
アップロード後に `![filename](https://github.com/user-attachments/assets/...)` 形式の Markdown リンクを返す。

GitHub は画像アップロードの公開 API を提供していないため、ブラウザ UI の操作が必要。

## 前提条件

- `@playwright/cli` がインストール済み（`npm install -g @playwright/cli@latest`）
- `gh` CLI でログイン済み（リポジトリ情報の取得に使用）
- GitHub にブラウザでログイン済みのセッション（`.github-session.json`）があること

## 使い方

### 単一画像のアップロード

```bash
{SCRIPT} /path/to/image.png
```

### リポジトリを明示的に指定

```bash
{SCRIPT} /path/to/image.png owner/repo
```

### 出力

成功時、stdout に Markdown 画像リンクが出力される:

```
![screenshot.png](https://github.com/user-attachments/assets/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
```

### 備考

playwright-cli はプロジェクトルート配下のファイルのみ許可する。
プロジェクト外のファイル（`/tmp/` 等）を指定した場合、スクリプトが自動的にスキルの `tmp/` ディレクトリにコピーしてからアップロードする。

## 他スキルからの呼び出し

このスキルは単体で使うほか、PR 作成や Issue 作成のワークフローから呼び出すことを想定している。

```bash
IMAGE_MD="$({SCRIPT} screenshot.png)"
gh pr create --title "UIの改善" --body "## スクリーンショット
${IMAGE_MD}"
```

## 初回セットアップ（ログイン）

セッション情報がない場合、スクリプトはエラーで終了し手順を案内する。
以下を実行して GitHub のセッションを保存する:

```bash
# プロジェクトルートから実行すること
playwright-cli open https://github.com/login --headed
# ブラウザで手動ログイン後:
playwright-cli state-save ~/.config/claude/skills/github-image-upload/.github-session.json
playwright-cli close
```

セッションは `~/.config/claude/skills/github-image-upload/.github-session.json` に保存され、以降は自動で読み込まれる。

## トラブルシューティング

### playwright-cli が見つからない

```bash
npm install -g @playwright/cli@latest
playwright-cli install
```

### セッション期限切れ

GitHub のセッション Cookie には有効期限がある。ログイン状態が切れた場合は初回セットアップの手順を再実行する。

### ファイル添付ボタンが見つからない

GitHub の UI 変更により要素の検出に失敗する可能性がある。
スクリプトが snapshot ファイルパスを stderr に出力するので、YAML の中身を確認して `scripts/upload.sh` の grep パターンを更新する。

### ブラウザプロセスが残った場合

スクリプトが異常終了した場合、ブラウザプロセスが残ることがある:

```bash
playwright-cli close-all
```
