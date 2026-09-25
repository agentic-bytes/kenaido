---
name: start-change
description: Start a new change (feature, fix, docs, chore, and so on) on a correctly named branch cut from the latest origin/main, and commit with the right message format. Use before editing any file for a new change, and again before every commit.
---

# Start a change

Applies `GIT-1` to `GIT-6` and `NAME-1` to `NAME-3` in [`rules/git-workflow.md`](../../rules/git-workflow.md).

## Steps

1. **Check where you are.** Run `git branch --show-current`. If it prints `main`, don't edit anything yet (`GIT-1`).
2. **Name the branch.** Pick a type from `NAME-1` and a short kebab-case description (`NAME-2`), e.g. `feat/sprint-board`.
3. **Create the branch from the latest `main`** (`GIT-2`):
   ```bash
   git fetch origin
   git switch --no-track -c <type>/<short-description> origin/main
   ```
   Use a different base branch only when the user explicitly says so for this change.
4. **Plan before coding.** For code changes, make a plan first and share it when the change is significant (`CODE-2`, `CODE-3` in [`rules/coding.md`](../../rules/coding.md)).
5. **Commit on this branch only.** Before each commit, confirm the branch isn't `main` (`GIT-3`). Write the message as `<type>: <short description>`, in the imperative, lowercase, no trailing period (`NAME-3`), e.g. `feat: add sprint board columns`.
   - Run `git add <new files>` first: git only commits named paths it already knows.
   - Then name the files in the commit itself, `git commit -m "<message>" -- <paths>`, so files staged by other tools (e.g. an IDE) don't slip in.
   - Check the result with `git show --stat HEAD`.
6. **Stop before pushing.** Don't push, open a pull request, or merge unless the user explicitly authorizes that specific action, or an exceptional push delegation for a stated scope and period is in force and recorded (`GIT-4`). A delegation never covers `main`, tags, or releases. A human approves every pull request below autonomy level 3 (`GIT-6`).
