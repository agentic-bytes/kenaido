---
name: kenaido-record-note
description: Record a key finding or a lesson learned in project/notes/. Use after an analysis produces findings worth keeping, and whenever a mistake happens or the user corrects the agent.
---

# Record a note

Applies `ANLY-5`, `ANLY-6`, and `ANLY-9` in [`rules/analysis.md`](../../pack/rules/analysis.md).

## Steps

1. **Pick the file.**
   - A key finding goes in `project/notes/findings.md` (`ANLY-5`).
   - A mistake or correction goes in `project/notes/lessons-learned.md` (`ANLY-6`).
2. **Read the file first.** If an entry already covers it, update that entry instead of adding a duplicate.
3. **Add the entry at the top** (newest first), using the matching template below. Include evidence you can point to (`ANLY-1`) and name people only by role (`COMM-1`).

## Finding template

```markdown
## YYYY-MM-DD: <One-line summary>

- **Summary:** the finding in one sentence.
- **Evidence:** the command, file, or source that shows it.
- **Not verified:** anything still unconfirmed (omit if none).
```

## Lesson template

```markdown
## YYYY-MM-DD: <One-line summary>

- **Applies to:** the roles this matters most for, `team` for how roles work together, or `all roles` (`ANLY-9`).
- **What went wrong:** what happened.
- **Why:** the root cause.
- **Evidence:** what showed it.
- **How to avoid it:** the concrete step to take next time.
```

A lesson about another role's field is welcome when it brings evidence; the role that owns the field confirms or corrects it (`ANLY-9`, `ANLY-8`). If the same lesson keeps coming back, add an improvement item instead of repeating it in reviews (`IMPR-1`).
