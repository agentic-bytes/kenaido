# Toolbox

Thinking tools any role can pick up when it needs one. A tool is a **technique**, not a role and not a field of expertise: it is a way of working through a question, and any person or agent in any role may choose one (`TEAM-15`).

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

This is the layer the Scrum Guide's End Note leaves open: it presents Scrum as a framework that other techniques and practices can fit inside. Techniques need no new accountability, so nothing here changes who is accountable for what (`SCRUM-2`, `SCRUM-3`, `TEAM-5`). Tools are a kenaido addition (`SCRUM-4`).

## The three layers, so nothing is confused with anything else

| Layer | What it is | Who holds it | Example |
|-------|-----------|--------------|---------|
| **Accountability** | Who is answerable for what | Fixed by the guides; a human always holds it (`PRIN-1`) | Product Owner, Scrum Master, Developers |
| **Field of expertise** | Deep knowledge of a subject, which a role is asked to bring at expert level (`TEAM-13`) | A role, inside or outside a Scrum Team | Security, data governance, risk method, AI engineering |
| **Tool** (this folder) | A technique for working through a question | **Anyone, any role, no permission needed** | SWOT analysis, the question set |

A tool never grants an ability its user did not already have. If something in this folder would let a role decide, approve, or direct what it otherwise could not, it is not a tool.

## The tools

| Tool | Use it to | Status | File |
|------|-----------|--------|------|
| **SWOT analysis** | Judge one option, solution, or system against its inside and outside forces, before comparing it with others | Proposed | [`swot.md`](swot.md) |
| **The question set** | Make a vague idea, request, or problem concrete enough to act on, and expose what nobody has asked. Four jobs: build context, find what is missing, understand, or separate cause from purpose. Runs in passes, with stop rules | Proposed | [`question-set.md`](question-set.md) |
| **Divide and conquer** | Split a problem too big to hold into parts that can be solved and verified separately, then put them back together — deciding the recombination and who checks the whole before splitting | Proposed | [`divide-and-conquer.md`](divide-and-conquer.md) |
| **Vital, essential, extra** | Sort what a thing needs into three layers that stack: without the vital nothing holds, the essential keeps the vital calm to operate, the extra is the next thing worth testing | Standard, on trial | [`vital-essential-extra.md`](vital-essential-extra.md) |
| **The pyramid principle** | Put the answer first and the support underneath — and, run bottom-up, work out what a pile of findings actually says | Proposed | [`pyramid-principle.md`](pyramid-principle.md) |
| **The Eisenhower matrix** | Sort a list of work by two separate questions, urgent or not and important or not, and act per box, so the important work that is not urgent is not crowded out | Standard, on trial | [`eisenhower-matrix.md`](eisenhower-matrix.md) |
| **The Pareto principle** (the 80/20 rule) | Measure how much of an effect each item causes, and find the few items that cause most of it, so effort goes there first and the rest is handled on purpose | Standard, on trial | [`pareto-principle.md`](pareto-principle.md) |
| **Dreamer, Realist, Critic** | Shape one solution in three passes held by different roles — the best version imagined, then made feasible without losing its value, then attacked with evidence — and loop until it has high value, is feasible, and has few or no expected downsides | Approved | [`dreamer-realist-critic.md`](dreamer-realist-critic.md) |

**Status** says whether a person has approved the tool. A tool marked *Proposed* may be used, and its output says which tool produced it, so a person can judge the tool by its results; a tool marked *Approved* has been accepted as standard. A tool marked *Standard, on trial* has been accepted by a person as a standard to use where it fits, on condition that it shows its value in a trial; it stays only if it does. Nothing here is hidden from the people who have to live with it.

A tool belongs here when it is a repeatable way of thinking that more than one role would use; a step-by-step procedure for this repository belongs in [`.claude/skills/`](../skills/) instead (for example, how to start a change or record a decision).

## Adding a tool

**Any role may propose a tool, and should when it finds one that worked.** A tool that stays in one agent's head helps nobody else, and the point of this folder is that the next role facing the same shape of question does not have to rediscover the technique.

