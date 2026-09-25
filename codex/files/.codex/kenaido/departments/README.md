# Departments and roles

How each role behaves in kenaido, whether a person or an agent holds it: what it does, when, how, what it needs, what it produces, what it may decide, and what people in that role see in the app. The life cycle's best practices everyone follows are in [`rules/`](../rules/); these files define behavior per role.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

> **What these roles are, when an agent takes them.** An agent given one of these roles is an AI model playing it, not a person, and a group of such agents can never match a real Scrum Team of people. Its output comes from a statistical model, so it can vary and be wrong, and it changes with the model and its version. The roles follow the guides' names only so you know what to expect of each agent; the frameworks are simulated for agents, and kenaido's rules give every accountability to a person. Check what the agents produce (`ETH-11`). The full statement is in the `DISCLAIMER.md` file that comes with kenaido.

## Departments

An organization using kenaido is organized in departments. Each department has a README with its mission, its interface for requests, the roles it has written, and the roles it has defined but not yet staffed. How to engage any role or department is in [`rules/organization.md`](../rules/organization.md) (`ORG-1` to `ORG-15`).

| Department | Serves by | Led by (a person, `ORG-3`) |
|------------|-----------|------------------------------|
| [Ethics Committee](ethics-committee/README.md) | Keeping the values first in every decision | The committee chair |
| [Strategy](strategy/README.md) | Direction, market analysis, the goal tree | CEO |
| [Product and Engineering](product-engineering/README.md) | Building the product, through the Scrum Teams | CTO and CPO |
| [Marketing](marketing/README.md) | Brand, names, messages, discoverability, community | CMO |
| [Sales](sales/README.md) | Helping customers get the product on fair terms | CRO |
| [Customer Success](customer-success/README.md) | Customers succeeding, and feedback into the market loop | CRO |
| [Finance](finance/README.md) | Budget, forecasts, unit economics, pricing analysis | CFO |
| [Legal and Compliance](legal-compliance/README.md) | Clearance, terms, data protection, responsible AI, obligations | CLO |
| [Security and Risk](security-risk/README.md) | Security program, risk register, incidents | CISO |
| [People and Operations](people-operations/README.md) | Agents and people working well together; providers and tools | COO and CPeO |

These ten departments are kenaido's default list. An organization adjusts them to its own shape. Moving a role file between departments is a scripted change that keeps every link working.

## Leadership (human accountabilities)

**Leadership roles are always held by people** (`ORG-3`, `PRIN-1`). One person may hold several; which person holds each is a team's own setting. Agents advise and do the work, and never hold these accountabilities. No leader directs how a Scrum Team works (`TEAM-5`, `ORG-2`): leaders set goals and guardrails, as in step 1 of [the kenaido loop](../docs/lifecycle-flow.md). The whole organization respects the Product Owner's decisions on the product, as the Scrum Guide requires.

| Role | Accountable for | Advised by (agent roles) |
|------|-----------------|--------------------------|
| **CEO** (Chief Executive Officer) | Direction, strategy, and the business living by the values | Business Strategist, Agile Leader |
| **CTO** (Chief Technology Officer) | Technology direction and engineering quality | Architect, AI Expert and Developer, DevSecOps Engineer, Technology Strategist |
| **CPO** (Chief Product Officer) | The value of the product portfolio; never overrides a Product Owner's decisions on their product | Product Owner agents, Business Analyst, Data and Analytics Specialist |
| **CFO** (Chief Financial Officer) | Money: budget, pricing economics, payments through providers | Finance Analyst |
| **COO** (Chief Operating Officer) | Operations, including how agents run: capacity, models, token budgets | Agent Operations Manager, Project Manager |
| **CMO** (Chief Marketing Officer) | Brand and marketing | Brand Strategist, Marketing Strategist, Search and Discoverability Specialist |
| **CRO** (Chief Revenue Officer) | Sales and customer success | Sales Specialist, Customer Success Manager |
| **CISO** (Chief Information Security Officer) | Security and risk across the company | Security Officer, Risk Manager, Security Expert |
| **CLO** (Chief Legal Officer, General Counsel) | Legal and compliance | Legal Counsel, Compliance Officer, Trademark and Clearance Analyst |
| **CDO** (Chief Data Officer) | Data areas and their Data Owners | Data Owner agents, Data Protection Expert, Data and Analytics Specialist |
| **CAIO** (Chief AI Officer) | AI strategy, and responsible AI | Responsible AI Lead, AI Evaluation Specialist |
| **CPeO** (Chief People Officer) | People, and how people and agents work together | People Partner, Agile Leader |
| **Ethics Committee chair** | The values, in every decision (`ETH-6`) | Ethics and Sustainability Officer |

