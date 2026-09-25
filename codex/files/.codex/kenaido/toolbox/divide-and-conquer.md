# Divide and conquer

## What it is

Split a problem too big to hold into parts that can be solved separately, solve each, then put the results back together. The split is only half the tool: **how the parts recombine, and who checks the whole, are decided before the splitting starts**, or the recombination becomes a second, harder problem.

## When to use it

- A task nobody can hold in their head at once, or estimate.
- A problem with parts that genuinely don't depend on each other, so they can be worked at the same time (`ANLY-4`).
- One hard piece buried in an easy problem: isolate the hard piece and solve it alone.
- A large change where prerequisites can be built first and everything else rests on finished work (`CODE-3`).

## When not to use it

- **Small tasks.** Splitting has a fixed cost: a brief, a result file, a budget, a check, and for an agent, starting from scratch with no context (`ANLY-4`, `CONT-3`). Below a certain size the overhead exceeds the work.
- **Tightly coupled problems.** If every part needs to talk to every other part constantly, the split multiplies communication instead of reducing work. That is the same effect adding teams has on a product (`SCALE-5`).
- **When the seam is unknown.** Splitting at the wrong place is worse than not splitting: use the [question set](question-set.md) to find what the parts actually are first.
- **When recombination is the real work.** If assembling the pieces is harder than any piece, solve the assembly first.
- **To look parallel.** Parts that each wait on the others are sequential work with extra bookkeeping.

## How to run it

1. **State the whole in one sentence,** including how you will know the whole is done. If that sentence needs an "and", you may already have found the seam.
2. **Find the seam by independence, not by phase.** Good seams: by outcome, by data that doesn't cross, by system boundary, by risk (isolate the risky piece), by skill where the skills genuinely don't overlap. Bad seams: by role, by stage, by document — those produce parts that can't be verified alone and all land at the end.
3. **Test each part against three questions.** Can it be finished without waiting on a sibling? Can it be verified on its own (`TEST-1`)? Does it produce something of value or usable knowledge by itself? A part that fails the third is a horizontal slice — resplit.
4. **Write the contract between parts before the work starts** (`CODE-8`): what each part receives, what it returns, and what it must not touch. For agents, that contract is the brief (`CONT-3`).
5. **Order the parts so prerequisites come first** and nothing is built twice (`CODE-3`), then run the independent ones together, within the work-in-progress limit and within the usage limits (`FLOW-3`, `CONT-10`).
6. **Name who assembles and who checks the whole, up front.** It must not be the same role that produced the parts (`TRACE-6`, `ANLY-8`).
7. **Verify the whole, not just the parts.** Every part passing does not prove the whole works: the parts were tested against their contracts, and the contracts can be wrong together. This project has the lesson on record — tests that passed for the wrong reason.

## Where to stop splitting

Stop at the first of these:

1. **A part is independently verifiable and independently useful.** That is the floor: below it you get pieces nobody can test or value on their own.
2. **The split cost exceeds the benefit** — the brief, the context, the check, and the assembly cost more than doing the part inline.
3. **The parts start needing constant conversation.** That is evidence of a wrong seam, not of a need for more coordination. Merge them and split differently.
4. **Two levels deep, three with a reason.** Deeper than that and nobody holds the whole any more, which is the failure this tool was supposed to prevent.

## What it produces

A list of parts, each with its contract, its owner, its verification, and its order; the dependency between them stated; and one named role for assembling and one, different, for checking the whole.

## Common mistakes

- **Splitting by phase or by role** (analysis, then design, then build) instead of by outcome. Those parts can only be integrated at the end, which is when problems are most expensive.
- **Nobody owns the whole.** Every part succeeds and the thing does not work.
- **Splitting small work** to feel organized, or to look parallel.
- **Parallel fan-out that shares one limit.** Several agents at once share one account's usage, so they can stop together and lose everything not yet saved — this project lost two parts that way, which is why work runs in ones and twos with progress files (`CONT-7` to `CONT-10`).
- **Treating the plan as the answer.** A split is a hypothesis about where the seams are; if a part turns out to need its siblings, resplit rather than push through.

## Rules applied

`ANLY-4`, `ANLY-8`, `ANLY-10`, `CODE-3`, `CODE-8`, `TEST-1`, `FLOW-3`, `SCALE-5`, `CONT-3`, `CONT-10`, `TRACE-6`.
