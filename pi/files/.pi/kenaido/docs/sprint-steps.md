# The Sprint step table

Every step of a Sprint, in order, with what starts it, which role does it, what it produces, and what must be true before the next step starts. `SCRUM-17` makes this table the rule; the rules each step comes from are cited in its row. The order and the gates are a kenaido addition (`SCRUM-4`). A project may add steps or tighten a gate in its own settings (`DOC-8`), but may not drop a step.

**How to read it:**
- A **trigger** is an event, not a time of day.
- The **owner** does the step. Others may help, but they don't take it over.
- **The gate** must hold before the next step starts.
- A row marked **checkable** is one a script can check from the repository's files and git history alone. The last section says what the check reads.

In sequential mode, "a part starts" means the main agent changes hats (`SCRUM-10`). In parallel mode, it means an agent is launched or continued (`SCRUM-15`).

## Planning

| # | Step | Trigger | Owner | Output, and where it is recorded | Gate before the next step |
|---|------|---------|-------|-----------------------------------|---------------------------|
| 1 | Draft the Planning | The previous Sprint's Retrospective concluded it, or the project starts | Product Owner agent (the Goal, the Order, the forecast); the Developers (the plan and the estimates) | First, the Sprint's folder with all five records and `tasks/`, from the new-sprint script ([`start-sprint`](../../skills/kenaido-start-sprint/SKILL.md)); then the `planning.md` and `sprint-backlog.md` drafts written into it, the Goal marked as proposed (`SCRUM-9`) | Every item is in the item form (`SCRUM-13`); every baseline has the command that produced it; the buffer and its candidates are named (`SCRUM-16`) |
| 2 | Check the Planning | The drafts are complete | Scrum Master agent | Its verdict and conditions, in the Planning record (`ANLY-8`) | The verdict is confirmed, or each condition is met or owned |
| 3 | Approve the Sprint Goal | The check is done | The accountable person, as the Product Owner (`SCRUM-5`, `PRIN-2`) | The approval, with its date and who gave it, in `planning.md` | **Checkable.** No work is delegated before the approval (`SCRUM-9`) |
| 4 | Start the Sprint on the board | The Goal is approved | The Developers | The Sprint's items assigned to its iteration, in their starting state (`SCRUM-12`) | The board and the Sprint Backlog list the same items |

## During the Sprint, for every part

| # | Step | Trigger | Owner | Output, and where it is recorded | Gate before the next step |
|---|------|---------|-------|-----------------------------------|---------------------------|
| 5 | Prepare a part | The Developers decide to start a part, or to give a running agent a second task | The Developers | A brief in the Sprint's `tasks/` (`CONT-3`); a result file with its progress block (`CONT-7`, `CONT-8`); a row in the state file naming both, with a budget (`CONT-9`) | **Checkable.** The part doesn't start without all three |
| 6 | Do the part | Step 5 is done | The role the brief names | Findings in its result file, written as they come (`CONT-7`) | The result file's status says done or stopped, with the reason |
| 7 | Record the part's result | The part returns | The Developers | Its row in the state file: status, and its tokens from the tool's own count, not the agent's estimate (`CONT-9`, `TRACE-4`) | **Checkable.** The row is updated before another part starts |
| 8 | Review | The author's part is done | A role other than the author (`ANLY-8`, `GIT-6`) | A verdict in the reviewer's result file; for a pull request, the approval recorded on its exact head commit | Confirmed, or each condition closed by the reviewer that set it |
| 9 | Merge | The approval is on the head commit and the checks ran and passed on it (`TEST-2`) | The Developers, within a recorded delegation, or the accountable person (`GIT-4`, `GIT-5`) | The merged pull request | Steps 10 and 11 come before the next part starts |
| 10 | **The merge checkpoint** | A merge | The Developers | The item's state on the board (`SCRUM-12`); its row in the Sprint Backlog, with its result; a line in the Daily entry naming the pull request | **Checkable, except the board.** All three are done before the next part starts |
| 11 | Session check | A merge (one check may cover merges that land together), and every session's end | Scrum Master agent | Each missed or late step, as a line in the Daily entry, and as a lesson where none covers it (`ANLY-6`); what it read on the board; what `new-sprint --check` found ([`start-sprint`](../../skills/kenaido-start-sprint/SKILL.md)) | **Checkable.** Its row and result file exist in the state file before the session closes |
| 12 | Use the buffer | The Developers spend it on committed work, or pull a candidate with the Product Owner (`SCRUM-16`) | The Developers; also the Product Owner for new work | A row in the Sprint Backlog's buffer log: what, when, who agreed, why, and how it was checked against the Goal | The row is written before the work starts |
| 13 | Capture a new request | Anyone asks for something new during the Sprint | Whoever receives it | A Product Backlog item, for the next Sprint Planning (`SCRUM-11`) | Captured in the same session |
| 14 | Close an item as Done | The item meets the Definition of Done | The Developers | The item closed on the board, with a comment linking its pull requests (`SCRUM-12`); its row in the Sprint Backlog | Its records are on `main` first |