In a small company one person holds several of these; in a larger one, each can be a different person. The CDO may be combined with the CTO, and the CAIO with the CTO or the CLO.

## How roles are organized

| Layer | What it answers | Examples | Set by |
|-------|-----------------|----------|--------|
| **Scrum accountability** | Who is accountable for what in a Scrum Team | Product Owner, Scrum Master, Developers | The Scrum Guide (fixed) |
| **Job role** | Which real-world skills the role brings | Architect, Backend Developer, Security Expert, AI Expert and Developer | kenaido (`SCRUM-4`) |
| **Seniority** | How much experience the holder has | Junior, mid-level, senior | kenaido (`SCRUM-4`) |

Every role can be held by a person, an agent, or both. Inside a Scrum Team, every job role holds the Developer accountability, and no job role or seniority level has authority over others (`TEAM-5`, `TEAM-9`). Some roles work outside the Scrum Teams (`TEAM-10`).

## Roles, fields, and tools

Three different things, often confused:

| Layer | What it is | Who holds it | Where it lives |
|-------|-----------|--------------|----------------|
| **Scrum accountability** | Who is answerable for what | Fixed by the guides; a human always holds it (`PRIN-1`) | The guides, and `rules/` |
| **Role and its expertise** | The skills a person brings, or an agent is asked to apply, at expert level (`TEAM-13`) | One role, inside a Scrum Team or outside the teams | This folder |
| **Tool** | A technique for working through a question — SWOT analysis, the question set | **Anyone, any role, no permission needed** (`ANLY-10`) | [`toolbox/`](../toolbox/) |

A tool never grants an ability its user did not already have, so the toolbox can grow freely without touching who is accountable for what. The Scrum Guide's End Note is what leaves this layer open: it presents Scrum as a framework that other techniques and practices can fit inside.

## Expert level asked of every role

Every role is asked to work at the level of a subject matter expert in its field, whether a person or an agent takes it (`TEAM-13`). For an agent, this is an instruction it is given, not a quality it is certain to reach: its output varies with the model and must be checked (`ETH-11`). Each role file has an **Expertise** section listing the areas it is expected to master.

| What expert level means | What it does not mean |
|-------------------------|-----------------------|
| Knows current practice, the relevant standards, and the field's common mistakes, and brings them unasked | Knowing everything, or answering outside its field |
| Gives options with their trade-offs, and cites the standard, guide, or measurement behind each (`ANLY-1`, `COMM-6`) | Presenting a preference as the only option |
| Says plainly what it cannot verify, and names the role that owns the question (`ANLY-2`, `ANLY-7`) | Guessing confidently, or filling gaps with plausible-sounding text |
| Checks the source when a field moves fast (`SCRUM-1`) | Answering from memory about a standard or a tool |
| Explains expert depth in plain words so a non-expert can decide (`COMM-3`, `PRIN-2`) | Hiding behind jargon |
| An agent holding several roles is expert in each one (`TEAM-12`) | Taking a role it cannot cover at that level |

Seniority does not change this: every instance is asked to work at expert level, and seniority decides how much review its work gets and how complex the items it takes are. Roles collaborate only through the framework, never around it: the Scrum events, the shared board, the records, and the accountable people (`TEAM-15`).

## Scrum Team roles

| Role | How many | Definition |
|------|----------|------------|
| **Product Owner** | Exactly 1 per product (**fixed**, `TEAM-1`) | [`product-owner.md`](../../agents/kenaido-product-owner.toml) |
| **Scrum Master** | Exactly 1 per Scrum Team (**fixed**, `TEAM-2`) | [`scrum-master.md`](../../agents/kenaido-scrum-master.toml) |
| **Developer** (base for every job role below) | At least 1 per Scrum Team; team size typically 10 or fewer (flexible, `TEAM-3`, `TEAM-4`) | [`developer.md`](../../agents/kenaido-developer.toml) |

### Developer job roles

Each adds to [`developer.md`](../../agents/kenaido-developer.toml). Counts are flexible (`TEAM-9`).

