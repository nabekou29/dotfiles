#!/usr/bin/env bash
# chezmoi リポジトリ内では rm/rmdir の代わりに chezmoi destroy を使う

# Read JSON input from stdin
input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')
cwd=$(echo "$input" | jq -r '.cwd // ""')

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

# rm/rmdir は chezmoi source dir 配下での作業のみ block する
# (他リポジトリでの通常の rm 操作は許可)
chezmoi_src="$HOME/.local/share/chezmoi"
if [[ "$cwd" == "$chezmoi_src" || "$cwd" == "$chezmoi_src"/* ]]; then
  if echo "$command" | grep -qE '(^|[;&|])\s*rm(dir)?\b'; then
    deny "Use 'chezmoi destroy -r <target>' instead of rm/rmdir. It removes the file from source, target, and state in one step."
  fi
fi

# chezmoi apply は cwd に関係なく常に block
if echo "$command" | grep -qE '(^|[;&|])\s*chezmoi\s+apply\b'; then
  deny "chezmoi apply requires 1Password authentication. Ask the user to run it themselves with: ! chezmoi apply"
fi

exit 0
