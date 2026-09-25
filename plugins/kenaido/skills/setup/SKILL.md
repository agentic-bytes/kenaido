---
name: setup
description: Install or update kenaido's rules in this project, in .claude/rules/kenaido/, so Claude Code loads them in every session. Run it when the user types /kenaido:setup.
disable-model-invocation: true
---

# Set up kenaido in this project

## 1. Check the branch first

Run this command with the Bash tool, exactly as written:

```bash
git branch --show-current
```

**If it prints `main` or `master`,** do not run the setup command below: kenaido's guardrail refuses changes on that branch (`GIT-1`), so it would refuse the setup too. Instead, run this command with the Bash tool, exactly as written:

```bash
git remote -v
```

Then show the user one of the two texts below, exactly as written, with `main` replaced by the branch the first command printed, and nothing else. Then stop.

If `git remote -v` printed a line that starts with `origin`:

<!-- kenaido-setup-on-main: with origin -->
```text
kenaido setup did not run: 'main' is checked out, and kenaido never changes main (GIT-1), so nothing was installed.
Make a work branch first, then type /kenaido:setup again. Type these two commands in a terminal in this project, or ask me to run them and then run setup again — asking me covers both steps:
  git fetch origin
  git switch --no-track -c chore/kenaido-setup origin/main
```

Otherwise (no `origin`, as in a new project):

<!-- kenaido-setup-on-main: no origin -->
```text
kenaido setup did not run: 'main' is checked out, and kenaido never changes main (GIT-1), so nothing was installed.
Make a work branch first, then type /kenaido:setup again. This project has no origin, so make the branch from your local main. Type this command in a terminal in this project, or ask me to run it and then run setup again — asking me covers both steps:
  git switch -c chore/kenaido-setup
```

**If it prints any other branch, or nothing, or says this is not a git repository,** go on to step 2.

## 2. Run the setup

Run this command with the Bash tool, exactly as written, then show the user its output and nothing else:

```bash
sh "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh" "${CLAUDE_PROJECT_DIR}"
```

What it does:
- It copies kenaido's rule files into `.claude/rules/kenaido/` in this project. Claude Code loads every file there at the start of each session.
- Running it again after a plugin update refreshes the rules.
- It changes nothing else in the project.

To remove kenaido's rules, delete the `.claude/rules/kenaido/` folder.