1. **Use it first.** Propose a tool you have actually used on a real question here, and say what it produced. A tool nobody has used is a guess about what would help.
2. **Check it is not already here** under another name, and that it is a way of thinking rather than a repository procedure (those go to `.claude/skills/`).
3. **Write the file** from [`TEMPLATE.md`](TEMPLATE.md), in your own words. Never copy a published method's text, and never present a trademarked method's name as ours: describe it, name where it came from, and label anything about its origin you could not verify (`COMM-4`, `ANLY-2`).
4. **Add the row to the table above with status *Proposed*,** so the tool is visible to everyone the moment it exists.
5. **Tell the people.** A proposed tool goes to the accountable person as a decision request in the standard format (`departments/README.md`), noting what it produced when you used it. The person decides: approve it as standard, keep it proposed while more evidence comes in, change it, or reject it (`PRIN-2`, `PRIN-3`). Record the decision (`IMPR-4` treats a change to the way of working as a recorded decision).
6. **Rejected is not deleted.** A tool a person rejects stays in the record with the reason, the same way a retired rule does, so nobody proposes it twice without new evidence (`PRIN-3`).

**What a person is deciding:** whether a tool is worth its cost in attention, whether it fits the rules, and whether it might cause a harm the proposer did not see — ceremony, false confidence, or an output that looks like a decision when it is not.

## How to pick one

1. **Name the question first.** A tool is chosen for a question, not the other way round. If the question is already answered by evidence, no tool is needed — check the evidence (`ANLY-1`).
2. **Match the tool to the shape of the question:**

   | The question is… | Reach for |
   |------------------|-----------|
   | Vague, or a request whose purpose is unclear | The question set |
   | One option that needs judging on its merits and risks | SWOT analysis |
   | Several options that need comparing | A decision record's options table (`PRIN-3`), fed by SWOT on each |
   | Missing options altogether | Structured option generation, then one of the above |
   | Too big to hold, estimate, or finish in one go | Divide and conquer |
   | A list where everything looks equally necessary, or scope that has to be cut | Vital, essential, extra |
   | A list where what feels pressing keeps crowding out what matters | The Eisenhower matrix |
   | Many causes or items, and effort that should go where the effect is largest | The Pareto principle |
   | One solution that must be ambitious, feasible, and safe before anyone builds it | Dreamer, Realist, Critic |
   | A pile of findings with no conclusion yet | The pyramid principle, bottom-up |
   | An answer that has to reach a person who will act on it | The pyramid principle, top-down |

   The last one is not optional for writing: `COMM-5` already requires the answer first in everything agents write, so its file is the *how* rather than a choice.

   **A set for ordering work.** Vital, essential, extra; the Eisenhower matrix; and the Pareto principle work well together when a list of work needs ordering: first what the rest rests on, then what cannot wait, then where the effect is largest. None of them sets the order; the Product Owner does (`TEAM-1`). Whether the set adds value is being tested, so name the tools you used and what they changed (`ANLY-10`).

   Tools combine, and two pairs come up often: divide and conquer to find the parts, then vital, essential, extra on each part; or the question set to settle the purpose, then vital, essential, extra, which cannot be applied until the purpose is clear.

3. **Say which tool you used, and what it produced** (`ANLY-10`, `TRACE-2`). A tool used silently cannot be checked, and a tool named without output is theater.
4. **Stop when it stops paying.** A tool that produces nothing new after a few minutes is the wrong tool for that question; say so and change it rather than filling in its boxes.
5. **A tool may be run in passes, and then it needs a stopping rule.** Some tools get better the second time through, because an answer changes an earlier one. Any tool used that way states where it stops, and the four general rules are the same everywhere: stop when a pass changes nothing; stop when what is left cannot change the next decision; stop when building the smallest test is cheaper than asking again (`VALUE-4`); stop and hand over what belongs to a person or another role (`PRIN-2`, `TEAM-15`). Two passes is a normal default, a third needs a reason, and a fourth usually means the subject should be split — the same signal `ANLY-8` reads in a third review round. Looping to feel prepared is not thoroughness, and an item aging while it is questioned again is a flow problem (`FLOW-5`).

## Rules that apply to every tool

- **Evidence, not a full grid.** Every cell is a claim that needs a source, and an empty cell is an honest answer (`ANLY-1`, `ANLY-2`).
- **A tool never decides.** Its output is input for the role that owns the question, and for the person who decides (`PRIN-2`).
- **Plain words.** A tool's output is read by people who don't know the tool (`COMM-3`).
- **Paraphrase, don't copy.** Several well-known techniques are published under restrictive terms or carry a trademarked name. Describe the method in our own words, name what it came from, and never present a trademarked method as ours (`COMM-4`).
- **Record it once, where the work is.** The output belongs in the item, note, or decision record it serves, not in a separate pile of tool outputs (`ANLY-5`, `PRIN-3`).
