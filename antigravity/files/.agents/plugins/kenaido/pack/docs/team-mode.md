# Choosing how the team runs: sequential or parallel

A short guide for a team deciding between the two modes `SCRUM-10` and `SCRUM-15` describe. Read it at Sprint Planning, before you set the mode as a project setting (`DOC-8`), and again whenever the trade-offs might have changed.

## The two modes in one line each

- **Sequential mode** (`SCRUM-10`, the product's default): one main agent wears every Developer hat the Sprint needs, in turn, handing over through the result file.
- **Parallel mode** (`SCRUM-15`, a project may choose it instead): each role works in its own agent, and independent parts run at the same time; the Developers still coordinate, deciding who does what and launching the rest.

## What stays the same in both

Whichever mode a project chooses, these never change (`SCRUM-15`):

- The Scrum Master agent, independent reviewers, and the Product Owner's decisions each run apart from the coordinator, in their own agent or with a person, never combined with the work they check.
- Nobody reviews their own work.
- A person approves every push, merge, and one-way door.
- Every Scrum event and artifact applies in full, with the same Sprint Goal and Definition of Done.
- New requests during a Sprint are captured, not allowed to derail it.

So choosing a mode is a choice about *how the work is coordinated*, not about which checks or approvals apply.

## The trade-offs

| | Speed | Tokens | Coordination |
|---|---|---|---|
| **Sequential** | Parts finish one after another; wall-clock time adds up across the Sprint | One agent's context carries over between hats, so no per-agent start-up cost is paid twice | Simplest: one agent, one thread of work, nothing to reconcile |
| **Parallel** | Independent parts finish together, so a Sprint's wall-clock time can shrink a lot | Each fresh agent pays its own start-up cost (reading rules, roles, and the brief) before doing any work, so the same parts can cost about the same in tokens, or more, even though they finish sooner | Needs a coordinator to write result files and a task state file up front, relay consultations between roles, and reconcile a shared result before anyone can trust it |

Parallel mode buys time, mainly, not tokens: it does not make a part cheaper, and each extra agent adds a coordination cost of its own — more agents is not automatically more value (`SCALE-5`). It pays off when a Sprint has real independent parts and the usage window has room; it pays less when the work is mostly one thread, or the account's usage window is already tight, since a usage limit stops every running agent together in either mode.

## Measures to watch

- **Tokens spent per part against its own estimate.** Read a part that runs over its estimate as information, not only as a stop signal: was the work genuinely harder than planned, was it wasteful, or was the estimate wrong? This is an effort statistic — it feeds the next Sprint's estimates — whichever mode produced it.
- **Wall-clock time per part**, and whether independent parts actually ran together (parallel mode's main promise) rather than waiting on each other.
- **Coordination cost:** consultations relayed between roles, and corrections a reviewer finds after the fact — both are a direct cost of running roles apart, and both should be weighed against the time saved.
- **The usage window.** In both modes, a usage limit stops every running agent at once; watch how close a Sprint runs to it, since parallel mode can reach it faster even when it does not spend more in total.

## How to decide

Don't guess: run one small, comparable task in each mode and compare the measures above before committing a whole Sprint to either one. This gives early signs, not proof — a single comparison can be affected by the task's shape as much as by the mode — so keep comparing as more Sprints run, and revisit the choice at any Sprint Planning by changing the project's own setting. A team is free to run most of its work in one mode and fall back to the other for a part that doesn't fit it (`SCRUM-10`'s own exception for an occasional parallel part inside otherwise-sequential work).

## Recording the choice

The mode is a project setting (`DOC-8`): record it in your project's own settings, next to your other settings, and keep it visible to the team. `product/skills/delegate-task/SKILL.md` coordinates a delegated task the same way in both modes, so switching modes does not change how a task is delegated, checked, or recorded — only how many agents run it and when.
