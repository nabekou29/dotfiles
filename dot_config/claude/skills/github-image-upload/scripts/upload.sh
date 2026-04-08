#!/usr/bin/env bash
set -euo pipefail

# GitHub に画像をアップロードし、Markdown 画像リンクを返すスクリプト
#
# 前提:
#   - @playwright/cli がインストール済み（mise install で自動導入）
#   - gh CLI でログイン済み（リポジトリ情報の取得に使用）
#
# 使い方:
#   ./upload.sh <image_file> [repo]
#
# 例:
#   ./upload.sh screenshot.png
#   ./upload.sh screenshot.png unipos/client-web
#
# 出力:
#   成功時: ![<filename>](https://github.com/user-attachments/assets/...)
#   失敗時: exit 1 + stderr にエラーメッセージ
#
# 注意:
#   playwright-cli のセキュリティ制限により、プロジェクトルート配下の
#   ファイルのみアップロード可能。外部ファイルは事前にコピーすること。

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$SCRIPT_DIR/.."
# GITHUB_SESSION_FILE 環境変数で上書き可能（playwright-cli のファイルアクセス制限がある場合に使用）
STATE_FILE="${GITHUB_SESSION_FILE:-$SKILL_DIR/.github-session.json}"

# --- 引数チェック ---

if [ $# -lt 1 ]; then
  echo "エラー: 画像ファイルのパスを指定してください" >&2
  echo "使い方: $0 <image_file> [repo]" >&2
  exit 1
fi

IMAGE_FILE="$1"

if [ ! -f "$IMAGE_FILE" ]; then
  echo "エラー: ファイルが見つかりません: $IMAGE_FILE" >&2
  exit 1
fi

# リポジトリ（owner/repo 形式）
if [ $# -ge 2 ]; then
  REPO="$2"
else
  REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
  if [ -z "$REPO" ]; then
    echo "エラー: リポジトリを検出できません。第2引数で指定してください" >&2
    exit 1
  fi
fi

IMAGE_FILE="$(cd "$(dirname "$IMAGE_FILE")" && pwd)/$(basename "$IMAGE_FILE")"
FILENAME="$(basename "$IMAGE_FILE")"

# playwright-cli はプロジェクトルート配下のファイルのみ許可するため、
# 外部ファイルはプロジェクトルートの .playwright-cli/tmp/ に自動コピーする
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if [[ "$IMAGE_FILE" != "$PROJECT_ROOT"/* ]]; then
  TMP_DIR="$PROJECT_ROOT/.playwright-cli/tmp"
  mkdir -p "$TMP_DIR"
  cp "$IMAGE_FILE" "$TMP_DIR/$FILENAME"
  IMAGE_FILE="$TMP_DIR/$FILENAME"
fi

# --- playwright-cli の確認 ---

if ! command -v playwright-cli &>/dev/null; then
  echo "エラー: playwright-cli が見つかりません" >&2
  echo "インストール: npm install -g @playwright/cli@latest && playwright-cli install" >&2
  exit 1
fi

# --- クリーンアップ関数 ---

cleanup() {
  playwright-cli close 2>/dev/null || true
}
trap cleanup EXIT

# --- ヘルパー: snapshot を取得し YAML ファイルパスを返す ---

take_snapshot() {
  playwright-cli snapshot >/dev/null 2>&1 || true
  # 最新の snapshot ファイルを返す
  ls -t .playwright-cli/page-*.yml 2>/dev/null | head -1 || true
}

# --- ブラウザ起動 & セッション読み込み ---

ISSUE_URL="https://github.com/${REPO}/issues/new?title=&body="

if ! playwright-cli open 2>/dev/null; then
  echo "エラー: ブラウザの起動に失敗しました" >&2
  echo "既にインスタンスが起動中の場合: playwright-cli close-all" >&2
  exit 1
fi

if [ -f "$STATE_FILE" ]; then
  playwright-cli state-load "$STATE_FILE" 2>/dev/null || true
fi

if ! playwright-cli goto "$ISSUE_URL" 2>/dev/null; then
  echo "エラー: ページ遷移に失敗しました: $ISSUE_URL" >&2
  echo "リポジトリの Issues が無効になっている可能性があります" >&2
  exit 1
fi

# --- snapshot を取得してページ状態を確認 ---

SNAPSHOT_YML="$(take_snapshot)"

if [ -z "$SNAPSHOT_YML" ] || [ ! -f "$SNAPSHOT_YML" ]; then
  echo "エラー: snapshot の取得に失敗しました" >&2
  exit 1
fi

# --- ログイン確認 ---

if grep -qi "sign in to github" "$SNAPSHOT_YML"; then
  echo "エラー: GitHub にログインしていません" >&2
  echo "" >&2
  echo "以下を実行してログインしてください:" >&2
  echo "  playwright-cli open https://github.com/login --headed" >&2
  echo "  # ブラウザで手動ログイン後:" >&2
  echo "  playwright-cli state-save $STATE_FILE" >&2
  exit 1
fi

# --- ファイル添付ボタンの ref を取得 ---

ATTACH_REF="$(grep -i "Paste, drop, or click to add files" "$SNAPSHOT_YML" | grep -oE 'ref=e[0-9]+' | head -1 | sed 's/ref=//' || true)"

if [ -z "$ATTACH_REF" ]; then
  echo "エラー: ファイル添付ボタンが見つかりません" >&2
  echo "snapshot: $SNAPSHOT_YML" >&2
  exit 1
fi

# --- click → upload（連続実行が必須：間を空けるとファイルチューザーが閉じる） ---

if ! playwright-cli click "$ATTACH_REF" 2>/dev/null; then
  echo "エラー: ファイル添付ボタンのクリックに失敗しました" >&2
  exit 1
fi
if ! playwright-cli upload "$IMAGE_FILE" 2>/dev/null; then
  echo "エラー: ファイルのアップロードに失敗しました: $IMAGE_FILE" >&2
  exit 1
fi

# --- アップロード完了を待って URL を抽出 ---

IMAGE_URL=""
MAX_RETRIES=10
RETRY_INTERVAL=2

for i in $(seq 1 "$MAX_RETRIES"); do
  sleep "$RETRY_INTERVAL"

  SNAPSHOT_YML="$(take_snapshot)"

  if [ -n "$SNAPSHOT_YML" ] && [ -f "$SNAPSHOT_YML" ]; then
    # GitHub は <img> タグで挿入する:
    #   <img ... src="https://github.com/user-attachments/assets/..." />
    IMAGE_URL="$(grep -oE 'https://github\.com/user-attachments/assets/[a-f0-9-]+' "$SNAPSHOT_YML" | head -1 || true)"
    if [ -n "$IMAGE_URL" ]; then
      break
    fi
  fi
done

# --- セッション保存 ---

playwright-cli state-save "$STATE_FILE" 2>/dev/null || true
chmod 600 "$STATE_FILE" 2>/dev/null || true

if [ -z "$IMAGE_URL" ]; then
  echo "エラー: アップロード後に画像 URL を取得できませんでした" >&2
  echo "snapshot: $SNAPSHOT_YML" >&2
  exit 1
fi

# --- 結果出力 ---

# Markdown リンクの構文が壊れないようファイル名の ] と [ をエスケープ
SAFE_FILENAME="${FILENAME//\[/\\[}"
SAFE_FILENAME="${SAFE_FILENAME//\]/\\]}"

echo "![${SAFE_FILENAME}](${IMAGE_URL})"
