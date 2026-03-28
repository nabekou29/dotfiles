---
name: worktree
description: Create, list, switch, or delete git worktrees for parallel branch work. Use when the user wants to work on multiple branches simultaneously.
argument-hint: "[<branch>] [-r <branch>] [--clean]"
---

# Git Worktree Management

Use `git wt` (git-wt) for all worktree operations. `git worktree` is blocked by hook.

User directive: $ARGUMENTS

## Commands

| Operation       | Command              |
| --------------- | -------------------- |
| Create / switch | `git wt <branch>`    |
| List            | `git wt`             |
| Delete          | `git wt -r <branch>` |
| Clean merged    | `git wt --clean`     |

## Workflow

### Before creating

1. Ensure uncommitted changes are handled (commit, stash, or discard)
2. Confirm the branch name with the user
3. Branch name must NOT contain `/` — use `-` instead (e.g., `feat-login` not `feat/login`). This avoids nested directory structures in the worktree base directory.

### When deleting

1. Check for uncommitted changes: `git -C <path> status`
2. Warn if there are unpushed commits
3. Confirm before proceeding