| Job role | Covers | Definition |
|----------|--------|------------|
| **Business Analyst** | Stakeholder needs, business processes and rules, requirements as hypotheses, evidence for decisions | [`business-analyst.md`](../../agents/kenaido-business-analyst.toml) |
| **Architect** | Structure, interfaces, contracts, quality attributes, technical debt, architecture recovery of unfamiliar codebases | [`architect.md`](../../agents/kenaido-architect.toml) |
| **Backend Developer** | Services, business logic, APIs, integrations | [`backend-developer.md`](../../agents/kenaido-backend-developer.toml) |
| **Migration Engineer** | Whole-application and platform migration: language, framework, runtime, cloud | [`migration-engineer.md`](../../agents/kenaido-migration-engineer.toml) |
| **Frontend Developer** | Screens, components, accessibility, front-end performance | [`frontend-developer.md`](../../agents/kenaido-frontend-developer.toml) |
| **Full-Stack Developer** | Items that span the interface and the server | [`full-stack-developer.md`](../../agents/kenaido-full-stack-developer.toml) |
| **UX/UI Designer** | User research, flows, prototypes, visual design, usability | [`ux-ui-designer.md`](../../agents/kenaido-ux-ui-designer.toml) |
| **Database Engineer** | Data models, migrations, query performance, data quality | [`database-engineer.md`](../../agents/kenaido-database-engineer.toml) |
| **Infrastructure Engineer** | Environments as code, operations, backups and recovery, capacity | [`infrastructure-engineer.md`](../../agents/kenaido-infrastructure-engineer.toml) |
| **DevSecOps Engineer** | Pipeline, security automation, releases, observability tools | [`devsecops-engineer.md`](../../agents/kenaido-devsecops-engineer.toml) |
| **Security Expert** | Threat models, security reviews, findings, dependency risks | [`security-expert.md`](../../agents/kenaido-security-expert.toml) |
| **Data Protection Expert** | Personal data inventory, privacy by design, impact assessments | [`data-protection-expert.md`](../../agents/kenaido-data-protection-expert.toml) |
| **AI Expert and Developer** | AI solution design, models and evaluation, prompts and agent design, AI risks, cost and token budgets | [`ai-expert-developer.md`](../../agents/kenaido-ai-expert-developer.toml) |
| **Brainstorming Expert** | Structured idea generation, problem framing, real option sets with trade-offs, premortems | [`brainstorming-expert.md`](../../agents/kenaido-brainstorming-expert.toml) |
| **Tester** | Test design and automation, Definition of Done checks, exploratory testing | [`tester.md`](../../agents/kenaido-tester.toml) |
| **AI Evaluation Specialist** | Independent evaluation of AI features and agents, red teaming, the role test harness | [`ai-evaluation-specialist.md`](../../agents/kenaido-ai-evaluation-specialist.toml) |
| **Technical Writer** | Documentation structure, consistency, readability | [`technical-writer.md`](../../agents/kenaido-technical-writer.toml) |

### Combined roles

One agent may hold several expert roles and act as a multi-skilled expert, e.g. "Tester and Security Expert agent" or "Backend Developer, Database Engineer, and Infrastructure Engineer agent". This keeps teams within their size limit while covering every skill (`TEAM-4`, `TEAM-12`):

| Combination | Allowed? |
|-------------|----------|
| Several Developer job roles | Yes; counts as one team member |
| A Scrum accountability with another Scrum accountability (e.g. Product Owner and Scrum Master agent) | No; they stay separate agents |
| A Developer job role with a role outside the teams (e.g. Tester and Test Manager) | Only if neither role checks the other's work |
| Any combination that would review or approve its own work | No (`GIT-6`) |

A combined agent follows every rule of each role it holds; where they differ, the stricter one applies. Its name lists its roles, and its work-in-progress limit covers all of them together (`FLOW-3`).

## Roles outside the Scrum Teams

These coordinate or support across teams, don't count toward team size, and never direct how a Scrum Team works (`TEAM-10`).

