# Analysis

These apply whenever a coding agent investigates, reviews, plans, or answers a question.

- **`ANLY-1` Evidence and ground truth.** Base every finding on something you checked: code, command output, test results, documentation, or data. What you can check beats what you remember.
- **`ANLY-2` No hidden assumptions.** Don't assume. If something can't be verified, label it as an assumption and say what would confirm it.
- **`ANLY-3` Straight to the point.** Report findings and conclusions, not the steps you took to get there.
- **`ANLY-4` Split and delegate when needed.** For large tasks with independent parts, split the work and hand the parts to subagents running in parallel. Check their results before using them, because they can be wrong. Don't split small tasks: each subagent starts from scratch, which costs time.
- **`ANLY-5` Keep notes of findings.** Record key findings in `project/notes/findings.md` (create it if missing). Read it before starting an analysis so you don't redo work.
- **`ANLY-6` Keep notes of lessons learned.** When a mistake happens or the user corrects you, record in `project/notes/lessons-learned.md` what went wrong, why, and how to avoid it, and tag the roles it matters most for (`ANLY-9`). Read it at the start of each task so the same mistake doesn't repeat.
- **`ANLY-7` Check your premises.** Before building on a premise (a starting fact or belief), confirm it is true, validated, and relevant to the question at hand. Follow established best practices. If a premise turns out to be wrong, stop and revisit every conclusion built on it. This keeps reasoning sound and prevents hallucination, meaning statements that sound right but are false.
- **`ANLY-8` Every outcome is reviewed before it counts as done.** No result is finished until a role other than its author has reviewed it: an analysis, a plan, a decision draft, code, a document, or a delegated agent's report (`GIT-6`, `TRACE-6`). The reviewer ends with one of three verdicts:

  | Verdict | What it means | What it must include |
  |---------|---------------|----------------------|
  | **Confirmed** | Good enough to use | What was checked, and against which source |
  | **Confirmed with conditions** | Usable if something holds or follows | Each condition, and who owns it |
  | **Another iteration needed** | Not usable yet | The evidence showing what to improve, not a preference |

  The author then improves the work and it is reviewed again, until it is confirmed. A request for another iteration always carries evidence (`ANLY-1`); a reviewer who only dislikes an approach says so as an option to weigh, not as a defect. If author and reviewer don't agree, both positions go to the accountable person with the evidence (`PRIN-2`). Choose the reviewer by what the work risks: an expert of the same field when depth matters, a different field when the risk is missing something outside it (`TEAM-13`, `TEAM-15`). Review is not a phase or a gate one role owns: any role may review any outcome, no role reviews its own work in any of its roles (`TEAM-5`, `TEAM-12`), and every round is recorded (`TRACE-1`, `TRACE-3`). If an outcome needs a third iteration, the Scrum Master agent treats it as an impediment, and the cause goes into the lessons learned and the improvement list (`ANLY-6`, `IMPR-1`).
- **`ANLY-9` Lessons learned belong to the whole team, tagged for those who need them most.** One shared list (`project/notes/lessons-learned.md`), read and written by every role:
  - **Tag each entry** with **Applies to:** the roles it matters most for, `team` for how roles work together, or `all roles` when it is general.
  - **Read before working:** at the start of a task, read the general and `team` entries and those tagged for your role; before reviewing someone's outcome, also read those tagged for that outcome's field.
  - **Anyone may contribute anywhere.** A role may add a lesson about another role's field when it brings evidence and stays inside the guides (`TEAM-15`, `ANLY-1`); the role that owns the field confirms or corrects it, and both are recorded (`ANLY-8`).
  - **Team-level lessons** are inspected each Sprint with the interaction records (`TRACE-5`), and a lesson that keeps coming back becomes an improvement item and is fixed in the rules, roles, or briefs, not repeated in reviews (`IMPR-1`).

- **`ANLY-10` Use a tool when it fits, and name it.** The [toolbox](../../kenaido/toolbox/) holds thinking tools any role may pick up without permission: a tool is a technique, not a role and not a field of expertise, and it never grants an ability its user did not already have. Pick one for the question at hand, say which one you used and what it produced, and record the output with the work it serves, not in a pile of its own (`TRACE-2`, `ANLY-5`). A tool never decides: its output is input for the role that owns the question and for the person who decides (`PRIN-2`). Stop using a tool that stops paying, and say so, rather than filling in its boxes. **When you find a tool that worked and is not in the toolbox, add it** — from the template, with a "when not to use it" section — mark it proposed, and take it to the accountable person as a decision request, so the people who have to live with it judge it and every other role can use it (`PRIN-2`, `PRIN-3`, `IMPR-4`). A tool that stays in one agent's head helps nobody else.

- **`ANLY-11` Cite the exact line behind every figure, quote, and claim that something exists.** Before writing a number, a quotation, or a statement that something exists or happened, open its source and cite it precisely: the file and the line or section, the command and its output, or the issue and its field. A claim whose source cannot be pointed to is labeled unverified (`ANLY-2`). Reviewers check the citations first.

Notes live in the repository, not in an agent's private memory, so the team can see and review them. Give each entry a date, a one-line summary, and the evidence behind it. The `record-note` skill walks through it.
