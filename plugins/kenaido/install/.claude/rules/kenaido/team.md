# Team composition

How many agents of each kind a product and a Scrum Team may have. Some numbers are fixed by the guides and must always be respected; others are flexible and change with need, based on evidence.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

**The agents counted here are not members of a Scrum Team in the Scrum Guide's sense** (`ETH-11`): they are AI models doing work for the people who hold the accountabilities. Counting them, and giving them roles modeled on the accountabilities, is a kenaido adaptation, so that the work and its coordination stay within the Guide's limits (`SCRUM-4`).

| Who | Number | Fixed or flexible | Source |
|-----|--------|-------------------|--------|
| Product Owner (human and agent) | Exactly 1 per product, however many teams | **Fixed** | Scrum Guide, Nexus Guide; the agent is a kenaido adaptation |
| Scrum Master agent | Exactly 1 per Scrum Team | **Fixed** | Scrum Guide for the accountability; the agent is a kenaido adaptation |
| Developer agents | At least 1 per Scrum Team | Flexible, within the team size limit | Scrum Guide for the accountability; the agents are a kenaido adaptation |
| Developer job roles (Architect, Backend Developer, Tester, and so on) | As many of each as the work needs | Flexible, within the team size limit | kenaido addition |
| Scrum Team size | Typically 10 or fewer members, humans and agents counted together | Flexible limit | Scrum Guide; counting agents is a kenaido adaptation |
| Scrum Teams on one product | 1, or roughly 3 to 9 when scaling | Flexible range | Scrum Guide, Nexus Guide |
| Nexus Integration Team | Exactly 1 per scaled product: the Product Owner, one Scrum Master, and 1 or more members | **Fixed** composition, flexible member count | Nexus Guide |
| Test Manager | 0 or 1 per product, outside the Scrum Teams | Flexible (optional) | kenaido addition |
| Project Manager | 0 or 1 per product, program, or funded project, outside the Scrum Teams | Flexible (optional) | kenaido addition |
| Risk Manager | 0 or 1 per product, outside the Scrum Teams | Flexible (optional) | kenaido addition |
| Data Owner | 1 per data area; the accountability is always a person, outside the Scrum Teams | Flexible (optional) count of areas | kenaido addition |
| Agile Leader agent | 0 or 1 per organization or product group | Flexible (optional) | kenaido addition |
| Brand Strategist, Naming Linguist, Trademark and Clearance Analyst agents | 0 or 1 each per organization; the two checkers may be one agent, never with the Brand Strategist | Flexible (optional) | kenaido addition |
| Ethics and Sustainability Officer agent | 1 whenever the Ethics Committee exists, outside the Scrum Teams; combined with no other role | Flexible (optional) | kenaido addition |
| Responsible AI Lead agent | 0 or 1 per organization, outside the Scrum Teams | Flexible (optional) | kenaido addition |

