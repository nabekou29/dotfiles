#!/usr/bin/env bash
# chezmoi リポジトリ内では rm/rmdir の代わりに chezmoi destroy を使う

# Read JSON input from stdin
input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only validate Bash tool
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# Deny with JSON hookSpecificOutput
deny() {
  jq -n --arg reason "$1" '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": $reason
    }
  }'
  exit 0
}

if echo "$command" | grep -qE '(^|[;&|])\s*rm(dir)?\b'; then
  deny "Use 'chezmoi destroy -r <target>' instead of rm/rmdir. It removes the file from source, target, and state in one step."
fi

exit 0