| Role | How many | Definition |
|------|----------|------------|
| **Integration Team member** | 1 or more, only when several Scrum Teams share a product; the Nexus Integration Team always also includes the Product Owner and one Scrum Master (**fixed** composition, `TEAM-6`) | [`integration-team.md`](../../agents/kenaido-integration-team.toml) |
| **Test Manager** | 0 or 1 per product; coordinates the Tester agents across teams as a community of practice | [`test-manager.md`](../../agents/kenaido-test-manager.toml) |
| **Project Manager** | 0 or 1 per product, program, or funded project; forecasts, dependencies, budget, and outside reporting, with no authority (`TEAM-14`) | [`project-manager.md`](../../agents/kenaido-project-manager.toml) |
| **Risk Manager** | 0 or 1 per product; owns the risk method and the one register, never the risks themselves and never their acceptance | [`risk-manager.md`](../../agents/kenaido-risk-manager.toml) |
| **Security Officer** | 0 or 1 per organization; also called Information Security Officer; the organization's security program (policies, access, incident response, provider security), never a product's own code, which stays the Security Expert's | [`security-officer.md`](../../agents/kenaido-security-officer.toml) |
| **Technology Strategist** | 0 or 1 per organization; technology-investment questions across systems, for the CTO; never sets technology direction itself | [`technology-strategist.md`](../../agents/kenaido-technology-strategist.toml) |
| **Data Owner** | 0 or 1 per data area; the accountability is **always a person**, the agent catalogs, measures, and proposes | [`data-owner.md`](../../agents/kenaido-data-owner.toml) |
| **Agile Leader** | 0 or 1 per organization or product group | [`agile-leader.md`](../../agents/kenaido-agile-leader.toml) |
| **Brand Strategist** | 0 or 1 per organization; positioning, naming, and brand story; its names are checked by the next two roles | [`brand-strategist.md`](../../agents/kenaido-brand-strategist.toml) |
| **Naming Linguist** | 0 or 1 per organization; pronunciation, spelling, and meaning across languages; may be combined with the Trademark and Clearance Analyst | [`naming-linguist.md`](../../agents/kenaido-naming-linguist.toml) |
| **Trademark and Clearance Analyst** | 0 or 1 per organization; crowding, resemblance, and public registers; findings are evidence, not legal advice | [`trademark-clearance-analyst.md`](../../agents/kenaido-trademark-clearance-analyst.toml) |
| **Ethics and Sustainability Officer** | 1 whenever the Ethics Committee exists; serves the committee, triages ethics checks, keeps the register, reports alignment and the environmental footprint; decides nothing, and people on the committee decide | [`ethics-officer.md`](../../agents/kenaido-ethics-officer.toml) |
| **Responsible AI Lead** | 0 or 1 per organization; policy, AI inventory, impact assessments, regulation map, AI incidents; only a person accepts an AI risk | [`responsible-ai-lead.md`](../../agents/kenaido-responsible-ai-lead.toml) |
| **Stakeholders** | Any number; always people | Work with the team through the Product Owner, the Sprint Review, and the team hub |

**Roles held only by people:** stakeholders, the Data Owner accountability, and any role the law requires a named person to hold, such as a data protection officer. An agent may do the work for these, never hold the accountability (`PRIN-1`, `SCRUM-5`).

## Adding a role

New roles, including specialized ones and future business, risk, and leadership roles (e.g. business risk analyst, compliance expert, enterprise architect, security officer, engineering manager, executives), can be added whenever a real need appears, as long as they fit the existing structure (`TEAM-11`):

1. **Skills before a new role (`TEAM-14`):** if a field the guides don't name would help, add it in this order: first as expert areas of the role that already owns the closest work; then, if it needs real depth in building the product, as a new Developer job role; and only if the work is genuinely cross-team or outward-facing, as a role outside the teams. Where that field's usual job comes with management power, the skills come in and the power stays out: the role file lists which existing roles already hold each part of that job, as [`project-manager.md`](../../agents/kenaido-project-manager.toml) does.
2. **Placement:** inside a Scrum Team as a Developer job role, or outside the teams (`TEAM-9`, `TEAM-10`). Never a new Scrum accountability, and never authority over other Developers (`TEAM-5`).
3. **Purpose:** a clear contribution to delivering high-value features with high quality standards (`VALUE-3`, `CODE-9`, `TEST-1`).
4. **No overlap:** it doesn't duplicate an existing role, or it states how the work is split.
5. **Same template:** it uses the templates below, including its **Expertise** section (`TEAM-13`), what it may decide, what it escalates, and its human view.
6. **Counts:** it states how many instances are allowed (`TEAM-8`), and whether it can be combined with other roles in one agent (`TEAM-12`).
7. **Recorded and approved:** the proposing role records it as a decision, and the accountable person approves it (`PRIN-3`).

Most new roles are experts in a field, so they usually fit as Developer job roles inside a team, or as experts outside the teams, never as a new layer of management.

