# The question set

## What it is

A fixed set of questions asked in order, to turn something vague — an idea, a request, a defect report, a goal — into something concrete enough to work on. It is deliberately mechanical: the value comes from asking every question, including the awkward ones nobody raised.

| Question | What it settles | What a weak answer looks like |
|----------|-----------------|-------------------------------|
| **What?** | The thing itself, in one sentence, without solution words | A restatement of the request |
| **Why?** | The outcome it should cause, and how that will be measured (`VALUE-4`) | "Because it was asked for" |
| **Who?** | Who does the work, and which role owns the question | Nobody named |
| **For whom?** | Who gains: user, customer, employee, the organization (`VALUE-5`) | "The business" |
| **From whom?** | Where the input, data, approval, or money comes from, and who must agree | An unnamed dependency |
| **For what?** | The purpose the result serves once delivered, and how anyone will know it worked | The same words as "why", which means one of the two is unanswered |
| **Where?** | Which system, environment, repository, market, or place it applies to | "Everywhere" |
| **When?** | The time it matters: a date, an event, a trigger, or a deadline that comes from outside | "Soon" |
| **How?** | The approach, and at least one alternative to it (`PRIN-3`) | One approach, presented as the only one |

## What it is for, and which questions carry the weight

Four different jobs, and the tool serves each through a different subset. Naming the job first decides where to start.

| Job | The questions that do the work | What "done" looks like for that job |
|-----|-------------------------------|--------------------------------------|
| **Become aware of the context** | Where, when, who, for whom, from whom | The field around the thing is drawn: which system, which people, which dependencies, which timing pressure comes from outside |
| **Check what is missing** | All nine, each answer labeled verified, assumed, or unknown | The unknowns are listed with who can answer each. This is the tool's strongest use: the labels, not the answers, are the output |
| **Understand better** | What, how, why — in that order | You can restate the thing in your own words, and say what it is *not*, without using its own wording |
| **Find the motivation, or the reason** | For whom, why, for what | Cause and purpose are separated, and the purpose has a measure (`VALUE-4`) |

On the last one, "why" is ambiguous in a way that matters: it can mean the **cause** (what led to this being asked) or the **motive** (what someone wants). "For what" is neither — it is the **purpose** the result serves. Answer all three and the motivation question is settled; answer one and call it "why", and it usually is not. If the cause is what you need and every answer is another symptom, this is the wrong tool: cause-finding wants repeated "why" on one thread, not nine questions once.

## When to use it

- A request arrives that could mean several different things.
- A backlog item is about to be sized and nobody can say what "done" would look like.
- A defect report has no reproduction, or a goal has no measure.
- Two roles disagree and may be answering different questions.
- Before a decision record, to check that the question being decided is the real one.
- You are new to the thing and need the context before you can judge anything about it.

## When not to use it

- On something already clear and evidenced: nine filled-in boxes then add nothing.
- As an interrogation of a person. The questions are for the work, and a stakeholder who cannot answer "from whom" has told you something useful, not failed a test.
- To delay. If seven of nine answers are known, the item can usually start, with the two gaps named as assumptions (`ANLY-2`).

## Does the order matter?

Yes, but only three constraints are real. The rest of the order should follow the job.

**The three that always hold:**

1. **What before how.** A solution written into the "what" hides the question, and everything after it answers the wrong thing.
2. **Why before how.** Purpose before means, or you get an efficient way to do something nobody needed.
3. **For whom before why.** Motivation belongs to someone. Answer "why" without saying whose, and you will answer the loudest person's why rather than the one that matters.

**Otherwise, start where the uncertainty is largest**, which depends on the job in the table above: context work starts at where, when, and who; missing-things work needs coverage more than sequence; understanding starts at what; motivation work starts at for whom.

**One question can reframe all the others, and two do it often:** a "when" that comes from outside — a deadline, a contract date, a release someone else ships — can change the what, and a "for whom" that turns out to be a different audience changes almost everything. When either moves, go back rather than carry on.

## How to run it

