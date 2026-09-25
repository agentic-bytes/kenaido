# Work continuity

Usage limits can stop any agent, or the whole session, at any moment until the next time window. Work must survive that and resume without loss or rework.

- **`CONT-1` Work in small, resumable steps.** End every step with a checkpoint: a local commit, or a saved result file. Never leave files half edited across a step.
- **`CONT-2` Keep the handoff note current.** `project/notes/handoff.md` records the current goal, what is done, what is in progress and by which role, what waits for a person, and the next steps. Update it at every checkpoint and before starting long or parallel work.
- **`CONT-3` Write a brief for every delegated task.** Keep each brief in its Sprint's folder, `project/sprints/sprint-NN/tasks/`, complete enough that anyone, person or agent, can rerun the task as written. Work from before Scrum started is in `project/sprints/sprint-00/tasks/`. The brief template is `project/tasks/README.md`. One folder per Sprint holds both its event records and its task briefs.
- **`CONT-4` Save partial results as you go.** A delegated agent writes its result to its own file under `.work/` (ignored by git, kept on disk) early, and updates it as it works, so a stopped agent's work can be reused.
- **`CONT-5` Budget before parallel work.** Remaining usage can't be checked in advance, so start parallel agents only with briefs and result files in place (`CONT-3`, `CONT-4`), and prefer a smaller model for well-defined research tasks when quality allows.
- **`CONT-6` Resume from the record, not from memory.** On resume, read `CLAUDE.md`, the handoff note, the lessons learned, and the findings; check `git status` and the branches; then rerun only the unfinished tasks, reusing any saved partial results (`ANLY-5`).
- **`CONT-7` A result file exists before the work starts, and holds findings from the first one.** The coordinator creates each delegated part's result file, with its headings and the progress block below, **before** launching the agent; the agent's first action is to read it, not to create it. From then on the agent writes **every finding into the file as soon as it has it**, in one or two lines, rather than holding results until the end. A file with headings and no findings is not a checkpoint: it saves nothing when the agent stops.
- **`CONT-8` Every result file starts with a progress block, kept current.** Six lines, updated at each finding and before anything long:

  ```markdown
  <!-- progress -->
  - **Status:** not started | in progress | stopped (reason) | done
  - **Next step:** the single next thing to do, specific enough to act on
  - **Already read:** files and sources checked, so a resumed agent doesn't read them again
  - **Findings so far:** count, and where they are in this file
  - **Approach:** how the part is being worked — method, order, and the key assumptions
  - **Tried and dropped:** what was tried and did not work, and why, so nobody pays for it twice
  ```

  A resumed agent reads this block first and continues from **Next step**; it never restarts the part. The cost of the block is a few lines; the cost of not having it is the whole part.
- **`CONT-9` One state file per delegated task, owned by the coordinator.** `.work/<task>/STATUS.md` lists every part with its role, result file, status, last update, tokens used against budget, and, when a part stopped, why and when it can resume (for a usage limit, the reset time the error gave). The coordinator updates it when launching, at every notification, and when a part stops. Work that isn't in the state file can't be resumed by anyone else, which is the same as losing it (`PRIN-3`).
- **`CONT-10` Treat the usage limit as a certainty, not a risk.** It applies to the whole account, so every running agent stops together, whichever mode is running. **In sequential mode** (`SCRUM-10`), the product's default: run parts one or two at a time rather than fanning out, prefer a smaller model where quality allows (`CONT-5`). **In parallel mode** (`SCRUM-15`), a project's own setting may run more independent parts at once; the same certainty still applies, so that setting states its own cap, or states there is none. In either mode, when a limit error names a reset time, record it in the state file and the handoff note and **don't relaunch before it**. After a stop, resume the same agents from their progress blocks instead of starting new ones, so nothing already paid for is paid for twice.
- **`CONT-11` A step-up is a handover, not a restart.** When a part moves to a larger setup — a larger model, a bigger budget, more roles, a deeper review — nothing already paid for is paid for again:
  - **Continue before you replace.** A part that runs out of budget while making real progress is first extended and continued in the same agent (`CONT-10`). A new agent on a higher tier is for a part that failed the quality bar, lacked depth, or was sized too small.
  - **The outgoing part writes a handover** at the top of its result file, before it stops or is stopped: the goal, the approach, findings with their evidence, what was tried and dropped and why, open questions, and why it stopped. If it could not write one (a usage limit, a crash), the coordinator writes it from the result file and the state file.
  - **The coordinator adds the reason for the step-up:** the reviewer's verdict with its evidence (`ANLY-8`), or the budget reached, in `.work/<task>/STATUS.md` and the handover.
  - **The incoming agent starts from the handover** and the result file. It does not re-read sources listed as already read, unless the handover says one was misread.
  - **It may change the approach, but never without the information.** A higher tier is free to choose a different method, and often should, since the old one fell short. It still reads the handover first, keeps the findings and evidence that remain valid, and does not retry anything under **Tried and dropped** unless it states why it would now work. It records the new approach, and why it changed, in its own **Approach** line.
  - **It checks before it builds:** it re-verifies only the findings its own work rests on, since a smaller setup may have been wrong (`ANLY-4`, `ANLY-7`). It does not repeat the whole part.
  - **The interaction record measures it:** tokens before and after the step-up, and what the handover saved (`TRACE-4`).
