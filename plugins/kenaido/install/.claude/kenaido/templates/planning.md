# Sprint Planning template

The Sprint Planning record (`SCRUM-9`): the Sprint Goal, the items pulled, and why they fit, held within the event's own time limit. The new-sprint script writes the block below into the new Sprint's `planning.md` when the Sprint's folder is created ([`start-sprint`](../skills/start-sprint/SKILL.md)); don't create this file by hand. It starts "not held yet," then is filled in at Sprint Planning and replaces the guard line.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

```markdown
# Sprint <N> — Planning

**Not held yet.** Created when the Sprint started, and filled in at Sprint Planning.
```

**Filled in at Sprint Planning**, in this shape:

```markdown
# Sprint <N> — Planning

- **Sprint:** <N> · **Length:** from <the date this plan is approved> until <the Sprint's fixed length by default (`SCRUM-14`), or, if the project has adapted that rule, until its Sprint Retrospective concludes it — the event that closes a Sprint, whatever triggered holding it (Scrum Guide, paraphrased); an early trigger such as the Goal being met is labeled as an adaptation (`SCRUM-4`)> · **Status:** <planned | approved by the accountable person, and what was approved: the Sprint Goal, the order, the budgets>
- **Goal approved:** <YYYY-MM-DD> by <the accountable person, by role>. Add this line only when that person approves the Sprint Goal, and delegate no Sprint work before it (`SCRUM-9`). The Sprint step check looks for this exact line (`SCRUM-17`).
- **Held:** <date>. **Time limit:** <the event's own limit, scaled to the Sprint length>.
- **Mode:** <sequential or parallel, whichever the project's own setting names> (`SCRUM-10`, `SCRUM-15`). **Push delegation:** <whether agents may push work branches and open pull requests this Sprint, and who merges — the accountable person's call, `PRIN-2`>.
- **Brief:** [`tasks/planning.md`](tasks/planning.md) · **State:** <the Sprint's working-note state file, `CONT-9`>.

| Who | Part |
|-----|------|
| The accountable person | <Product Owner and stakeholder decisions this Planning needed> |
| Product Owner agent | <the Sprint Goal, the order, and why> |
| The Developers | <the plan, the token forecast per member, the board> |
| Scrum Master agent | <checks this record and the Sprint Backlog, `ANLY-8`> |

## Topic one — the value of this Sprint

> <the Sprint Goal, in one or two sentences: what changes for the stakeholder>

- **Stakeholder outcome and measure(s):** <one stakeholder outcome per Sprint Goal, and exactly how it is measured, so the Review can check it against the same measure (`VALUE-3`, `VALUE-5`)>.
- **Why this Sprint, not another:** <the evidence behind the choice: what the Product Goal, a stakeholder request, or the last Review or Retrospective found (`ANLY-1`)>.

## Topic two — what the Sprint will include

| Order | Item | Effort | Why |
|-------|------|--------|-----|
| <order> | <item, with its backlog link> | <effort> | <why it fits now, `ANLY-1`> |

- **Total effort: <n>.** Throughput so far: <the last few Sprints' finished-item counts>, so <n> items fit this Sprint (`FLOW-6`).
- **Not pulled:** <items considered and left for a later Sprint, and why>.
- **Planned total: <n>.** **Buffer: <n>** — the capacity deliberately left unplanned (`SCRUM-16`), in this project's capacity unit. **Ceiling: <planned total + buffer>**, the most this Sprint may spend. <the share the project's settings set, and why it is this size here, from the team's flow and usage data — `FLOW-6`>.
- **Buffer candidates, in order:** <the named work that would be pulled in if the buffer turns out to be free, best first, from the ordered Product Backlog>. Nothing here is committed: the Developers decide during the Sprint, and each use is checked against the Sprint Goal first (`SCRUM-16`).

## Topic three — the plan for the work

See the [Sprint Backlog](sprint-backlog.md): <how many lanes, and whether they run one after another or together>, and **a token forecast per team member**, from the closest measured part of past comparable work (`TRACE-4`).

## Ethics check

<how this Sprint's planned work touches life, dignity, joy, and the environment, and whether it raises a concern for the Ethics Committee (`ETH-5`)>.

## The Scrum Master agent's check

<Confirmed | Confirmed with conditions | Another iteration needed>, with its evidence (`ANLY-8`).

| Condition | Owner | State |
|-----------|-------|-------|
| <condition, if any> | <role> | <Open, or Met, with evidence> |

## Tokens

| Part | Estimate | Measured |
|------|----------|----------|
| <part> | <estimate, from the closest reference part> | <measured, from the task notification> |
| **Planning, all parts** | <approved total> | <measured total> |
```
