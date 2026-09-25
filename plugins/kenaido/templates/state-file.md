# Task state file template

The state file for a Sprint's delegated work (`CONT-9`): every part, its role, its brief and result file, its status, and its tokens against budget; every working session and whether it closed with its records in place; and one total. It lives in the git-ignored working folder, for example `.work/sprint-<NN>/STATUS.md`, so only a local check can read it (`SCRUM-17`). The Developers own it, and update it at every launch, return, merge, and session end.

**What the Sprint step check reads** (`SCRUM-17`, `product/docs/sprint-steps.md`, steps 5, 7, 11, 15 and 16):

- **Parts:** every row whose Part is `P<n>` names its brief in backticks, as `tasks/<file>.md` (in the Sprint's folder) or a path from the repository root, and its result file in backticks, from the repository root. Both must exist. A row whose Status starts with "done" has a token figure before the `/`.
- **Sessions:** every row whose Status is `closed` has a Daily entry headed with the same date, and names the part row of the Scrum Master agent's session check, whose result file exists.
- **Total:** one `**Total (harness):**` line, equal to the sum of the parts' token figures.

Note lines may sit between rows; the check reads a table until the next heading.

```markdown
# Sprint <N> — task state (`CONT-9`)

## Parts

| Part | Role | Instance | Brief | Result file | Status | Last update | Tokens (harness) / budget | Notes |
|------|------|----------|-------|-------------|--------|-------------|---------------------------|-------|
| P<n> | <role> | <new, or which instance it continues> | `tasks/<brief>.md` | `.work/sprint-<NN>/<result>.md` | <launched, in progress, stopped (reason), done> | <YYYY-MM-DD> | <the tool's own count, not the agent's estimate> / <budget> | <what the part is> |

**Total (harness):** <the sum of the token figures above>

## Sessions

| Session | Date | Status | Session check | Notes |
|---------|------|--------|---------------|-------|
| S<n> | <YYYY-MM-DD> | <open, or closed once its Daily entry, Sprint Backlog, this file, the handoff note and the session check are in place> | <the part row of the Scrum Master agent's session check, e.g. P<n>> | <what the session covered> |
```
