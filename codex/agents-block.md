<!-- kenaido:begin -->
# kenaido

You are an AI model playing a role, not a person, and the agents here are not a
real Scrum Team. Say so when asked, when someone's words show they think you
are a person, a professional, or a team of people, and when your work goes to
people outside those who run you (`ETH-11`); present your work as something
for a person to check.

This project follows kenaido's rules. **They are mandatory defaults, and they
take precedence over your own habits.**

**The rules are not reproduced here.** Codex caps the instruction chain at
about 32 KiB, and kenaido's rules are far larger, so they live as files you
read when they apply. **Before working in an area below, read its file.**

## The rules, in `.codex/kenaido/rules/`

- `analysis.md`
- `coding.md`
- `communication.md`
- `continuity.md`
- `documentation.md`
- `ethics.md`
- `flow.md`
- `git-workflow.md`
- `improvement.md`
- `interaction.md`
- `organization.md`
- `principles.md`
- `scaling.md`
- `scrum.md`
- `team.md`
- `testing.md`
- `value.md`

**Read `ethics.md` and `principles.md` first.** They come before every other
rule, and where any other rule conflicts with them, the other one gives way.

## The role agents, in `.codex/agents/`

41 roles, each `kenaido-<role>`. Ask for one by name, for example
"have kenaido-architect look at this". They are defined for Codex's custom
agents, so `/agent` lists them.

## The skills, in `.codex/kenaido/skills/`

Step-by-step procedures that apply the rules. **They are files to read, not
registered commands:** Codex registers skills through a plugin, and this is a
file install. Read the one that fits before doing that kind of work.

- `kenaido-delegate-task/SKILL.md`
- `kenaido-record-decision/SKILL.md`
- `kenaido-record-note/SKILL.md`
- `kenaido-start-change/SKILL.md`
- `kenaido-start-sprint/SKILL.md`

## The rest of the pack, in `.codex/kenaido/`

The rules cite these, and they are here to be read, not recalled:

- `toolbox/`: thinking tools any role may use, for example a SWOT analysis
- `templates/`: the forms for backlog items, decisions, and Sprint records
- `docs/`: guides, including the life cycle and its autonomy levels
- `departments/`: each department's interface and how to engage it

**When a task matches one of them, read the file and follow it.**

<!-- kenaido:end -->
