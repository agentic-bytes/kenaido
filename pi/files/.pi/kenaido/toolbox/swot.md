# SWOT analysis

## What it is

A four-box look at one thing — a solution, a system, a plan, a team, a product — along two axes: what is **inside** your control and what is **outside** it, and what **helps** and what **hurts**.

| | Helps | Hurts |
|---|-------|-------|
| **Inside** your control | **Strengths** | **Weaknesses** |
| **Outside** your control | **Opportunities** | **Threats** |

The four words are the standard ones: Strengths, Weaknesses, Opportunities, Threats. Keeping "inside" and "outside" straight is most of the value: a weakness is something you can fix, a threat is something you must prepare for, and mixing them produces a list nobody can act on.

## When to use it

- Judging **one** option on its merits before comparing it with others — for example one IDE base, one license model, one architecture.
- Before a decision record is written, so its recommendation rests on more than the option's upside (`PRIN-3`).
- Checking a solution already chosen, when something has changed outside it.
- Preparing a risk conversation: the threats found here are candidate risk entries for whoever holds the risk method.

## When not to use it

- **To compare options.** Four boxes per option invites picking the one with the longest "strengths" column. Comparison belongs in an options table with named criteria.
- **When the question is vague.** Use the [question set](question-set.md) first; a SWOT of an unclear idea produces confident nonsense.
- **When evidence would settle it.** If the weakness is measurable, measure it (`ANLY-1`).
- **As a status report.** It is a thinking tool, not a document to maintain.

## How to run it

1. **State the subject in one sentence,** including what it is meant to achieve. "SWOT of the app" is too broad to be useful; "SWOT of building the app on a modified open-source editor, to ship an all-in-one desktop app" is workable.
2. **Say who is doing it and from whose point of view.** A strength for the team can be a threat for a customer. Name the viewpoint.
3. **Fill inside first** (strengths, weaknesses), because those are checkable against what you have: the code, the team's skills, the budget, the measures.
4. **Then outside** (opportunities, threats): what the market, the law, a supplier, an upstream project, or a platform could do, whether or not it is likely.
5. **Cite each cell.** A claim with no source is an assumption, and is labeled as one (`ANLY-2`). An empty box is a finding: it usually means nobody knows yet.
6. **Turn it into work, or throw it away.** Each cell gets exactly one of: an action with an owner role, a risk entry for the risk method, evidence to go and get, or nothing. A cell that becomes nothing is fine; a grid where everything becomes nothing means the tool was the wrong choice.

## What it produces

A short table where every cell carries its source, plus a list of what happens next: actions with owner roles, candidate risks, and evidence to gather. That list is the output that matters; the grid is scaffolding.

## Common mistakes

- **Inside and outside swapped:** "the upstream project releases weekly" is outside your control, a threat to keep up with, not a weakness of yours.
- **Strengths written as marketing.** If a strength would not survive a reviewer asking "compared to what, and how do you know?", it is not a strength yet.
- **Threats with no likelihood or effect.** A threat nobody can size is a prompt to go and find out, not a conclusion.
- **Balance for its own sake.** Three real weaknesses and no strengths is a legitimate result and a useful one.
- **Using it to justify a choice already made.** If the recommendation was written first, the grid is decoration (`ANLY-7`).

## Rules applied

`ANLY-1`, `ANLY-2`, `ANLY-7`, `ANLY-10`, `PRIN-2`, `PRIN-3`, `COMM-3`.
