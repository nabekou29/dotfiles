---
name: configure-hooks
description: Add or modify Claude Code hooks to block commands, react to file changes, or enforce project rules via PreToolUse/PostToolUse scripts and settings.json.
argument-hint: "<what to configure>"
---

# Configure Claude Code Hooks

User directive: $ARGUMENTS

## Scope Selection

Determine where to apply the configuration based on scope:

| Scope | settings.json | Scripts |
| ----- | ------------- | ------- |
| Global (all projects) | `~/.config/claude/settings.json` | `~/.config/claude/_scripts/` |
| Project-specific | `.claude/settings.json` | `.claude/_scripts/` |

Ask the user if the scope is ambiguous.

## Hook Patterns

### PreToolUse: Block a Bash command (deny)

Add a check to the existing `validate-bash.sh` script. Do NOT create a new hook entry in settings.json if one already exists for `Bash`.

**Pattern** — append before the final `exit 0`:

```bash
if echo "$command" | grep -qE '<REGEX>'; then
  deny "<REASON>. <ALTERNATIVE>"
fi
```

### PreToolUse: Advise (additionalContext)

Provides context without blocking. Useful for non-Bash tools (e.g., Edit, Write) where Claude can act on the advice. **Not effective for Bash commands** — Claude tends to ignore additionalContext and run the command anyway. For Bash, prefer `deny` with a clear alternative.

```bash
if echo "$command" | grep -qE '<REGEX>'; then
  advise "<CONTEXT>"
fi
```

### Choosing deny vs advise

| Use | When |
| --- | ---- |
| `deny` | **Default for Bash commands.** Block and suggest alternative. Also for interactive auth or destructive commands |
| `advise` | Non-Bash tools only. When a better approach exists but the original is still valid |

When a condition can be mechanically verified (e.g., `git status -sb` to check if ahead of remote), use `deny` with the check — don't rely on advise hoping Claude will make the right call.

### Regex guidelines

- Use `\b` word boundaries to avoid false positives (e.g., `\bawk\b` so "gawk" doesn't match "awk")
- Use `(^|[;&|])\s*` prefix when the command could appear after a separator
- The deny message should explain **why** it's blocked and suggest an **alternative**
- For commands requiring interactive auth, suggest `! <command>` so the user runs it themselves

### PreToolUse: validate-bash.sh scaffold

If the validate-bash.sh script doesn't exist yet, create it with this scaffold:

```bash
#!/usr/bin/env bash
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

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

exit 0
```

### PreToolUse: Block a non-Bash tool

For non-Bash tools, add a separate hook entry in settings.json with an appropriate `matcher`.

### PostToolUse: React to file changes

Add a hook entry with `matcher: "Edit|Write"` and a script that reads `tool_input.file_path` from stdin JSON.

### settings.json hook entry

When adding a new hook entry to settings.json, follow this structure:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "<path-to-script>"
          }
        ]
      }
    ]
  }
}
```

- Global scripts: `"\"$CLAUDE_CONFIG_DIR\"/_scripts/<name>.sh"`
- Project scripts: `".claude/_scripts/<name>.sh"`

## Permission Rules

For simple allow/deny without custom logic, prefer `permissions` in settings.json over hooks:

```json
{
  "permissions": {
    "deny": ["Bash(sudo:*)"],
    "allow": ["Bash(git add:*)"]
  }
}
```

Use hooks only when you need custom logic, context-aware decisions, or informative deny messages.
