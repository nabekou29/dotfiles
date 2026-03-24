#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

MESSAGE=$(echo "$input" | jq -r '.message')
CWD=$(echo "$input" | jq -r '.cwd // ""')

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

# Build remote control URL from JWT session token
REMOTE_URL=""
if [[ -n "$CLAUDE_CODE_SESSION_ACCESS_TOKEN" ]]; then
  payload=$(echo "$CLAUDE_CODE_SESSION_ACCESS_TOKEN" | cut -d. -f2 | tr '_-' '/+')
  SESSION_ID=$(echo "${payload}==" | base64 -d 2>/dev/null | jq -r '.session_id // empty')
  if [[ -n "$SESSION_ID" ]]; then
    REMOTE_URL="https://claude.ai/code/${SESSION_ID/cse_/session_}"
  fi
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
curl -s "${PUSHOVER_ARGS[@]}" https://api.pushover.net/1/messages.json