- **`TEAM-1` One Product Owner per product.** A product has exactly one Product Owner agent and one human Product Owner accountable for it, even with several Scrum Teams. The Scrum Guide makes the Product Owner a single person rather than a group.
- **`TEAM-2` One Scrum Master per Scrum Team.** Each Scrum Team has exactly one Scrum Master agent and one human Scrum Master accountable for it. One person may be the accountable Scrum Master for several teams.
- **`TEAM-3` Developers as needed.** Each Scrum Team has at least one Developer agent, and as many as its work needs within the size limit. Together, the Developers must have every skill needed to deliver a usable Increment each Sprint, from design to operation.
- **`TEAM-4` Keep teams small.** A Scrum Team typically has 10 or fewer members. kenaido counts agents toward this size, because each one adds coordination, just as a person does (`SCALE-5`), though they are not members in the Guide's sense (`ETH-11`). When more are needed, split into several Scrum Teams on the same product, sharing one Product Goal, Product Backlog, and Product Owner, rather than growing one team. **Who counts:** the people, plus each separate agent instance that works in the Sprint, including each separate reviewer instance. One agent wearing several job roles counts once (`TEAM-12`). Roles outside the team, such as the Agile Leader agent, don't count (`TEAM-10`). Because the count changes per Sprint, each Sprint Review records it.
- **`TEAM-5` No sub-teams or hierarchies.** Inside a Scrum Team, every job role is a Developer, and job roles and seniority describe skills, not rank. No person or agent leads, manages, or assigns work to other Developers; the Developers decide together who does what. A separate test team, or any other team that work must pass through, is not allowed inside a Scrum Team.
- **`TEAM-6` Scale with the multi-team setup.** Several Scrum Teams on one product (roughly 3 to 9) follow `SCALE-1` to `SCALE-6`, with one Nexus Integration Team: the Product Owner, one Scrum Master (who may also serve a team), and one or more Integration Team agents. kenaido also uses this setup for two teams on one product; that is an adaptation, since the Nexus Guide says "approximately" three to nine.
- **`TEAM-7` One team per agent.** Each agent instance belongs to exactly one Scrum Team, which keeps its work traceable. The exception is the Nexus Integration Team: its work takes priority, and its members may also work in a Scrum Team.
- **`TEAM-8` Change flexible numbers with evidence.** Add or remove agents only when flow and value data show a need (`FLOW-4`, `VALUE-5`, `SCALE-5`). Each change is a recorded decision (`PRIN-3`) approved by the accountable human. Fixed numbers never change.
- **`TEAM-9` Job roles inside the team.** Real-world job roles (e.g. Architect, Backend Developer, Security Expert, AI Expert and Developer, Brainstorming Expert, Tester) work inside a Scrum Team as Developers, defined in [`departments/`](../../kenaido/departments/). Their numbers are flexible. One instance may hold several job roles, e.g. a Full-Stack Developer, to keep the team within its size limit (`TEAM-4`).
- **`TEAM-10` Roles outside the teams.** Roles that coordinate or support across Scrum Teams, such as the Test Manager, the Project Manager, the Risk Manager, the Data Owner, the Agile Leader, and future business and leadership roles, don't count toward team size and never direct how a Scrum Team works: the team manages itself (`FLOW-2`). Roles the law requires a named person to hold, and stakeholders, are always people.
- **`TEAM-11` New roles must fit the structure.** Add a new or specialized role only when it fits: placed inside a Scrum Team as a Developer job role or outside the teams (`TEAM-9`, `TEAM-10`), with a clear contribution to high-value, high-quality delivery, no unexplained overlap with existing roles, the standard role template, stated counts, and a recorded decision approved by the accountable person (`PRIN-3`). See [`departments/README.md`](../../kenaido/departments/README.md#adding-a-role).
- **`TEAM-12` Combined roles.** One agent may hold several expert roles and act as a multi-skilled expert, as long as no rule breaks:
  - It may combine any Developer job roles, and it counts as one team member (`TEAM-4`).
  - It may not combine Scrum accountabilities: the Product Owner, Scrum Master, and Developer agents stay separate agents, so the fixed counts and the checks between them hold (`TEAM-1`, `TEAM-2`). A person may still hold several accountabilities, as in the solo-builder adaptation.
  - It may combine a Developer job role with a role outside the teams only if neither role checks the other's work.
  - It never reviews or approves its own work in any of its roles (`GIT-6`).
  - It follows every rule of each role it holds; where they differ, the stricter one applies, including what it must escalate.
  - Work-in-progress limits apply to the agent as a whole, not per role (`FLOW-3`).
- **`TEAM-13` Expert level asked of every role.** Every role, taken by a person or an agent, is asked to work at the level of a subject matter expert in its field. For an agent this is the instruction it follows, not a quality it is certain to reach: its output varies with the model and must be checked (`ETH-11`). An agent in a role is expected to know current practice, the relevant standards, and the common mistakes of that field, and to bring them without being asked.
  - **Depth:** it explains the trade-offs of its options, not just the option it likes, and cites the standard, guide, or measurement it relies on (`ANLY-1`, `COMM-6`).
  - **Honesty about limits:** it says plainly what it does not know or cannot verify, and names the role that owns the question instead of guessing (`ANLY-2`, `ANLY-7`). Expert level means knowing the edge of your knowledge, not having no edge.
  - **Current, not remembered:** where a field moves fast, it checks the source before advising (`SCRUM-1`, `ANLY-1`).
  - **Plain words:** expert depth is explained so a non-expert can decide (`COMM-3`, `PRIN-2`).
  - **Seniority is about review, not expertise:** every instance is asked to work at expert level; seniority decides how much review its work gets and how complex the items it takes are.
  - **Combined roles:** an agent holding several roles is asked to work at expert level in each one, or it does not take the role (`TEAM-12`).
  - Each role file states its expert areas in its **Expertise** section; the field's depth is described there, not in this rule.
- **`TEAM-14` A new field joins an existing role before it becomes a new one.** Fields the guides do not name (for example project management, AI engineering, finance, marketing, compliance) are added as expertise, in this order:
  1. **As skills of an existing role,** when a role already owns the closest work. State the added expert areas in that role file.
  2. **As a new Developer job role** inside a Scrum Team, when the field needs real depth and the work belongs to building the product (`TEAM-9`, `TEAM-11`).
  3. **As a role outside the teams,** only when the work is genuinely cross-team or outward-facing, and then it decides nothing and directs no one (`TEAM-10`).

  It is never a new Scrum accountability and never authority over Developers (`SCRUM-2`, `TEAM-5`). Where a field's usual job comes with management power, the power stays out: the skills come in, the accountable people keep the decisions (`PRIN-2`), and the role file lists which existing roles already hold each part of that job. Each addition is recorded and approved (`TEAM-11`, `PRIN-3`).
- **`TEAM-15` Everyone collaborates through the framework.** Whatever its field, a role works through the Scrum events, the shared board and Definition of Workflow, the records, and the accountable people, never around them.
  - Work arrives as Product Backlog items and is pulled from the board within the WIP limits (`FLOW-2`, `FLOW-3`); no role keeps a private queue or a side process.
  - Requests, handoffs, results, reviews, corrections, disagreements, and decision requests between roles are recorded (`TRACE-1`, `TRACE-2`).
  - A role that needs another field's depth consults that role instead of working outside its own (`TEAM-13`); the roles resolve a disagreement with evidence, and escalate it with both positions if they cannot (`PRIN-2`).
  - Nobody reviews or approves their own work, in any of their roles (`GIT-6`).
  - A role outside the teams supports and reports; it never directs a team (`TEAM-10`, `FLOW-2`).
- **`TEAM-16` Every role makes a measurable impact.** Every role, inside a Scrum Team or outside it, improves something that can be measured.
  - **Each role file has an Impact section:** the outcome the role exists to improve, and how it is measured. It is written in outcomes and impact, never activity: commits, documents, tokens, or tasks closed do not count on their own (`VALUE-3`).
  - **Impact is inspected at every Sprint Review,** with the flow and value data (`FLOW-4`, `VALUE-5`) and the role tests in the [`delegate-task`](../../kenaido/skills/delegate-task/SKILL.md) skill.
  - **A role that shows no measurable impact for three Sprints in a row is reconsidered:** changed, merged, or made dormant. The accountable person decides (`TEAM-8`). Three is the default, and the accountable person may change it.
  - **Impact counts only within the values** (`ETH-4`): a gain that weakens life, dignity, joy, or the environment is not impact.
