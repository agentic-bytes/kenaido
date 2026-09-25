---
name: kenaido-record-decision
description: Record a decision as an architecture decision record (ADR) in project/decisions/, with context, options, and a recommendation. Use whenever options are laid out for a human to decide, and again when the human decides.
---

# Record a decision

Applies `PRIN-2` and `PRIN-3` in [`rules/principles.md`](../../kenaido/rules/principles.md).

## Steps

1. **Check for an existing record.** Look in `project/decisions/` for a record on the same question. If one exists, update it instead of creating a new one.
2. **Pick the next number.** Use the highest existing number plus one, padded to four digits, and add a short kebab-case title: `NNNN-short-title.md`, for example `NNNN-shared-team-storage.md`.
3. **Fill in the template below.** Back every fact with evidence, such as a link to `project/notes/findings.md` (`ANLY-1`). Name people only by role (`COMM-1`).
4. **Leave the decision to a human.** Keep the status **Proposed** until a human decides. Never mark a record **Accepted** on your own (`PRIN-2`).
5. **Remove blockers first.** Work on every blocker the owner role can resolve with evidence. For the rest, add a decision request in the owner role's name, addressed to the accountable person (`departments/README.md`).
6. **Write the ethics check** (`ETH-5` in [`rules/ethics.md`](../../kenaido/rules/ethics.md)): how the decision affects human life, dignity, joy, and the environment. A concern, an uncertainty, or a one-way door goes to the Ethics Committee before the decision is made.
7. **When the human decides,** fill in **Decision** and **Decided by**, and set the status to **Accepted** or **Rejected**.
8. **Never delete a record.** If a later decision replaces it, set its status to **Superseded by NNNN** and link the new record.

## Template

```markdown
# NNNN: <Title>

- **Date:** YYYY-MM-DD
- **Status:** Proposed | Accepted | Rejected | Superseded by NNNN
- **Owner role:** <the role that drives this decision, e.g. Architect agent>
- **Decided by:** pending (<accountable person's role>)

## Context

What needs deciding, why now, and the evidence (with links).

## Options

| Option | Pros | Cons |
|--------|------|------|
| **A. ...** | ... | ... |

## Recommendation

The recommended option, why (numbered reasons), and the trade-off.

## Blockers

| Blocker | Status | Owner role |
|---------|--------|------------|
| ... | Open, resolved (with evidence), or waiting for a person | ... |

## Ethics check

How this affects human life, dignity, joy, and the environment (`ETH-5`), and whether it raises a concern. A concern goes to the Ethics Committee.

## Decision requests

Requests to people, in the format from `departments/README.md`.

## Decision

Pending.
```
