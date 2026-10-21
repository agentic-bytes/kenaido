# The depth check

## What it is

Four questions a role answers after it receives a task and before it starts, so the work goes **deeper, not bigger**: the same goal, done the way a subject matter expert would do it (`TEAM-13`). The task stays exactly as it was given; the four short answers sit beside it, become the role's approach, and hand its reviewer a check to run.

| # | Question | What it changes | A weak answer |
|---|----------|-----------------|---------------|
| 1 | What would an expert in this role do here that the task does not ask for? | **How** the work is done. Anything that would change **what** is delivered becomes a question for the requester, not extra work | "Nothing", on work that is not routine; or new scope, done anyway |
| 2 | What is the rawest material an expert would start from, instead of what has already been digested? | Where the evidence comes from: code, command output, the original record, the standard at its source, rather than a summary, a handoff note, or memory (`ANLY-1`, `ANLY-11`) | A summary of the source, named as the source |
| 3 | Which specific methods and tools would the expert use? | The method: named techniques, standards, scripts, and toolbox tools, each with a reason | "Careful analysis" |
| 4 | What, other than the role itself or the requester, would show the result is right? | The proof: a test, a script, a source to compare with, or a reviewer role, written so someone else can run it and see it fail if the work is wrong (`ANLY-8`, `TEST-1`) | "I will double-check", or a check that cannot fail |

It adapts a prompt a person wrote to make any request deeper rather than larger; the questions here are in kenaido's own words.

## When to use it

- **By default, on every task that is not routine:** standard, hard, and critical work, sized on the same scale a brief uses ([`delegate-task`](../skills/kenaido-delegate-task/SKILL.md), step 2). Work that has no brief is sized by its stakes, the same way.
- **When writing a brief:** the coordinating role answers the four questions for the whole task, so each delegated part starts from them.
- **When a review returns "another iteration needed" for lack of depth:** answer the four questions again before the next round, and say what changed.

## When not to use it

- **Routine work.** Skip it, and write one line instead: `Depth check skipped: routine — <why>` (for example, "renaming one label; the link check covers it"). It goes where the depth check would have gone: at the top of a delegated part's result file, or, for routine work done inline, in the item or the pull request the work serves. That line is the whole cost of skipping, and the reviewer may disagree with it.
- **When the brief already answers it.** A delegated part confirms the brief's answers in one line and adds only what is specific to its own part. Running it twice on the same task is the cost without the gain.
- **When the request itself is unclear.** If you cannot say what is being asked, or why, use [the question set](question-set.md) first. The depth check deepens a clear task; it does not clarify a vague one.
- **To widen the scope.** Question 1 surfaces ideas beyond the task. They are written down and sent to the requester, or to the coordinator for delegated work, as questions; they are never done now (`SCRUM-11`, `PRIN-2`).

## How to run it

1. **Copy the task word for word,** or link to where it stands word for word. Never replace it with your own version: the goal, the scope, and the "Done when" stay the requester's.
2. **Answer the four questions in one line each,** and end each answer with its mark: verified, assumed, or unknown (`ANLY-2`).
3. **Sort the answers to question 1:** a change to *how* the work is done is applied now; a change to *what* is delivered becomes a question to the requester, recorded with the work, and the work goes on without it.
4. **Read the material named in question 2 before working from anything else.**
5. **Write question 4's answer so another role can run it:** the command and the result that would mean a pass, the source and the line to compare with, or the reviewer role and what it checks. If the work could be wrong and the check would still pass, it is not the check.
6. **Record it where the reviewer will read it:** at the top of the part's result file, under the progress block (`CONT-7`, `CONT-8`), or in the brief or the item for work that is not delegated. At most eight lines, in this shape:

   ```markdown
   ## Depth check
   - Task (word for word): <the task, or a link to where it stands word for word>
   - Beyond the task: applied: <how-changes>. Asked, not done: <scope questions, and to whom> (verified | assumed | unknown)
   - Rawest material: <sources> (verified | assumed | unknown)
   - Methods and tools: <named methods, each with its reason> (verified | assumed | unknown)
   - Check by someone else: <command and expected result | source and line | reviewer role and what it checks> (verified | assumed | unknown)
   ```

7. **Work, then hand the result over with its check.** The reviewer runs the check from question 4 **first**, then reviews the rest (`ANLY-8`). A check that was named but not run, or raw sources named but not read, is evidence for "another iteration needed".

One pass is the default. Run it again only when the work changes shape, or when the check from question 4 fails for a reason the first pass missed (the stopping rules in [`README.md`](README.md) apply, `ANLY-10`).

## What it produces

At most eight lines beside the unchanged task: the expert gap, split into applied and asked; the raw sources; the methods; and the external check. **The real output is the external check:** it is what lets someone other than the author say the work is right.

## Common mistakes

- **Filling in the lines and working as before.** Writing the block is not doing the work it describes. A reviewer who finds the named raw sources unread, or the named check not run, returns the work with that evidence.
- **Rewriting the task.** A "better prompt" that changes the goal answers a question nobody asked. The task stays word for word.
- **Taking question 1's ideas as permission.** Extra scope, however good, goes to the requester.
- **Naming yourself as the proof, or a check that cannot fail.** Question 4 needs something outside the author that would catch the work being wrong: a test, a source, or another role.
- **Using it on everything, routine work included,** which teaches everyone to fill it in without thinking.

## Rules applied

`ANLY-1`, `ANLY-2`, `ANLY-8`, `ANLY-10`, `ANLY-11`, `TEAM-13`, `TEST-1`, `CONT-7`, `CONT-8`, `SCRUM-11`, `PRIN-2`.
