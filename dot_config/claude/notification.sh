#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

MESSAGE=$(echo "$input" | jq -r '.message')

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
terminal-notifier -message "$ESCAPED_MSG" -title 'Claude Code' -sound default -contentImage 'https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/claude-ai-icon.png'

# Pushover notification
curl -s \
    --form-string "token=${CC_PUSHOVER_API_KEY}" \
    --form-string "user=${CC_PUSHOVER_USER_KEY}" \
    --form-string "message=${NOTIFY_MSG}" \
    --form-string "device=iphone" \
    --form-string "title=Claude Code" \
    https://api.pushover.net/1/messages.json