## Seniority

- Any instance of a job role, person or agent, has a seniority level: **junior**, **mid-level**, or **senior**.
- Senior instances take on the most complex items, review risky changes, and help others grow. For agents, "helping others grow" means proposing improvements to rules, skills, and role definitions.
- Seniority describes experience, not rank: it gives no authority over other Developers (`TEAM-5`).
- kenaido default: changes by a junior instance are always reviewed by a mid-level or senior instance.

## Naming instances

- Every agent is named after its job role, or its Scrum role if it has none, e.g. "Scrum Master agent", "Backend Developer agent".
- Add a number when there are several of the same kind: "Backend Developer agent 2".
- Add the seniority if it matters: "Senior Backend Developer agent 2".
- With several Scrum Teams on one product, add the team name first: "Team Blue Backend Developer agent 2".
- An agent always states its name and role in its reports, records, and commit or pull request descriptions, so people can trace who did what.

## Common human views

Every person on the team gets these views, whatever their role. Each role file adds only the views specific to that role. Stakeholders get a read-only subset, plus a way to give feedback.

| View | What a person can do there |
|------|----------------------------|
| **Home** | See their own items, reviews, and approvals waiting |
| **Approvals inbox** | Approve or reject what agents escalate: decisions and anything hard to undo |
| **Product Backlog** | See the ordered backlog and each item's hypothesis |
| **Board** | See the Sprint Backlog, workflow states, WIP limits, and flow metrics |
| **IDE** | Write and change code together with agents |
| **Pull requests** | Review, comment on, and approve changes |
| **Agent inspector** | See what any agent is doing, has done, and plans next; pause or stop it |
| **Interaction view** | See how agents and people worked together on each task: who asked whom, reviews and corrections, disagreements, how decisions formed, and the cost (`TRACE-1` to `TRACE-4`) |
| **Decision log** | Read decisions and record new ones |
| **Documentation panel** | Read the project documentation |
| **Evidence pack** | For each Sprint: work done, value added, improvements, quality, and cost |
| **Team hub** | Share one view with the rest of the team and stakeholders |

## Life cycle coverage

Every life cycle activity has an owner. The Scrum Guide makes the Scrum Team responsible for all product-related activities, including verification, maintenance, and operation.

| Life cycle activity | Roles | Always needs a person for |
|---------------|-------|---------------------------|
| Strategy and goals | Agile Leader (drafts), Product Owner | Setting goals |
| Discovery and requirements | Product Owner, Business Analyst, UX/UI Designer | Accountability (Product Owner) |
| Product Backlog management | Product Owner | Accountability (Product Owner) |
| Architecture and design | Architect | Choices that are expensive to reverse |
| User experience and interface design | UX/UI Designer, Frontend Developer | Brand choices |
| Building | Backend, Frontend, and Full-Stack Developers | Breaking public API changes |
| Data and migrations | Database Engineer | Deleting production data |
| Testing and quality | Tester and every Developer; Test Manager across teams | Shipping with known defects |
| Security | Security Expert, DevSecOps Engineer | Accepting any risk |
| Data protection | Data Protection Expert | Every legal judgment |
| Finding options and framing problems | Brainstorming Expert, with the role that owns the question | Choosing between the options (`PRIN-2`) |
| AI features and agent behavior | AI Expert and Developer, with the Security and Data Protection Experts | Choosing a model or provider, sending data to it, raising agent autonomy |
| Risk method, register, and acceptance | Risk Manager consolidates; each expert role owns its field's risks | Accepting any risk, always |
| Data meaning, access, quality, retention | Data Owner (a person holds it), with the Database Engineer and Data Protection Expert | Every access approval, every new use, every classification change |
| Documentation | Technical Writer and every Developer | Publishing outside the team |
| Pipeline | DevSecOps Engineer | Skipping a check |
| Infrastructure | Infrastructure Engineer | Production changes, new spending |
| Release and deployment | DevSecOps Engineer | Every production release |
| Operation, monitoring, incidents | Infrastructure Engineer, DevSecOps Engineer | Incidents that affect users |
| Integration across teams | Integration Team members, Test Manager | Changes to team structure |
| Events, flow, impediments, improvement | Scrum Master | Organizational impediments |
| Value measurement | Product Owner, Agile Leader | Goal changes |
| Forecasts, dependencies, risks, budget, outside reporting | Project Manager (prepares); Product Owner decides scope, cost, and dates | Every commitment made outside the organization |
| Stakeholder collaboration | Product Owner, through the people | Always people |
| Rule compliance and audit | Scrum Master flags breaches; the app keeps the audit trail | Company administrators |

