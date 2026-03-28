#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

MESSAGE=$(echo "$input" | jq -r '.message')
CWD=$(echo "$input" | jq -r '.cwd // ""')
TRANSCRIPT_PATH=$(echo "$input" | jq -r '.transcript_path // ""')

# Build title with repo/worktree name
if git -C "$CWD" rev-parse --is-inside-work-tree &>/dev/null; then
  REPO_NAME=$(git -C "$CWD" remote get-url origin 2>/dev/null | perl -pe 's/.*\///; s/\.git//')
  WORKTREE_NAME=$(basename "$(git -C "$CWD" rev-parse --show-toplevel)")
  if [[ -n "$REPO_NAME" && "$REPO_NAME" != "$WORKTREE_NAME" ]]; then
    TITLE="Claude Code: ${REPO_NAME} (${WORKTREE_NAME})"
  else
    TITLE="Claude Code: ${WORKTREE_NAME}"
  fi
else
  TITLE="Claude Code: $(basename "$CWD")"
fi

# Extract remote control URL from the latest bridge_status entry in transcript
# (resume/continue creates a new entry, so we need the last one)
REMOTE_URL=""
if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
  REMOTE_URL=$(jq -sr '[.[] | select(.subtype == "bridge_status") | .url] | last' "$TRANSCRIPT_PATH")
fi

case "$MESSAGE" in
  'Claude is waiting for your input')
    NOTIFY_MSG="入力を待っています"
    ;;
  'Claude Code login successful')
    # do nothing
    exit 0
    ;;
  'Claude needs your permission to use '*)
    NOTIFY_MSG="${MESSAGE#Claude needs your permission to use }の許可が必要です"
    ;;
  *)
    NOTIFY_MSG="${MESSAGE}"
    ;;
esac

# Desktop notification
ESCAPED_MSG="${NOTIFY_MSG//\[/\\[}"
terminal-notifier -message "$ESCAPED_MSG" -title "$TITLE" -sound default -contentImage 'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/claude-ai-icon.png'

# Pushover notification
PUSHOVER_ARGS=(
    --form-string "token=${CC_PUSHOVER_API_KEY}"
    --form-string "user=${CC_PUSHOVER_USER_KEY}"
    --form-string "message=${NOTIFY_MSG}"
    --form-string "device=iphone"
    --form-string "title=${TITLE}"
)
if [[ -n "$REMOTE_URL" ]]; then
    PUSHOVER_ARGS+=(--form-string "url=${REMOTE_URL}" --form-string "url_title=Open Remote Control")
fi
curl -s "${PUSHOVER_ARGS[@]}" https://api.pushover.net/1/messages.json > /dev/null
