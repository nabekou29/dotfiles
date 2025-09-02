# Commit Changes

**MUST USE the logical-committer agent.**

Commit changes from HEAD by properly splitting them into logical commits.

User directive: $ARGUMENTS

## Arguments

**When user directive contains keywords, you MUST follow the rules for each keyword strictly.**

| Keyword | Rule                                              |
| ------- | ------------------------------------------------- |
| ja      | Create commit messages in Japanese.               |
| en      | Create commit messages in English.                |
| short   | Create title-only commit messages without body.   |
| co      | Include Co-authored-by in commit messages.        |
| single  | Create a single commit without splitting changes. |
| one     | Commit only one of the split changes.             |

## Process

1. Unstage all currently staged files.

**Be sure to do this to avoid accidentally making unwanted changes to your commits.**

`git reset`

2. If the previous commit message starts with WIP, undo the previous commit first.

`git reset HEAD~1`

3. Split and commit changes appropriately considering type and scope.
   - **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
   - **scope**: Indicates the feature or area affected by the change. Examples: `utils`, `api`, `web`, `cli`, `user-settings`, `admin-page`

## Commit Rules

Create commit messages following Conventional Commits rules.
Default language is Japanese, but user directives take precedence.

## How to Write Good Commit Messages

### Subject Line Rules

1. **Use imperative mood**
   - ✅ `fix: resolve memory leak`
   - ❌ `fix: resolved memory leak`
   - ❌ `fix: resolves memory leak`

2. **Lowercase first letter after type**
   - ✅ `feat: add new parser`
   - ❌ `feat: Add new parser`

3. **No period at the end**
   - ✅ `docs: update installation guide`
   - ❌ `docs: update installation guide.`

4. **Keep within 72 characters**
   - Be concise yet descriptive

### Body Guidelines

The body should explain:

- **Why** this change was made
- **What** problem it solves
- **How** it affects the system

### Commit Granularity

1. **One commit, one purpose**
   - Don't mix feature additions with fixes
   - Don't include unrelated refactoring

2. **Maintain atomicity**
   - Each commit should be self-contained
   - Project should build and pass tests after each commit

3. **Split into logical units**

   ```
   # Good example - separated by purpose
   feat(completion): add basic i18n key completion
   test(completion): add completion provider tests
   docs: document completion feature usage

   # Bad example - multiple purposes mixed
   feat(completion): add completion with tests and docs
   ```

## Message Examples

These are examples only. Adjust scope and messages according to the actual project.

### User directive: `ja short`

```
fix(utils): truncate に負の値を渡すとエラーが発生する問題を修正
```

### User directive: `ja short`

```
fix(utils): truncate に負の値を渡すとエラーが発生する問題を修正
```

### User directive: `co`

```
fix(utils): truncate に負の値を渡すとエラーが発生する問題を修正

- 負の値を渡すと `index out of range` エラーが発生していた
- 負の値を渡すと空文字列を返すように修正
- テストケースを追加

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### User directive: `en`

```
feat: add new user authentication flow

- Implement new OAuth 2.0 authentication flow
- Update user model to include OAuth tokens
- Add tests for new authentication endpoints
```
