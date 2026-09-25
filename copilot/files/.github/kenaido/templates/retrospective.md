# Sprint Retrospective template

The Sprint Retrospective record: what the interaction records show, what to keep, and the improvement bets chosen (`TRACE-5`, `IMPR-4`). The new-sprint script writes the block below into the new Sprint's `retrospective.md` when the Sprint's folder is created ([`start-sprint`](../../skills/kenaido-start-sprint/SKILL.md)); don't create this file by hand. It starts "not held yet," then is filled in at the Sprint Retrospective, right after the Sprint Review.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

**This event concludes the Sprint** (the Scrum Guide, paraphrased, `SCRUM-6`): whatever triggered holding the Review and Retrospective early, the Sprint itself does not close until this record is committed.

```markdown
# Sprint <N> — Sprint Retrospective

**Not held yet.** Created when the Sprint started, and filled in at the Sprint Retrospective, right after the Sprint Review.
```

**Filled in at the Sprint Retrospective, in two passes, both committed before the choice:**

1. **First, draft everything except the choice** — "What went well" through "New improvements, ranked" — and set "Decision on the improvements" to "**Not decided yet.**" **Commit this draft** where the accountable person can read it, and only then tell them it is ready and ask them to choose (`IMPR-4`): the choice is made from the record, where everyone can see it. Never offer the ranked improvements only inside a question or a separate working file.
2. **Then, once the accountable person has chosen, fill in "Decision on the improvements"** with their answer and commit again. This second commit is what concludes the Sprint.

In this shape:

```markdown
# Sprint <N> — Sprint Retrospective

*Held <date>, facilitated by <role>. Sprint <N> closed <how — its Retrospective concluded it, after the Review and Retrospective were triggered by its Goal being met, or by reaching the Sprint's fixed length>.*

## What went well

- <each point with the evidence it rests on, cited to `review.md` or an interaction record — `ANLY-1`>.

## What did not go well, and why

- <each point with its cause, not only its symptom, and where the evidence lives>.

## <Any cross-cutting call this Sprint needs, e.g. a stability-plan flag or a scope-versus-capacity question — omit if none>

<the question, the options weighed, and the accountable person's decision, with evidence — `PRIN-2`>.

## Trial results (early signs, not proof — `IMPR-6`)

| Bet | Target | Result |
|-----|--------|--------|
| <improvement ID>: <what it changes> | <what counts as success> | <met \| not met \| not triggered, with the evidence> |

**Recommendations:** <which trials to keep, adapt, or close, and why>.

## New improvements, ranked (`IMPR-2`, `IMPR-3`)

| Rank | ID | Change | Measure: baseline → target | Guard | Impact | Conf. | Effort | Score |
|------|----|--------|-----------------------------|-------|--------|-------|--------|-------|
| <rank> | <ID> | <the change, as a bet> | <baseline → target> | <what must not get worse> | <1-5> | <1-5> | <1-5> | <impact × confidence ÷ effort> |

<Improvements from earlier Sprints not chosen stay on the list, unchanged, unless this Sprint's evidence changes their ranking.>

**Trials whose window has ended, closed before anything new is chosen** (`IMPR-4`, `IMPR-6`): <each one, with keep | adapt | undo and its evidence, or "none ended this Sprint">.

**Chosen for the next Sprint:** <the three or four, from the ranked list — this Sprint's proposals together with the candidates carried forward — each aimed at a different measure>. <If the accountable person set the number aside: the number chosen, and their reason (`IMPR-4`).>

## Flow numbers for the next Sprint Planning

- **Throughput:** <items finished this Sprint, against the recent Sprints' counts>.
- **Tokens:** <the Sprint's total, against its forecast, with the largest variances explained>.
- **The effort statistic, by kind of work:** <rows added or updated from this Sprint's measured parts, so the next Planning estimates from the closest reference>.
- **Work in progress:** <items in flight at the close, and anything waiting on a person>.
- **Carried to the next Sprint Planning:** <open conditions, flags, or decisions that must be addressed before or during the next Planning>.

## Decision on the improvements (`IMPR-4`)

**Not decided yet** — <or, once chosen and committed in the second pass:>

**The accountable person chose, on <date>:**
- <each improvement adopted for the next Sprint, and in one line what changes because of it>.
- **Not adopted:** <each improvement considered and declined, and why>.
- **Not chosen for the next Sprint; they stay on the list:** <the rest>.
- **Overruns past their approvals:** <approved, or a follow-up needed>.
- **The trials:** <which stay open, which close this Sprint, and why>.

**This record ends Sprint <N>.**
```
