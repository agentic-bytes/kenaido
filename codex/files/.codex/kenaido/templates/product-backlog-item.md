# Product Backlog item template

The form every Product Backlog item uses (`SCRUM-13`). On GitHub, it is offered as an issue form: copy [`product-backlog-item.yml`](product-backlog-item.yml) into your repository's `.github/ISSUE_TEMPLATE/`. On any other tool, copy the text below. Write it in plain words, so anyone can understand it (`COMM-3`).

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

The "As a / I want to / So that" form (a user story) and acceptance criteria are kenaido additions, because the Scrum Guide names neither (`SCRUM-4`).

```markdown
# PBI-NN: <short title, in plain words>

### As a
<the role that needs this — a person or an agent role>

### I want to
<the scope: what should exist or be possible when this is done; small enough to be Done in one Sprint>

### So that
<the value: who benefits, and how>

### Topic, priority, and effort
Topic: <pipeline | scrum-process | governance | continuity | agent-platform | product-discovery | legal-and-naming>
Priority: <critical | high | medium | low> (an input to the order; the Product Owner orders the backlog)
Effort: <1 | 2 | 3 | 5 | 8 | 13> (the Developers' estimate; 13 means split it)

### Definition of Done
Meets the company-wide Definition of Done (project/definition-of-done.md).
Item-specific additions: <none, or stricter conditions for this item only>

### Acceptance criteria
- [ ] <a condition someone who did not do the work can check>
- [ ] <another>

### Links and details
<decisions, resources, evidence; later understanding goes here or in comments>

### Split
<empty, or: split into PBI-.. and PBI-.., because ..., as refinement allows>
```