1. **Name the job first** (context, missing, understanding, motivation), then work the questions its row names, respecting the three ordering constraints above.
2. **One or two sentences per answer.** Length here is avoidance.
3. **Mark each answer as verified, assumed, or unknown** (`ANLY-2`). The unknowns are the output.
4. **Turn the unknowns into work:** a question for a named role, a question for a person, or a small experiment (`VALUE-4`).
5. **Check "why" against "for what".** If they say the same thing, the purpose has not been separated from the motivation, and the item probably has no measure yet.
6. **Keep it with the work** — in the item, the note, or the decision record it serves, not in a separate document (`ANLY-5`).

## Iterating, and where to stop

It works as a loop, and usually should: an answer to one question changes an earlier one, so a second pass sees more than the first. But a loop with no stopping rule becomes a way of avoiding the work, so both are defined here.

**How a pass differs from the one before:**

| Pass | What it does | Typical output |
|------|--------------|----------------|
| **1** | Rough answers to every question in the job's row, each labeled verified, assumed, or unknown. Speed over polish | The list of unknowns, and usually a sharper "what" |
| **2** | Resolve only the unknowns that **change another answer** — the load-bearing ones — then re-answer whatever moved | Fewer assumptions; sometimes a different question than the one you started with |
| **3 and beyond** | Only the branches still moving. Never a full re-run | Narrow, and it should feel like it is running out of material |

**Stop at the first of these, not the last:**

1. **Nothing moved.** A pass that changes no answer is the signal the answers are stable. One more pass will not help.
2. **The remaining unknowns cannot change the next decision or the next step.** Name them as assumptions and go (`ANLY-2`). The tool serves a decision, not completeness — a fully answered grid is not the goal and is rarely worth what it costs.
3. **The cheapest way to answer what is left is to build or try something,** not to ask again. Then stop asking and build the smallest thing that tests it (`VALUE-4`). Questions have sharply diminishing returns against a real experiment.
4. **What is left belongs to someone else** — a person, a stakeholder, or another role's field. Hand it over with the question written down; do not speculate on their behalf (`TEAM-15`, `PRIN-2`).
5. **Two passes is the default, three needs a reason, four means the thing is too big.** If a fourth pass is tempting, split the subject into the two or three questions it turned out to be and run the tool on each. This mirrors what `ANLY-8` does with review rounds: a third iteration is a signal about the work, not a step to keep taking.

**The failure this prevents:** looping to feel prepared. An item aging in refinement while it is questioned again is a flow problem, not thoroughness (`FLOW-5`), and an answer refined past the point where it could change a decision is spent effort. If you cannot say what the next pass would change, you are finished.

**Keep the passes visible:** one line per pass saying what changed, kept with the work. It shows how understanding formed (`TRACE-2`), lets someone else pick the loop up mid-way (`CONT-2`), and makes "nothing moved" checkable rather than a feeling.

## What it produces

Nine short answers, each labeled verified, assumed, or unknown; a list of the unknowns with who can answer each; and, often, a sharper version of the original request. For a backlog item it produces the outcome and measure that `VALUE-4` requires.

## Common mistakes

- **Skipping "for what"**, which is where the measure hides. It is the most often skipped and the most often missed later.
- **Answering "who" with a role that has no say,** rather than the role that owns the question and the person accountable.
- **Treating an assumption as verified** because it sounds obvious. The label is the tool's main safeguard (`ANLY-2`).
- **Asking all nine of something trivial,** which teaches everyone to skip the tool when it would matter.
- **Filling the boxes alone** when the answers live with a stakeholder, a person, or another role: then the output is a list of questions to ask, which is a fine result.
- **Looping for comfort.** A second pass that resolves load-bearing unknowns is worth it; a fourth pass that polishes wording is avoidance, and the stop rules above exist to name it.

## Rules applied

`ANLY-1`, `ANLY-2`, `ANLY-5`, `ANLY-8`, `ANLY-10`, `VALUE-4`, `VALUE-5`, `PRIN-2`, `PRIN-3`, `FLOW-5`, `TRACE-2`, `COMM-3`, `TEAM-15`.
