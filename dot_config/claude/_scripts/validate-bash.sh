#!/usr/bin/env bash
# Validate specific Bash commands usage

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

# Check for forbidden commands
# Use word boundary matching to avoid false positives (e.g., "category" matching "cat")
if echo "$command" | grep -qE '\bawk\b'; then
  deny "Use of 'awk' is prohibited. Use 'perl' instead. Example: perl -lane 'print \$F[0]' file.txt"
fi

if echo "$command" | grep -qE '\bsed\b'; then
  deny "Use of 'sed' is prohibited. Use 'perl' instead. Example: perl -pi -e 's/old/new/g' file.txt"
fi

if echo "$command" | grep -qE '\bgit\s+push\b.*(-f|--force|--force-with-lease)\b'; then
  deny "Force push (--force / --force-with-lease) is prohibited. Ask the user to execute it if needed."
fi

if echo "$command" | grep -qE '\bgit add (-A|--all|\.($|[ ;|&]))'; then
  deny "Do not git-add all files. Specify the file name(s) to add."
fi

if echo "$command" | grep -qE '\bgit\s+worktree\b'; then
  deny "Use 'git wt' (git-wt) instead of 'git worktree'. Example: git wt <branch>"
fi

if echo "$command" | grep -qE '\bgit\s+wt\s+(prune|delete|remove|rm)\b'; then
  deny "Unknown 'git wt' subcommand. Correct usage:
  - Delete a worktree: git wt -d <branch>  (safe) / git wt -D <branch> (force)
  - List worktrees:    git wt"
fi

if echo "$command" | grep -qE '\bgit\s+wt\b.*\s[^ ]*/[^ ]*'; then
  deny "Branch name must NOT contain '/'. Use '-' instead (e.g., 'feat-login' not 'feat/login'). This avoids nested directory structures in the worktree base directory."
fi

exit 0
