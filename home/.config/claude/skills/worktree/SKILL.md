---
name: worktree
description: Create, list, switch, or delete git worktrees for parallel branch work. Use when the user wants to work on multiple branches simultaneously.
argument-hint: "[<branch>] [-d <branch>] [-D <branch>]"
---

# Git Worktree Management

Use `git wt` (git-wt) for all worktree operations. `git worktree` is blocked by hook.

User directive: $ARGUMENTS

## Commands

| Operation       | Command                           |
| --------------- | --------------------------------- |
| Create / switch | `git wt <branch> <base-branch>`   |
| List            | `git wt`                          |
| Delete (safe)   | `git wt -d <branch>`              |
| Delete (force)  | `git wt -D <branch>`              |

## Workflow

### Before creating

1. Ensure uncommitted changes are handled (commit, stash, or discard)
2. Confirm the branch name with the user
3. **Always specify the base branch explicitly** (e.g., `git wt feat-login main`). Never omit the base branch — ask the user if unclear.
4. Branch name must NOT contain `/` — use `-` instead (e.g., `feat-login` not `feat/login`). This avoids nested directory structures in the worktree base directory.

### When deleting

1. Check for uncommitted changes: `git -C <path> status`
2. Warn if there are unpushed commits
3. Confirm before proceeding
