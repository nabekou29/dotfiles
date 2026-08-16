---
name: default-pr
description: Create a pull request. Follows PR templates if present. Validates checklist items via sub-agents before submitting.
argument-hint: "[draft] [base=BRANCH]"
disable-model-invocation: true
---

# Create Pull Request

Create a pull request for the current branch.

User directive: $ARGUMENTS

## Options

| Keyword | Rule |
| ------- | ---- |
| draft | Create as a draft PR. |
| base=BRANCH | Specify the base branch (default: auto-detect). |

## Process

### 1. Resolve base branch

Determine the base branch using the same resolution order as `gh pr create`:

1. User-specified `base=BRANCH` argument — use it directly.
2. `git config branch.<current-branch>.gh-merge-base` — per-branch config.
3. `gh repo view --json defaultBranchRef -q '.defaultBranchRef.name'` — repo default.

Show the resolved base branch to the user and ask for confirmation before proceeding.

### 2. Gather context

Run the following in parallel:

- `git status` — check for uncommitted changes
- `git log --oneline <base>..HEAD` — list commits to be included
- `git diff <base>...HEAD --stat` — summarize changed files

If there are uncommitted changes, warn the user and ask whether to proceed or commit first.

If there are no commits ahead of base, abort with a message.

### 3. Check for PR template

Run the following command to find PR templates:

```bash
root=$(git rev-parse --show-toplevel)
# Single templates
find "$root" "$root/docs" "$root/.github" \
  -maxdepth 1 -iname "pull_request_template.md" 2>/dev/null
# Multiple templates directories
find "$root/PULL_REQUEST_TEMPLATE" \
     "$root/docs/PULL_REQUEST_TEMPLATE" \
     "$root/.github/PULL_REQUEST_TEMPLATE" \
  -maxdepth 1 -iname "*.md" 2>/dev/null
```

If multiple templates are found, select the most appropriate one based on the branch name, commit contents, and changed files. If the appropriate template cannot be determined, ask the user to choose.

### 4. Validate checklist (if template has one)

If the template contains a checklist (`- [ ]` items), spawn **parallel sub-agents** to verify each item against the actual code and commits. Each agent should:

- Inspect the relevant code, tests, or config
- Report pass/fail with a one-line reason

Present the results to the user as a table before proceeding. If any item fails, ask the user whether to continue anyway.

### 5. Draft the PR body

- **With template**: Fill in each section of the template based on the commits and diff. Check off validated checklist items with `- [x]`.
- **Without template**: Use this format:

```markdown
## Summary
<1-3 bullet points describing the change>

## Test plan
<How to verify the change>
```

### 6. Determine PR title

Analyze the commits:

- Single commit: Use its subject line as the PR title.
- Multiple commits: Summarize the overall change in one line (max 70 chars).

Follow the same language and format conventions as the commit messages.

### 7. Create the PR

```
gh pr create --title "TITLE" --body "$(cat <<'EOF'
BODY
EOF
)" --base <resolved-base>
```

Add `--draft` if the `draft` option was specified.

Always pass `--base` with the resolved base branch from step 1.

### 8. Output the PR URL

Print the resulting PR URL so the user can open it.
