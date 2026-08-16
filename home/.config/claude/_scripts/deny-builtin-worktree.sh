#!/usr/bin/env bash
# Block Claude's built-in worktree tools — use 'git wt' instead

jq -n '{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Built-in worktree is disabled. Use '\''git wt'\'' (git-wt) instead. Example: git wt <branch>"
  }
}'
exit 0
