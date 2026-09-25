# Daily Scrum log template

The Daily Scrum record for one Sprint: one short entry per working session, held by the Developers, not the Scrum Master (`SCRUM-9`, the Daily Scrum's own time limit). The new-sprint script writes the block below into the new Sprint's `daily.md` when the Sprint's folder is created ([`start-sprint`](../skills/kenaido-start-sprint/SKILL.md)); don't create this file by hand. It starts "not held yet," and gains one entry per working session from then on. An event is not held until its record exists (`SCRUM-9`).

```markdown
# Sprint <N> — Daily Scrum log

**Not held yet.** Created when the Sprint started, and filled in at each working session from then on.
```

**At each working session,** append an entry in this shape, keeping every earlier one (`CONT-7`):

```markdown
## <YYYY-MM-DD>, <session label, e.g. "at Planning", "morning", "at the Review"> (<who is present, by role — `COMM-1`>)

- **Done:** <progress toward the Sprint Goal since the last entry — items moved, checks passed, and every pull request merged, named as `#N`>
- **Next:** <what starts next, and who>
- **Blocked or aging:** <items stuck or getting old, first — `FLOW-6` — or "nothing">
```

**Add only when they apply, in the same entry:**

- **Changed:** a choice that changed the plan, and why.
- **Found:** something discovered that the team needs to know before the next step.
- **Tokens:** a token figure worth flagging before the Review (`TRACE-4`) — most token detail belongs in `planning.md` and `review.md`, not here.

**What the Sprint step check reads** (`SCRUM-17`): each entry's heading starts with its date as `YYYY-MM-DD`, and every pull request merged since the Planning is named as `#N` in some entry.

**Keep it short** (the event's own short time limit, scaled to what one entry covers): report outcomes and blockers, not a narration of every tool call (`ANLY-3`, `VALUE-3`).
