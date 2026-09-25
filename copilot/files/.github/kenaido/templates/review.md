# Sprint Review template

The Sprint Review record: what is done against the Sprint Goal, the evidence, the flow and value measures, and what the accountable person decides next. The new-sprint script writes the block below into the new Sprint's `review.md` when the Sprint's folder is created ([`start-sprint`](../../skills/kenaido-start-sprint/SKILL.md)); don't create this file by hand. It starts "not held yet," then is filled in once the Sprint Goal is met, or the Sprint's fixed length is reached, and replaces the guard line.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

```markdown
# Sprint <N> — Sprint Review

**Not held yet.** Created when the Sprint started, and filled in at the Sprint Review, once the Sprint Goal is met or the Sprint's fixed length is reached. The Sprint Retrospective, not the Review, is what concludes the Sprint (Scrum Guide, paraphrased).
```

**Filled in at the Sprint Review**, in this shape:

```markdown
# Sprint <N> — Sprint Review

- **Status: held.** Parts: <who prepared which part of this record>.
- **Held:** <date>. **Time limit:** <the event's own limit, scaled to the Sprint length>.
- **Length:** <the Sprint's length, `SCRUM-14` by default (fixed, one week), or the project's own setting if it adapts that rule, labeled as an adaptation (`SCRUM-4`)>: Sprint <N> ran for <how long>.
- **Mode:** <sequential or parallel, and how many agents worked at once>.
- **Who took part:**

  | Who | Part |
  |-----|------|
  | The accountable person | <stakeholder and Product Owner decisions> |
  | The Developers | <presents the Increment and drafts this record> |
  | Product Owner agent | <Product Goal progress, and the backlog's adaptation> |
  | Scrum Master agent | <checks this record> |

- **Team size:** <people and agent instances inside the Scrum Team this Sprint — `TEAM-4`>.

## The Sprint Goal: <met | not met | partially met>

*<the Sprint Goal, matching `planning.md` exactly>*

| Measure | Target | Result |
|---------|--------|--------|
| <measure, matching the Sprint Backlog> | <baseline → target> | <the actual result, with how it was checked — `ANLY-1`> |

**The stakeholder outcome:** <in plain words, what changed for the stakeholder this Sprint>.

## The Increment, against the project's Definition of Done

| Item | State | How it was checked |
|------|-------|---------------------|
| <item, with its backlog link> | <Done, closed \| not Done, and why> | <who checked it, and how, with evidence — `ANLY-1`> |

**Also merged:** <records or improvements merged this Sprint that are not backlog items on their own>. **Refinement:** <backlog changes made during the Sprint that are not this Sprint's items>.

## Flow

- **Throughput:** <items finished this Sprint, against the last few Sprints' counts>.
- **Captured, not pulled:** <new requests captured for a later Sprint, and by whom>.
- **Scope changes:** <anything the accountable person changed mid-Sprint, as the Product Owner, and why>.
- **Waiting for a person:** <how many items were waiting on a human decision, against any limit the project sets>.
- **Pull requests:** <how many, and anything notable about how they merged>.

## Tokens per member against the forecast

| Member | Forecast | Measured | Notes |
|--------|----------|----------|-------|
| <role> | <from `planning.md`> | <from task notifications, or a labeled estimate when not measurable — `ANLY-2`> | <what it covered, and any overrun explained against how hard the work was> |

**All agent tokens this Sprint:** <total>, against <the Sprint's forecast>. **Where it went:** <the largest shares, by item or part>.

**The buffer** (`SCRUM-16`): **planned total** <n> · **buffer** <n> · **ceiling** <n> · **spent** <n>. <what the buffer was used for, or that it was left unused — ending under the ceiling is a good outcome, not waste; the Sprint Backlog's buffer log has each use, when, who agreed, and how it was checked against the Sprint Goal>. <if the ceiling was reached, what went back to the Product Backlog and what the Retrospective should inspect>.

## Improvements on trial

- **<Improvement ID> (<what it changes>):** <applied, and what the evidence shows | not triggered | not yet decided>.

## The accountable person's decisions and the backlog's adaptation

<Product Goal or Sprint Goal progress this Review shows; what the accountable person decided about scope, priority, or the next Sprint; the backlog's adaptation for the next Sprint, with why each change>.

## The Ethics Committee's report

<Include only when the Ethics Committee reviewed this Sprint.>

| Layer | State |
|-------|-------|
| **Life** | <holding \| improving \| weakening, with why> |
| **Dignity** | <holding \| improving \| weakening, with why> |
| **Joy** | <holding \| improving \| weakening, with why> |
| **Environment** | <holding \| improving \| weakening, with why> |

**Flagged for the chair:** <open concerns carried forward, each with what would close it>.

## The Scrum Master agent's check

<Confirmed | Confirmed with conditions | Another iteration needed>, re-verifying the Goal's measures, the Increment against the Definition of Done, flow, and the token table (`ANLY-8`).

| Condition | Owner | State |
|-----------|-------|-------|
| <condition, if any> | <role> | <Open, or Met, with evidence> |
```
