# Default rules

kenaido's default rules: the life cycle's best practices that everyone follows, people and agents alike. How each agent role behaves is defined separately, in [`departments/`](../departments/). The rules apply to every project built with kenaido, including kenaido itself, and take precedence over an agent's default behavior. Teams can change some of them; a core set will stay locked, and which ones is still open. More rules will be added over time; each one applies whenever its scenario matches the task at hand.

> **License of this file:** CC BY-SA 4.0 ([legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode)), not Apache-2.0 like most of kenaido. It describes, in kenaido's own words and with changes and additions, content from one or more of the guides listed in the `NOTICE` file that comes with kenaido, which are offered under the same license. The credits are in that file.

## Rules, practices, and the toolbox

Three kinds of guidance, which differ in how binding they are. They map to the layers of the [vital, essential, extra](../toolbox/vital-essential-extra.md) tool:

| Layer | What it is | How binding | Where | Examples |
|-------|-----------|-------------|-------|----------|
| **Rules** (vital) | What everyone must do, including the frameworks we follow in full | **Must.** Breaking one is a defect | This folder | Scrum, Kanban for Scrum Teams, Evidence-Based Management, the multi-team scaling guide, `ETH`, `CODE`, `GIT` |
| **Practices** (essential) | Recognized ways to do a department's work well, from industry sources checked at the source | **Should.** Chosen by the department's experts (`ORG-13`) | `departments/<department>/practices.md` | Secure coding guidelines, search engine guidelines, accounting standards |
| **Toolbox** (extra) | Thinking techniques anyone may pick up | **May.** Never required (`ANLY-10`) | [`toolbox/`](../toolbox/) | SWOT, the question set, divide and conquer |

**Frameworks stay rules:** Scrum only works in its entirety (`SCRUM-3`), and the multi-team framework is likewise meant to be used whole, so calling them practices would suggest they are optional. **The toolbox stays separate from practices,** so "may" and "should" never blur. **Rules stay the locked core** that `CODE-10` requires.

## Files

| File | ID prefix | Covers |
|------|-----------|--------|
| [`ethics.md`](../../rules/kenaido/ethics.md) | `ETH` | **Comes first.** Why we exist (serving humans), our values (the sacredness of human life, human dignity, the joy of human life, and the environment they depend on), the ethics check in every decision, and the Ethics Committee |
| [`principles.md`](../../rules/kenaido/principles.md) | `PRIN` | Accountability, who decides, transparency, and using every tool within the law, its license, and its terms |
| [`git-workflow.md`](../../rules/kenaido/git-workflow.md) | `GIT`, `NAME`, `VER` | Branches, commits, pushes, pull requests, naming; how a release's version number is chosen |
| [`communication.md`](../../rules/kenaido/communication.md) | `COMM` | How all text is written |
| [`analysis.md`](../../rules/kenaido/analysis.md) | `ANLY` | How investigations, reviews, and plans are done; reviewing every outcome; shared lessons learned; using the toolbox |
| [`coding.md`](../../rules/kenaido/coding.md) | `CODE` | Coding practices and mandatory quality attributes |
| [`testing.md`](../../rules/kenaido/testing.md) | `TEST` | Tests, scans, and pipelines; which tools may be adopted; bill of materials and vulnerability scanning |
| [`documentation.md`](../../rules/kenaido/documentation.md) | `DOC` | What documentation covers and how it's kept current; the product kept separate from the record of how it is built |
| [`scrum.md`](../../rules/kenaido/scrum.md) | `SCRUM` | Alignment with the Scrum Guide, how kenaido labels what it adds, and that all work runs inside Scrum by default |
| [`flow.md`](../../rules/kenaido/flow.md) | `FLOW` | Kanban flow practices and metrics inside Scrum |
| [`value.md`](../../rules/kenaido/value.md) | `VALUE` | Goals, value measures, and experiments (Evidence-Based Management) |
| [`scaling.md`](../../rules/kenaido/scaling.md) | `SCALE` | Several Scrum Teams on one product |
| [`team.md`](../../rules/kenaido/team.md) | `TEAM` | How many agents of each kind; fixed and flexible numbers; expert level, new fields, and how roles collaborate |
| [`organization.md`](../../rules/kenaido/organization.md) | `ORG` | Departments, leadership held by people, and how to engage any role or department |
| [`continuity.md`](../../rules/kenaido/continuity.md) | `CONT` | Resuming work safely after a break or a usage limit; result files, progress blocks, and task state |
| [`interaction.md`](../../rules/kenaido/interaction.md) | `TRACE` | Recording and reviewing how agents and people work together |
| [`improvement.md`](../../rules/kenaido/improvement.md) | `IMPR` | Choosing, trying, and keeping improvements only when evidence shows they help |

## Rule IDs

- **Every rule has a stable ID:** a prefix and a number, e.g. `CODE-7` (SOLID). Sub-items add a letter, e.g. `TEST-1d` (security scans).
- **Reference rules by ID and file** from code comments, documentation, skills, and commit or pull request descriptions, e.g. "see `CODE-7` in `rules/coding.md`". Find every use of a rule with `git grep CODE-7`.
- **IDs never change and are never reused.** Rewording a rule keeps its ID. A removed rule stays in its file, marked **Retired**, so old references still make sense.

## How agents load the rules

- **Claude Code:** `CLAUDE.md` imports every file here, so the rules are always loaded.
- **Other agent tools**, which read `CLAUDE.md` as plain text: read every file listed in `CLAUDE.md` before starting work.
- **Skills** (in `product/skills/`, which Claude Code loads through the `.claude/skills` link) are step-by-step procedures that apply these rules. They reference rules by ID instead of repeating them.
