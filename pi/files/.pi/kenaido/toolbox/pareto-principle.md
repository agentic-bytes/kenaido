# The Pareto principle (the 80/20 rule)

## What it is

In many lists of causes and effects, a small share of the causes accounts for most of the effect. For example, a few defects cause most of the failures, a few features get most of the use, and a few steps take most of the time. The tool is simple: **measure the effect of each item, sort the items from largest to smallest, and look at how few of them make up most of the total.** Then put effort there first, and decide on purpose what to do with the rest.

| Rank | Item | Share of the effect | Running total |
|-----:|------|--------------------:|--------------:|
| 1 | Cause A | 45% | 45% |
| 2 | Cause B | 25% | 70% |
| 3 | Cause C | 10% | 80% |
| 4–12 | Nine more | 20% | 100% |

Here, 3 causes out of 12 (25%) give 80% of the effect.

**"80/20" is a shape, not a law.** The numbers are a common example, not a fixed ratio, and they need not add up to 100: a real split may be 70/30, 90/10, or no clear split at all. **Measure the real split every time**; never assume it.

The pattern is named after an economist to whom the observation is commonly attributed; it was later applied to quality work and is widely known under both names. Those attributions are not verified here (`ANLY-2`). The names are used only because they are the common names of the technique, and the description above is our own (`COMM-4`).

## When to use it

- Choosing which defects, risks, or complaints to fix first, when their counts or costs are known.
- Deciding which features, pages, or commands deserve the most care, from usage data.
- Finding where time or cost goes in a process, before trying to speed it up.
- Checking whether a long list really needs all its items treated the same way.

## When not to use it

- **When one small item is vital.** A rare failure can matter more than many common ones: a security flaw, a data loss, harm to a person. Frequency is not severity; the [vital, essential, extra](vital-essential-extra.md) layers come first (`ETH-2`, `CODE-9`).
- **Without data.** The tool rests on measured effects. Guessed shares only dress up an opinion as a finding (`ANLY-1`).
- **To drop the long tail without looking.** The rest may hold what a small group of people depends on, such as accessibility needs. Decide about it explicitly (`ETH-9`).
- **When items depend on each other.** A small item may be what a large one needs first; order by dependency.
- **To set the backlog order on its own.** It is an input to the order, which the Product Owner sets (`TEAM-1`).
- **When urgency is the question.** For what must happen now, use the [Eisenhower matrix](eisenhower-matrix.md).

## How to run it

1. **Name the effect you care about, and how it is measured:** failures, hours, cost, users affected. One effect per run; mixing them hides the pattern.
2. **Collect the data for every item,** from a real source, and say which one and for what period (`ANLY-11`).
3. **Sort the items from largest effect to smallest,** and add a running total.
4. **Read the split:** how many items make up most of the total? Write the real numbers, for example "3 of 12 causes, 80% of failures".
5. **If there is no clear split,** say so. Then the tool does not apply to this list; spread the effort, or look for a different grouping.
6. **Check the vital items first:** a rare but severe item is handled whatever its rank.
7. **Act:** work on the top items first. For the rest, choose one of: handle later, handle in bulk, or leave alone, and say which.
8. **Measure again after acting.** Fixing the top causes changes the list; the next run may show a new top.
9. **Record the table with the work it served,** name the tool (`ANLY-10`), and leave the decision to the person accountable for it (`PRIN-2`).

## What it produces

A sorted table with each item's share and the running total, the real split in numbers, and the list of top items to act on. Just as important: what was decided about the rest, and any rare but severe item handled out of rank.

## Common mistakes

- **Quoting 80/20 without measuring.** The ratio is an example; the finding is the measured split.
- **Counting when cost matters.** Many cheap defects can matter less than one expensive one; measure the effect you care about.
- **Treating the tail as unimportant.** It is less frequent, not necessarily less important.
- **Running it once.** After the top causes are fixed, the ranking changes.

## Rules applied

`ANLY-1`, `ANLY-2`, `ANLY-10`, `ANLY-11`, `CODE-9`, `COMM-4`, `ETH-2`, `ETH-9`, `PRIN-2`, `TEAM-1`.