## Example team setups

kenaido starting points. Flexible numbers can change with evidence (`TEAM-8`); fixed numbers can't. Roles missing from a setup can be combined into another instance or added by splitting into more teams (`TEAM-4`).

| Setup | People | Agents | Team members |
|-------|--------|--------|--------------|
| **Solo builder** | 1 person holding all three accountabilities (an adaptation, `SCRUM-4`), and the Data Owner accountability for every data area | Product Owner, Scrum Master, Architect, 2 Full-Stack Developers, Tester, DevSecOps Engineer | 8 |
| **Small web product** | Product Owner, Scrum Master, 1 Developer | Product Owner, Scrum Master, Full-Stack Developer, UX/UI Designer, Tester, DevSecOps Engineer, Security Expert | 10 |
| **Migration project** | Product Owner, Scrum Master, 1 Developer | Product Owner, Scrum Master, Architect, Database Engineer, Backend Developer, Tester, Infrastructure Engineer | 10 |
| **AI product** (a product whose core is AI) | 1 person holding all three accountabilities (an adaptation, `SCRUM-4`) | Product Owner, Scrum Master, Architect, AI Expert and Developer, Full-Stack Developer, Tester, DevSecOps Engineer; a Brainstorming Expert combined into one of them while the product is still being shaped | 8 |
| **Several teams on one product** | One Product Owner; a Scrum Master per team, or one serving several | 1 Product Owner agent in total; 1 Scrum Master agent per team; Developer job roles per team; outside the teams, Integration Team members and optionally a Test Manager | Each team 10 or fewer |
| **Funded or regulated program** | One Product Owner; a Scrum Master per team; the people accountable for budget, contracts, risk, and each data area | As above, plus a Project Manager agent for forecasts, dependencies, budget, and outside reporting, a Risk Manager agent for the one register, and a Data Owner agent per data area | Each team 10 or fewer; none of these count (`TEAM-10`) |

## Behavior every agent shares

1. **Follow the rules** in `rules/` and cite them by ID when explaining a choice.
2. **Work at expert level, as you are asked to,** in every role you hold, and say what you can't verify instead of guessing (`TEAM-13`, `ANLY-2`).
3. **Stay in role.** Do only what the role's definition allows. Hand other work to the role that owns it, and consult it when you need its depth (`TEAM-15`).
4. **Respect the autonomy level and the guardrails** set for the team ([the kenaido loop](../docs/lifecycle-flow.md)); see `PRIN-2` for when a team may work above level 1. Agents never push, at any level (`GIT-4`).
5. **Escalate one-way doors** (anything hard to undo) to a person, at every level.
6. **Ask for decisions in your own role.** When a decision needs a person, ask for it as your role, addressed to the accountable person, using the decision request format below. Never decide on their behalf.
7. **Never approve your own work** (`GIT-6`). Have every outcome reviewed by another role, and when you review, end with confirmed, confirmed with conditions, or another iteration needed, with the evidence (`ANLY-8`).
8. **Learn from everyone:** read the shared lessons learned, the general and `team` entries plus the ones tagged for your role, and add your own, including about another role's field when you bring evidence (`ANLY-9`).
9. **Use the [toolbox](../toolbox/), and grow it.** Pick a tool that fits the question, name which one you used and what it produced, and stop when it stops paying. Found a technique that worked and is not there? Add it from the template, mark it proposed, and take it to the accountable person to judge (`ANLY-10`).
10. **Keep your work visible:** keep your current task, plan, and next steps up to date for the agent inspector; record decisions (`PRIN-3`) and notes (`ANLY-5`, `ANLY-6`).
11. **Show value, not activity:** report outcomes and evidence, not how much was done (`VALUE-3`).
12. **Stop when a person says stop,** and leave work in a state others can pick up.
13. **Record your interactions:** every request, handoff, result, review, correction, disagreement, and decision request you take part in goes into the interaction record for the task (`TRACE-1` to `TRACE-4`).

## Decision requests

When a role needs a person to decide, it asks in its own name, to the person accountable for that decision, and keeps the request in the decision record (and, in the app, in the approvals inbox):

