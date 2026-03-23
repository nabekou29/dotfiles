---
name: commit
description: Commit changes by splitting into logical units with Conventional Commits format. Checks for false positive changes and auto-detects commit message language from git history.
argument-hint: "[short] [co] [single] [one]"
---

# Commit Changes

Commit changes from HEAD by splitting them into logical commits.

User directive: $ARGUMENTS

## Options

| Keyword | Rule |
| ------- | ---- |
| short | Title-only commit messages without body. |
| co | Include `Co-Authored-By` trailer. |
| single | Create a single commit without splitting. |
| one | Commit only one of the split changes. |

## Process

### 1. Unstage all currently staged files

To avoid accidentally including unwanted changes:

```
git reset
```

### 2. Undo WIP commit if present

If the previous commit message starts with `WIP`, undo it:

```
git reset HEAD~1
```

### 3. Review diff for false positives

Run `git diff` and check for unintended changes unrelated to the task:
- Formatting-only changes (whitespace, trailing commas, line breaks)
- Unrelated import additions/removals
- Auto-generated file modifications not relevant to the task

**Revert any such changes before proceeding** using `git checkout -- <file>` or `git restore -p`.

### 4. Check for documentation gaps

Review the changes and verify that related documentation is up to date:
- README, CLAUDE.md, or other docs that reference changed behavior
- Inline comments that describe logic which has been modified
- Configuration examples if defaults or options have changed

**Update any stale documentation before proceeding.**

### 5. Determine commit message language

Run `git log --oneline -20` and detect the dominant language used in recent commit messages. Use that language for the new commit messages. User directives take precedence.

### 6. Split and commit

Split changes into logical units by type and scope:
- **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
  - `refactor`: Use **only** when the change has zero effect on user-facing behavior (no API, CLI, UI, or output changes). If any external behavior changes, use `feat`, `fix`, or another appropriate type instead.
- **scope**: The feature or area affected (e.g., `utils`, `api`, `web`, `cli`)

## Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/).

### Subject line

- Imperative mood: `fix: resolve memory leak` (not `resolved` / `resolves`)
- Lowercase after type: `feat: add parser` (not `Add`)
- No trailing period
- Max 72 characters

### Body

Explain **why** this change was made, **what** problem it solves, and **how** it affects the system.

### Granularity

- One commit, one purpose — don't mix features with fixes or unrelated refactoring
- Each commit should be self-contained and buildable
