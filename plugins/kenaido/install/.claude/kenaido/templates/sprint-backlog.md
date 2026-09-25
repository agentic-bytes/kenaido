# Sprint Backlog template

The Developers' plan for one Sprint: the Sprint Goal and how the work gets done, made at Sprint Planning and kept current through the Sprint. The new-sprint script writes the block below into the new Sprint's `sprint-backlog.md` when the Sprint's folder is created ([`start-sprint`](../skills/start-sprint/SKILL.md)); don't create this file by hand. It starts "not held yet," then is filled in and kept current from Sprint Planning on.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

```markdown
# Sprint <N> — Sprint Backlog

**Not held yet.** Created when the Sprint started, and filled in at Sprint Planning; kept current through the Sprint.
```

**Filled in at Sprint Planning, and kept current**, in this shape:

```markdown
# Sprint <N> — Sprint Backlog

The Developers' plan, made at Sprint Planning. The board's Sprint field is the live version (`SCRUM-12`); the real dates are in [`planning.md`](planning.md).

## Sprint Goal (the commitment)

> <the Sprint Goal, matching `planning.md` exactly>

- **Stakeholder outcome:** <in one sentence>
- **Measures, inspected at the Review:** <the same measure(s) `planning.md` names, each as a baseline → target>

## Items (on the board, Sprint <N>)

| Order | Item | Effort | What | Board state | Result |
|-------|------|--------|------|-------------|--------|
| <order> | <item, with its backlog link and its number as `#N`> | <effort> | <what it delivers> | <its state on the board, updated at each merge> | <"—" until a pull request serves it; then which pull request, and its review verdict. Written at the merge checkpoint (`SCRUM-17`)> |

**Total effort: <n>.** <the throughput reference behind why this many items fit, `FLOW-6`>. **Not pulled:** <items left for a later Sprint>.

**Buffer candidates, in order:** <the named work that would be pulled in if the buffer turns out to be free, best first, from the ordered Product Backlog — matching `planning.md`>. Nothing here is committed (`SCRUM-16`).

## How: the Developers' plan

<one line on the working mode: whether lanes run one after another or together, and who coordinates>.

| Lane | Step | Item | Work | Who | Tier |
|------|------|------|------|-----|------|
| <lane> | <step> | <item> | <what this step delivers, specific enough to review — `ANLY-11`> | <role> | <routine, standard, hard, or critical — the sizing a task needs> |

**Order and dependencies:** <which lanes must finish before others start, and why>. **Waiting for a person:** <what needs a human decision before it can continue, and the limit on how many items wait at once, if the project sets one>.

**Tiers:** <why any step is sized above standard, and whether a role test is needed before untested or critical-tier work proceeds — `TEAM-13`, `ANLY-8`>.

## Capacity: a token forecast per team member

<a one-line note on how the forecast is built: from the closest measured part of past comparable work, per member (`TRACE-4`)>.

| Member | Work this Sprint | Closest measured part | Forecast |
|--------|------------------|------------------------|----------|
| <role, fresh or resumed> | <its steps> | <the past part its estimate is built from, or "none — sized at the standard range's low end"> | <forecast> |

- **Team size:** <how many people and agent instances are inside the Scrum Team this Sprint — `TEAM-4`; roles working outside the team don't count (`TEAM-10`)>.
- **Planned total: <n>** (the forecasts above, added up). **Buffer: <n>** — capacity kept unplanned on purpose, the share this project's settings set (`SCRUM-16`, `DOC-8`). **Ceiling: <planned total + buffer>**, the most this Sprint may spend.

## Buffer: how it was used

Kept current through the Sprint, so the Review and the Retrospective can see where the buffer went (`SCRUM-16`, `FLOW-6`).

| When | What was pulled or spent | Capacity used | Checked against the Sprint Goal | Who agreed, and why |
|------|--------------------------|---------------|--------------------------------|---------------------|
| <the working day> | <a fix to committed work, another review or rework round, an unexpected problem, or a candidate from the list> | <in this project's capacity unit> | <how it was checked not to put the Sprint Goal at risk> | <the Developers who agreed, by role, and the reason> |

- **Left unused: <n>.** Ending under the ceiling is a good outcome, not waste.
- **If the ceiling was reached:** <what stopped and went back to the Product Backlog>. The buffer does not reopen; the overrun is inspected at the Sprint Retrospective (`SCRUM-16`).
- **New requests that arrived:** <captured as Product Backlog items for the next Sprint Planning (`SCRUM-11`); the buffer is not a way into this Sprint>.

## When the Sprint ends

Meeting the Sprint Goal triggers holding the Review and the Retrospective early, rather than waiting for the Sprint's fixed length (`SCRUM-14`: one week), when the project has adapted that trigger, labeled as an adaptation (`SCRUM-4`). Either way, **the Sprint itself closes only when the Sprint Retrospective concludes it** — the Scrum Guide's own rule, paraphrased, not an adaptation — and the next Sprint's Planning follows at once.
```
