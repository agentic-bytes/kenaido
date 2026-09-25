---
name: start-sprint
description: Start a new Sprint's folder with all five of its records at once, by running kenaido's new-sprint script. Use before anything is written for a new Sprint, including the Planning draft, and to check at a session's close that no Sprint folder is missing a record.
---

# Start a Sprint

Applies `SCRUM-9` (every Sprint's folder holds its five records) and `SCRUM-17` (step 1 of the [Sprint step table](../../docs/sprint-steps.md)) in [`rules/scrum.md`](../../../rules/kenaido/scrum.md).

## Steps

1. **Before anything is written for the new Sprint,** including the Planning draft, run the [new-sprint script](../../scripts/new-sprint.sh) from inside the project, with the Sprint's number:
   ```bash
   sh <kenaido folder>/scripts/new-sprint.sh <N>
   ```
   The script sits in the `scripts/` folder of kenaido's folder in the project, beside `templates/`. To find it from the project's root, run `find . -path '*/scripts/new-sprint.sh' -not -path './.git/*'`.
   **On Windows,** run the same command in Git Bash. A PowerShell version of the script is not available yet.
2. **Read what it printed.** `created` is a new record. `kept` is a record that was already there: the script never writes to an existing file, so nothing in it changed. `not written` is the state file (`CONT-9`), when git doesn't ignore `.work/` here: add `.work/` to `.gitignore`, then run it again.
3. **Write the Planning into the files it created.** Draft `planning.md` and `sprint-backlog.md` in place (step 1 of the step table). **Never create a Sprint's record by hand:** a folder started that way can miss records.
4. **Commit the new files on a work branch,** as for any change ([`start-change`](../start-change/SKILL.md)). The script commits nothing.
5. **At every session's close,** as part of the session check (`SCRUM-17`), run:
   ```bash
   sh <kenaido folder>/scripts/new-sprint.sh --check
   ```
   It lists every Sprint folder missing a record, and exits 1 if there is one. Running the script with that Sprint's number creates the missing records and leaves the others untouched. `sprint-00/`, which holds work from before Scrum started (`CONT-3`), is not checked.
