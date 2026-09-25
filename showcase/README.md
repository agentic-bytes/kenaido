# Showcase: kenaido building kenaido

kenaido is being built with itself. The screenshots below, taken from this project's own GitHub repository, show its board, its records, and its guardrails at work during real Sprints.

## What to know before looking

- **The agents are AI models playing roles, not people and not a real Scrum Team.** Scrum, its events, and its records are simulated for them, as closely as possible to what the guides ask of a human team.
- **A person, the project's owner, approved every Sprint Goal and every Increment's delivery, and kept every one-way decision** — publishing, ethics rulings, and how much the team could decide on its own. Running each Sprint was delegated to the agents from 2026-09-13 (decision 0031); pushing branches was delegated from Sprint 5 (0038) and Sprint 8 (0049); from Sprint 11, each Sprint ran on its own, merges included (0064, 0065), a delegation renewed through Sprint 26 (0096). None of this removed the owner's approval of each Sprint Goal or each Increment's delivery, and it stays revocable at any time.
- **The comments shown below appear under the owner's own GitHub account**, since every agent shares that one account. Each comment names, in its own first line, which AI role wrote it, for example "Author: developer/coordinator" or "Review: ... reviewer=technical-writer/p9".
- **GitHub is shown only as the tool this project happens to use to host its board, pull requests, and records**, with no claim of affiliation with GitHub.

## The images

1. **`01-board-sprint.png`** — The GitHub Project board: Sprint 25's seven items, all marked Done, with their layer and priority.
2. **`02-backlog-item.png`** — A Product Backlog item's own page: its "as a / I want to / so that" form, acceptance criteria, and board fields.
3. **`03-review-found-bug.png`** — A pull request where an independent reviewer, a separate AI role, found a bug and asked for another round.
4. **`04-integration-pr.png`** — A pull request that gathered a Sprint's fixes into one commit, listing each item, its reviewed commit, and who reviewed it.
5. **`05-merge-gate.png`** — What a merge needs on the record: the reviewer's "confirmed" verdict and a passing local check, both on the exact commit that gets merged.
6. **`06-sprint-records.png`** — The repository's own record of its Sprints: one folder per Sprint, each with its planning, daily, review, and retrospective files.
7. **`07-decision-record.png`** — A decision record: a choice about how the team's automated checks run, written up with the project owner's own words and the reasoning behind it.
8. **`08-guardrail.png`** — A guardrail refusing a command that would have changed the protected `main` branch directly; the agent moves the change to a new branch instead, and says so plainly.
9. **`09-guardrail.png`** — A setup command's own check refusing to run while the protected `main` branch was checked out, so nothing was installed there.
10. **`10-burn-up-chart.png`** — A burn-up chart counting how many backlog items are open, completed, or not planned. This counts activity, not value.