## At the end of every working session

| # | Step | Trigger | Owner | Output, and where it is recorded | Gate before the next step |
|---|------|---------|-------|-----------------------------------|---------------------------|
| 15 | The Daily entry | The session ends, or before the first part of the next session if it ended unexpectedly | The Developers (`SCRUM-9`) | An entry in `daily.md`: done, next, blocked or aging, and a token figure worth flagging | **Checkable.** The session doesn't close without it |
| 16 | The session's other records | The same | The Developers | The Sprint Backlog brought current (step 10 done for every merge); the state file's total re-derived from its rows (`CONT-9`); the handoff note updated (`CONT-2`) | **Checkable.** All are current, and step 11's check has run |

## The close

| # | Step | Trigger | Owner | Output, and where it is recorded | Gate before the next step |
|---|------|---------|-------|-----------------------------------|---------------------------|
| 17 | The Sprint Review | The Sprint Goal is met, or the Sprint's length is reached | The Developers present the Increments; the Product Owner agent adapts the backlog; the Scrum Master agent facilitates and records | `review.md` and the Sprint's interaction record (`TRACE-1` to `TRACE-5`) | Reviewed by a role that didn't write it; the accountable person approves delivery of the Increments (`GIT-6`) |
| 18 | The Sprint Retrospective | The Review is held | Scrum Master agent (facilitates); the accountable person, or the Developers under a recorded delegation (chooses) | `retrospective.md`: first the trials closed and the improvements ranked, then the choice (`IMPR-4`) | **Checkable.** The choice is recorded; the record's commit concludes the Sprint |
| 19 | Close the records | The Retrospective's choice is recorded | The Developers | The close's records merged; the state file closed with its total; the handoff note current | **Checkable.** The next Sprint's Planning starts only after this; nothing is delegated in between (`SCRUM-9`) |

## What a check can see

A script can check the steps marked **checkable** from files and git alone. Records that live outside the repository, such as the state file in a git-ignored folder or the board in another tool, are checked only where they can be read. Where a record can't be read, the check says that step was **skipped**, and a skip is never a pass (`TEST-2`). Each check has a control run that plants a miss and must fail. Which fields the records carry for the check to read, and where the check runs, are project settings (`DOC-8`).

| Step | What the check reads | It fails when |
|------|----------------------|---------------|
| 1 | The Sprint's folder | It holds fewer than its five records: `planning.md`, `sprint-backlog.md`, `daily.md`, `review.md`, `retrospective.md` |
| 3 | `planning.md`, and the Sprint's `tasks/` folder | A brief exists for Sprint work, but the Planning has no approval line |
| 5, 7 | The state file, `tasks/`, the result files | A row names no brief, or a brief or result file that doesn't exist; a finished part's row has no token figure |
| 10 | `git log --first-parent --merges` since the Planning; `daily.md`; `sprint-backlog.md` | A pull request merged since the Planning isn't named in the Daily log; an item a merge served still shows no result in the Sprint Backlog. The most recent merge alone is reported as **late**, not failed: a change that updates the Daily can't name its own merge before it happens, so the next Daily entry names it |
| 11, 15, 16 | The state file's session rows, and every session check it lists (the one each session names, and every part row with a session-check brief), with their status and their result file timestamps; `git log --first-parent --merges` since the Planning; `daily.md`; the handoff note | A merge has no done session check after it, whether its session is open or closed: no done check names the pull request in its status, and none has a result file of its own last written after the merge's commit time (a file two part rows share shows only when the latest of them wrote it, so its time covers nothing) — the most recent merge alone is **late**, not failed, for the same reason as step 10; a closed session has no Daily entry, or no session check with its result file; the state file's total doesn't match its rows; the handoff note is older than the latest Daily entry |
| 18, 19 | `retrospective.md`; the next Sprint's `planning.md` | A next Sprint's Goal is approved while this Sprint's Retrospective has no recorded choice |
| 4, 10, 14 on the board | The board, through its tool's command line, where the check can reach it | An item whose pull request merged still shows a starting state; a Done item is still open. Where the check can't reach the board, it reports **skipped**, and the Scrum Master agent's session check reads the board instead |