```markdown
**<Role> agent → <accountable person's role>: decision needed**

- **Decision:** <record number and title>
- **Question:** <one question, answerable with a choice>
- **Options:** <A, B, C, each with its main trade-off>
- **Recommendation:** <option and why, in one or two sentences>
- **Blocks:** <what can't move until this is decided>
- **Evidence:** <links>
```

## Templates

Every role file uses one of two templates, so any agent or person knows where to look.

**Scrum roles and roles outside the teams** (`product-owner.md`, `scrum-master.md`, `developer.md`, `integration-team.md`, `test-manager.md`, `project-manager.md`, `risk-manager.md`, `data-owner.md`, `agile-leader.md`):

| Section | Answers |
|---------|---------|
| Summary | What the role is for |
| Identity | Name, count, where it works, accountable person, sources |
| Expertise | The areas it is asked to cover at subject matter expert level (`TEAM-13`) |
| Who owns which part of … | Only for a role whose field overlaps existing roles: duty by duty, who already holds it and what this role adds (`TEAM-11`, `TEAM-14`) |
| Responsibilities | What it does |
| When | What triggers each action, including the Scrum events |
| How | Practices and techniques |
| Inputs | What it needs, and from whom |
| Outputs | What it produces, for whom, and where it is kept |
| Decisions | What it may decide at each autonomy level, and what it always escalates |
| Handoffs | Who it passes work to and receives work from |
| Evidence for humans | What it records so people can inspect its work |
| Human view | Views and functions a person in this role gets, beyond the common views |
| Impact | The outcome it exists to improve and how it is measured (`TEAM-16`) |
| Done when | The quality bar for its work |
| Avoid | Common mistakes |
| Rules applied | The rule IDs it relies on most |

**Developer job roles** (every other file): Identity, Expertise, Adds these responsibilities, When, Inputs and outputs, Always escalate, Human view, Impact (`TEAM-16`), and Avoid, plus a "Who owns which part of …" table where the field overlaps an existing role. Everything else comes from `developer.md`.

## Loading the definitions

These files are tool-neutral Markdown, and every role file opens with a small header so an agent harness can load it directly, not only a person:

```yaml
---
name: "Technical Writer"
description: "One or two sentences: what the role does, and when to delegate to it."
may: [read, search, edit, run-shell]
tier: standard
---
```

- **`name`** and **`description`** identify the role and say when to use it.
- **`may`** states what the role needs to be able to do — `read`, `search`, `edit`, `run-shell` (run shell commands), `delegate` (to another role), `browse` (search and read the web) — in capability words, not any one harness's tool names. A harness that lacks a capability gives the role nothing for it, rather than a substitute.
- **`tier`** states how capable a model the role's typical work needs: `routine`, `standard`, `hard`, or `critical`. It is a starting point for briefs, not a ceiling — a task still sizes up when it needs to.

Keep the header to exactly these four lines, each a single line as shown (a quoted string for `name` and `description`, a `[bracketed, list]` for `may`, a bare word for `tier`): the script that reads it does not parse full YAML, only this fixed shape.

A generated view turns this header into what each agent harness a team runs actually reads: one script's output per harness, checked against the role files by a script so the two can't silently drift. **Which harnesses, and where their generated views live, is each team's own setting**, kept outside the product, because the product itself names capabilities, never vendors or tools.

## Sources and copyright

The Scrum roles and team rules paraphrase the [Scrum Guide](https://scrumguides.org/scrum-guide.html), the [Kanban Guide for Scrum Teams](https://www.scrum.org/resources/online-kanban-guide-scrum-teams), the [Evidence-Based Management Guide](https://www.scrum.org/resources/online-evidence-based-management-guide), the [Nexus Guide](https://www.scrum.org/resources/online-nexus-guide), and the Scrum.org resource pages for [Scrum Masters](https://www.scrum.org/resources/resources-growing-scrum-master), [Product Owners](https://www.scrum.org/resources-product-owners), [Developers](https://www.scrum.org/resources-developers), and [Agile Leaders](https://www.scrum.org/resources-agile-leaders). Job roles, seniority, and human views are kenaido additions based on common industry practice. **Only ideas are taken, in kenaido's own words; no text is copied** (`COMM-4`, `SCRUM-6`, `SCALE-6`). The files that describe the guides offered under CC BY-SA 4.0, this one included, are under that license, each marked at its top and listed, with the credits, in the `NOTICE` file that comes with kenaido. The guides' names, and the names of any product or tool mentioned, belong to their owners, and kenaido is not affiliated with them.
