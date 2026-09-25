---
name: delegate-task
description: Coordinate one or more role agents on a task, acting as the Scrum Master agent - write a brief with dependencies, consultations, research checks, and usage budgets, launch the agents, have a different role check the results, and record the interaction and its measures. Use whenever work is delegated to agents.
---

# Delegate a task

You coordinate as a **Developer**, because Developers decide who does what (`TRACE-6`): the main agent, wearing each hat in turn in sequential mode (`SCRUM-10`, the product's default), or launching a role agent per part in parallel mode (`SCRUM-15`, a project setting) — this skill's steps below are the same in both modes. The Scrum Master agent facilitates the events and removes impediments, and never does Developer work. Applies `CONT-1` to `CONT-10`, `TRACE-1` to `TRACE-8`, `ANLY-4`, `ANLY-8`, and `IMPR-5`.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

## Steps

1. **Write the brief** in the Sprint's folder, `project/sprints/sprint-NN/tasks/` (`CONT-3`), from the brief template: goal, assignments with a usage budget per part, dependencies and roles to consult, and the research checks. **Name which backlog item the task serves, or which refinement it performs** (`SCRUM-9`) — work that serves no item belongs on the backlog first. Name the role that will check the results; it must not be you.
2. **Size the task first:** routine, standard, hard, or critical, which sets the model, budget, reviewers, and checkpoints. Delegating costs about 42,000 tokens before any work, so routine work is done inline. When in doubt, size by the stakes. When the budget runs out with real progress, continue the same agent first (one extension of up to half; more goes to the person). Step up to the next tier when the quality bar is not met, the task was sized too small, or a reviewer finds the work lacks depth. **Every step-up is a handover, not a restart** (`CONT-11`): the outgoing part writes a handover, you add why it stepped up, and the incoming agent starts from it. It may change the approach, but it reads the handover first, keeps the valid findings, and records why it changed.
3. **Prepare for interruptions** (`CONT-1` to `CONT-3`, `CONT-7` to `CONT-9`, `CONT-11`): create each part's result file under `.work/` **with its headings and the progress block** (Status, Next step, Already read, Findings so far), create the task state file `.work/<task>/STATUS.md`, name the review baseline commit in the brief, update `project/notes/handoff.md`, and commit the brief before launching.
4. **Launch the agents** with short prompts that point to the brief. Tell each agent to **cite the exact source line for every figure, quote, and claim** (`ANLY-11`), and to **write its own token estimate in its result file before it starts, from a reference you give it: the last comparable part's measured usage**, **plus a stated markup of about 35% when the agent is fresh and the part is critical-tier**. Agents cannot see their own usage, so you measure it, from the running totals: **one or two at a time, not a wide fan-out**, in sequential mode's exception (`SCRUM-10`); **as many independent parts at once as your project's parallel-mode setting allows**, in parallel mode (`SCRUM-15`). Either way, the usage limit is account-wide and stops every running agent together (`CONT-10`). Prefer a smaller model for well-defined research (`CONT-5`). Tell each agent to read its result file first, keep the progress block current, and write every finding as soon as it has it.
5. **Relay consultations:** when an agent needs another role's input, pass the question to that role and its answer back, and record both.
6. **Collect the results** from the result files, not only the agents' final messages. Update the state file at every notification.
7. **If a part stops on a usage limit:** record in the state file what it had reached and the reset time the error named, put it in the handoff note, wait for the reset, then **resume that same agent** from its progress block. Never start a fresh agent for a part that already spent tokens (`CONT-10`).
8. **Have a different role check** every claim that changes a recommendation, including any change you made while merging (`TRACE-6`, `ANLY-4`).
9. **Record the interaction** in `project/interactions/`, including **each agent's token estimate against its measured usage**, with the template: context tags, timeline, how the shared result formed, checks and corrections, and measures including tokens against budget and consultations (`TRACE-1` to `TRACE-4`).
10. **Feed the improvement flow:** add new suggestions to the improvement list, and add this task's measures to any trial it belongs to (`IMPR-1`, `IMPR-6`). **At a Sprint Retrospective specifically:** draft the ranked improvements straight into `retrospective.md` (not only a working file under `.work/`), with "Decision on the improvements: not decided yet", and commit that draft before asking the accountable person to choose (`IMPR-4`), so the choice is made from the record, where everyone can read it. This record's second commit, with the choice filled in, is what concludes the Sprint (Scrum Guide, paraphrased, `SCRUM-6`).
11. **Update the handoff note** and commit, stating your role in the commit message.

## Setup defaults, measured

**Early signs from a small number of runs, not a promise.** They are a starting reference for sizing; replace them with your own team's measured usage as you collect it (step 4), and with the model and setup your team actually runs.

| Kind of task | Setup that met the bar | Tokens used |
|--------------|------------------------|-------------|
| Review of 10 to 15 records or files | One reviewer agent, mid-size model | 130,000 to 135,000 |
| A follow-up check by the same reviewer | Resume that agent (`CONT-10`) | about 9,000 |
| Naming checks (language and clearance) | One agent holding both checker roles, mid-size model | about 95,000 for 8 names |
| Planning decision, or a Planning check | One agent, mid-size model | 88,000 to 95,000 |

## Role tests

When a **new agent, or a role not yet tested, does critical-tier work** in a Sprint, plan at least one role test for it in that Sprint: a task with a known answer, run blind. Record the score in the interaction record and in the role's scorecard.
