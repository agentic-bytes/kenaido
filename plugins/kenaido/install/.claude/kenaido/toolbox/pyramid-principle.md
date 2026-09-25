# The pyramid principle

## What it is

A way of ordering thought so the reader gets the answer first and the support underneath it, instead of following the path you took to get there.

```
                    The answer, in one sentence
                    /            |             \
          Point 1          Point 2          Point 3
         /      \         /      \         /      \
    evidence  evidence  evidence  evidence  evidence  evidence
```

Three properties make it work, and all three are checkable:

- **The answer comes first,** not the build-up. Anything else makes the reader hold your reasoning in their head before they know what it is for.
- **The points below a statement answer the question that statement provokes.** If the answer is "use RPC", the reader immediately asks "why?", and the points below must answer *why*, not describe what RPC is.
- **The points beside each other don't overlap and don't leave a gap,** and they are the same kind of thing, in a sensible order — by time, by structure, or by degree.

It comes from a published consulting method, described here in our own words; the name is used only to refer to it (`COMM-4`). In kenaido it is not optional for writing: `COMM-5` already requires it for everything agents write. This file is the *how*, and it works in two directions — one for when you know the answer, one for finding it.

## When to use it

- **Top-down, when you know the answer:** any report to a person, a decision record, a pull request description, a review result, an escalation, a Sprint Review summary.
- **Bottom-up, when you don't:** a pile of findings, notes, or measurements, and no conclusion yet. Group them, summarize each group in one sentence, then see what those sentences together say. That summary is the answer, and it often is not the one you expected. This is the part people miss: the pyramid is a thinking tool, not only a writing format.
- **As a check on someone else's work,** including an agent's: if the summary does not state an answer, or the points below do not answer the question the top provokes, the thinking is not finished (`ANLY-8`).

## When not to use it

- **When the answer isn't known yet.** Build the pyramid bottom-up first, or use the [question set](question-set.md). Forcing a top-down structure onto an unformed conclusion produces a confident-sounding guess (`ANLY-7`).
- **When the reader needs the path, not the point** — a reproduction of a defect, a migration runbook, a tutorial. There the order is temporal and the sequence *is* the content (`DOC-7`).
- **For a two-line answer.** Structure would cost more than it gives.
- **To hide uncertainty.** A pyramid makes any answer sound settled. If the answer is provisional, say so at the top, with what would change it (`ANLY-2`).

## How to run it

1. **Write the answer in one sentence.** If you cannot, you do not have one yet — and that is a finding, not a writing problem. Go bottom-up.
2. **List the two to four points that support it.** Fewer than two means the answer is unsupported; more than four usually means two of them are the same point, or the answer is really two answers.
3. **Run the "so what" test downward:** for each point, ask what question the statement above provokes and whether this point answers *that* question. A true statement that answers a different question weakens the pyramid.
4. **Run the overlap-and-gap test sideways:** do any two points cover the same ground, and is anything a reader would expect missing? An overlap double-counts; a gap is where the objection will come from.
5. **Put the evidence under each point,** with its source (`ANLY-1`, `COMM-6`). Evidence that supports no point is either a missing point or clutter.
6. **Read it top-down once as the reader.** Stop after the first sentence: could they act, or decide, on that alone? If not, the top is a description, not an answer.
7. **State the confidence at the top** where it matters: verified, assumed, or unknown (`ANLY-2`).

## Bottom-up, in detail

The direction that does the actual thinking:

1. Lay out every finding, one line each, with its source.
2. Group the ones that answer the same question. Name each group by what it *says*, not by what it is *about* — "the guardrails are not enforced yet" rather than "guardrails".
3. Summarize each group in one sentence. Those sentences are your candidate points.
4. Ask what those sentences, taken together, mean. That is the answer.
5. Check it against the findings that did not fit any group: they are where the answer is wrong, or incomplete.

## What it produces

A one-sentence answer with its confidence, two to four non-overlapping points underneath, evidence with sources under each, and — from the bottom-up direction — an explicit note of any finding that did not fit, which is usually the most interesting thing in the document.

## Common mistakes

- **A summary that summarizes instead of answering:** "this record describes the options for …" tells the reader what the document is, not what to do. `DOC-5` and `COMM-5` both want the second.
- **Burying the answer** at the end, after the reasoning, because that is the order in which it was discovered.
- **Three points that are one point, repeated in different words.** The overlap test catches it.
- **Grouping by topic rather than by claim,** which produces headings and no argument.
- **Evidence with no point above it,** which is where reports get long without getting stronger.
- **Using it to make a thin answer look solid.** The structure is honest only if the confidence is stated (`ANLY-2`, `ANLY-7`).

## Rules applied

`COMM-5`, `COMM-6`, `COMM-3`, `COMM-4`, `ANLY-1`, `ANLY-2`, `ANLY-3`, `ANLY-7`, `ANLY-8`, `ANLY-10`, `DOC-5`, `DOC-7`.
