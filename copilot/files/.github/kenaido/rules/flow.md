# Flow

kenaido uses Kanban practices inside Scrum to keep work, including agents' work, moving smoothly and to make delays visible. Source: the [Kanban Guide for Scrum Teams](https://www.scrum.org/resources/online-kanban-guide-scrum-teams) (January 2021), which adds to Scrum without replacing any part of it.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes the [Kanban Guide for Scrum Teams](https://www.scrum.org/resources/online-kanban-guide-scrum-teams) (January 2021) in kenaido's own words, with changes and additions; that guide is offered under the same license. The credit is in the `NOTICE` file that comes with kenaido.

- **`FLOW-1` The Kanban Guide for Scrum Teams is the reference** for flow practices and metrics. Scrum still applies in full (`SCRUM-3`).
- **`FLOW-2` Keep a Definition of Workflow.** Every Scrum Team keeps an explicit, visible Definition of Workflow: where work starts and finishes, what a work item is (usually a Product Backlog item), the states items move through, the rules for each state (which can include parts of the Definition of Done), and the work-in-progress limits. The Scrum Team owns it; agents may propose changes, and the accountable humans agree to them (`SCRUM-5`). Each project keeps its own Definition of Workflow in its record, next to its Definition of Done (`DOC-8`).
- **`FLOW-3` Limit work in progress.** Start new work only when there is capacity under the agreed limit (a "pull" system). This applies to every agent too: an agent pulls a new item only when its own limit allows. Per-agent limits are a kenaido addition (`SCRUM-4`).
- **`FLOW-4` Track the four flow metrics** for every team and agent, and show them in the app:

  | Metric | What it measures |
  |--------|------------------|
  | Work in Progress (WIP) | Items started but not yet finished |
  | Cycle Time | Time from an item's start to its finish |
  | Work Item Age | Time since an unfinished item started |
  | Throughput | Items finished per unit of time |

  Also keep a **service level expectation**: a forecast, based on past cycle times, of how long an item should take, stated with a probability (e.g. 85% of items finish within 8 days).
- **`FLOW-5` Actively manage work in progress.** Pull items in at about the rate they finish, don't let items sit and age, and act quickly on blocked items and items at risk of missing the service level expectation. If cycle times grow, lower work in progress first.
- **`FLOW-6` Use flow data in the Scrum events.** Sprint Planning uses past throughput to size the plan. The Daily Scrum works from the board and focuses on blocked, slow, or aging items. The Sprint Review uses throughput for delivery forecasts. The Sprint Retrospective inspects the flow metrics and adapts the Definition of Workflow.
- **`FLOW-7` Paraphrase, don't copy.** The guide is © Scrum.org under Creative Commons Attribution-ShareAlike 4.0. Handle it like the Scrum Guide (`SCRUM-6`).
