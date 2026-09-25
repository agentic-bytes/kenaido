# Dreamer, Realist, Critic

## What it is

Three separate perspectives applied to one idea, in turn, each held by a different role or agent instance so the perspectives stay honest:

- **Dreamer:** what is the best possible solution, with no filtering? Brainstorming is allowed and encouraged; nothing is ruled out for being hard, costly, or unusual yet.
- **Realist:** what would this actually need to exist, and is that feasible, while keeping as much of its value as it can? This is a builder's pass, not a cut-it-down pass.
- **Critic:** from evidence, what are this idea's limits and defects, and is there a better approach? This is a reviewer's pass, not a taste test (`ANLY-1`).

The three passes run as a loop: a Critic's findings become the Dreamer's next input, refined again by the Realist, checked again by the Critic, until the idea clears a stopping rule (below) or the round cap is reached. **One agent never plays Critic of its own Dream in the same pass:** the role or instance that dreamed an idea does not also critique it, the same separation `ANLY-8` requires of any review and `TEAM-12` requires of any combined role.

**Origin, in our own words:** this is a creativity strategy built from three perspectives — imaginative, practical, and critical — described in published creativity and communication-method literature, including neuro-linguistic programming, as three passes over one idea rather than one mixed pass. We describe the structure here in our own words, from its general shape, not from any one publisher's text or any one person's attributed practice, and it carries no trademarked name (`COMM-4`).

## When to use it

- A design, feature, or solution idea that is at risk of being narrowed before it is understood — the room jumps to "can we do this" before anyone has stated what the best version would even look like.
- An idea already favored by the team, before it is trusted: it needs a real skeptical pass, done by someone who did not propose it.
- A proposal that keeps being either all-enthusiasm or all-objection in review, with the two never meeting.

## When not to use it

- **When the question is already answered by evidence.** Check the evidence first; don't dream up an alternative to a settled fact (`ANLY-1`).
- **When there is no room to imagine.** A choice fully fixed by law, a license's terms, or a hard budget line does not need a Dreamer pass; it needs the accountable person, per `PRIN-4` for terms.
- **When only one option is needed, quickly, and it is obviously right.** The loop costs at least three passes; don't run it on a small, low-risk choice.
- **When distinct roles or instances for each perspective aren't available.** The tool's value is the separation. One agent narrating all three in a row produces the feel of rigor with none of it — plain review is more honest for that case.
- **To generate several different options.** This tool deepens and stress-tests one idea already in the room. To find options in the first place, see structured option generation, listed for that purpose in "How to pick one" in `product/toolbox/README.md`.

## How to run it

1. **Name the idea and what "good" means for it**, in one sentence, so all three passes judge the same thing.
2. **Dreamer pass.** A role that owns the need (for example the role that requested it, or the Brainstorming Expert) states the best possible version, unfiltered. Record it as given, without a feasibility comment attached.
3. **Realist pass, a different role.** Usually the role that would build it (an Architect or the Developer job role that owns the area). State what the dream needs to exist: resources, sequencing, a concrete build path, what stays and what must change to be real, while keeping as much of the dream's value as honestly possible. Not a stripped-down version by default.
4. **Critic pass, a different role again.** Usually an expert role with a stake in the outcome (for example the Security Expert, the Data Protection Expert, the Risk Manager, or a Tester), or an independent reviewer. State limits, defects, and any better approach, each backed by a source (`ANLY-1`). A critic who only dislikes the idea says so as a preference to weigh, not as a defect (the same bias control asked of any reviewer).
5. **Check the stopping rule** (below). If it is not met, the Critic's findings go back to the Dreamer as the next pass's input — not a repeat of the same dream, but a response to what the Critic found.
6. **Hand over, don't decide.** When the loop stops, the shortlist and its trade-offs go to the role that owns the question and the person who decides (`PRIN-2`); this tool never decides.

## Stopping rule

Stop the loop at the first of these, whichever comes first:

- **The idea is good enough:** high value confirmed, feasible under the Realist's account, and few or no expected downsides remain, including how it would be implemented — not just that it could be.
- **A pass changes nothing,** or what remains cannot change the next decision — the same general stopping conditions every tool in passes uses (`product/toolbox/README.md`).
- **Building or trying the smallest real version would answer more than another pass could.** Stop dreaming about it and go build or try that instead (`VALUE-4`).
- **What is left belongs to a person or another role's field, not another pass.** Hand it over with the open question named; don't speculate on their behalf (`TEAM-15`, `PRIN-2`).
- **A round cap is reached.** Two rounds is a normal default and a third needs a stated reason, matching this project's general rule for any tool run in passes (see "How to pick one" in `product/toolbox/README.md`); a fourth round usually means the idea should be split into smaller ideas and run separately.

## What it produces

One refined idea (or a small shortlist, if the Dreamer pass produced more than one worth carrying forward), each with its build path from the Realist, its known limits and any better approach the Critic found, and a recommendation — never a decision (`PRIN-2`). The passes and who held each perspective are worth recording alongside it (`TRACE-2`).

## Common mistakes

- **One agent playing more than one perspective in the same pass.** The Critic then critiques its own Dream, which `TEAM-12` and `ANLY-8` both rule out.
- **The Realist stripping the idea down by default** instead of working out what the full version needs. That is the Critic's job, later, not the Realist's.
- **The Critic without evidence**, offering a preference as if it were a defect.
- **Looping to feel thorough.** A pass that changes nothing is a signal to stop, not to run again "to be safe" (`product/toolbox/README.md`).
- **Running the loop on a small, obviously-right choice**, where the cost of three passes exceeds anything it could find.

## Rules applied

`ANLY-1`, `ANLY-2`, `ANLY-8`, `ANLY-10`, `COMM-1`, `COMM-4`, `PRIN-2`, `PRIN-4`, `TEAM-12`, `TEAM-15`, `TRACE-2`, `VALUE-4`.
