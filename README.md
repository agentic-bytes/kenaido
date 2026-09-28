# kenaido plugins

kenaido gives your coding agent three things: role agents (Product Owner, Scrum Master, Architect, Tester, Security Expert, and more); default rules for quality and safety, which the agents are asked to follow (see what is enforced below); and step-by-step skills. This repository holds the ready-to-install packages, public and free to read.

> **Warning: what kenaido's agents are, and are not.** kenaido's agents are AI models given role names. **They are not people, and no group of them can ever match a real Scrum Team of people**, because of what they are: statistical models. The same question can get different answers, and the answers change with the model, its version, and its settings. **Scrum, the multi-team framework, and every other framework or practice in kenaido are simulated:** the agents are given, as closely as possible, the same guidance the guides give people in those roles. Following guidance is not the same as a team of people living it. Role names such as Product Owner or Scrum Master follow the guides only so you know what to expect of each agent; kenaido's rules give each accountability to a person. **Each agent acts only on the short, limited instructions in its role definition, which may not cover every part of the role, and it is never a substitute for a professional whose job needs a license.** **These texts, this one included, were drafted by AI models and approved by the project's owner.** **Check everything they produce, and keep people accountable for every decision.** kenaido is provided as is, at your own risk. Read the full disclaimer, `DISCLAIMER.md`, which comes with every package.

**What kenaido is for.** kenaido helps a team run its software work with coding agents inside a simulated Scrum life cycle, with people deciding. **Not for high-risk uses:** decisions about people's jobs, credit, health, safety, or access to essential services.

**Install instructions for your coding agent:**

<!-- tools:begin -->
- [Claude Code](#claude-code)
- [GitHub Copilot](#github-copilot)
- [Codex](#codex)
- [Antigravity](#antigravity)
- [pi](#pi)
<!-- tools:end -->

**See it in use:** the [showcase](showcase/README.md) has screenshots of kenaido in use, with short captions.

## Which case am I?

Before step 1 in your tool's section above, check these:

| Question | How to tell | Where it matters |
|----------|--------------|-------------------|
| **Which coding agent tool?** | Claude Code, GitHub Copilot, Codex, Antigravity, or pi | Picks your section, linked above |
| **Which operating system?** | Windows, macOS, Linux, or Windows with a project inside WSL | Each section says what has been tested on it, and labels the rest **not yet tested** — check before you rely on a guardrail |
| **A new project, or an existing one?** | Does the folder already have a `.git`? | A new project usually has no `origin` yet (below); an existing one may also have `main` checked out, which changes what setup does (see each tool's section) |
| **Does your project have a remote (`origin`)?** | Run `git remote -v` in the project; no output means no `origin` | Changes the exact commands a guardrail refusal tells you to run |
| **HTTPS or SSH to reach GitHub?** | Run `git remote -v` (an existing clone) or look at the URL you were given: one starting `git@` or `ssh://` is SSH; one starting `https://` is HTTPS | Decides which access steps to follow below. On one Windows machine tried so far, `ssh -T git@github.com` was refused (`Permission denied (publickey)`) until an SSH key was set up; switching to HTTPS with a fine-grained token then worked |

## Claude Code

**You need:** Claude Code.

### Step 1: this repository is public

No GitHub account, SSH key, or token is needed: this repository is public.

### Step 2: add the marketplace

Type this inside Claude Code:
```
/plugin marketplace add agentic-bytes/kenaido
```
**You should see:** a line starting `Successfully added marketplace: agentic-bytes`.

**If you don't:** the error names what's missing. Fix that and try again.

### Step 3: verify this release

**Verify this release** before installing it, and after every update, in a terminal (`bash`, `git`, `sha256sum`). Find the folder with `claude plugin marketplace list --json` (`installLocation` for `agentic-bytes`); from there, type (on Windows, use Git Bash — your `PATH`'s `bash` may lack `sha256sum`):
```
tail -n +4 RELEASE-MANIFEST | sha256sum -c --quiet && scripts/check-release-manifest.sh
```
**You should see:** a line ending `The release is what kenaido <version> at <commit> produced`.

**If you don't:** stop, and don't install. What this shows and what it doesn't: [How each release is checked](#how-each-release-is-checked). Claude Code copies the plugin from that folder into its own cache, which this step does not check, and may update the marketplace in the background (**Good to know**, below) — check again after an update.

**From `1.0.1` on, also check the release's signed tag** before you install: [Check the release's signed tag](#check-the-releases-signed-tag). It shows that the release is the one kenaido's maintainer signed, which this step alone cannot show.

### Step 4: install the plugin

Type this inside Claude Code:
```
/plugin install kenaido@agentic-bytes
```
**You should see:** a line starting `Successfully installed plugin: kenaido@agentic-bytes`.

**Where this installs kenaido.** The command above installs at **user** scope, with no prompt: kenaido is then available in every project you open. Two other scopes exist ([Claude Code's plugin installation scopes](https://code.claude.com/docs/en/plugins-reference#plugin-installation-scopes)):
- **local** — only you, only in this repository, not shared through version control. **Recommended for a first project:** kenaido stays out of your other projects and your collaborators' setup while you try it. `claude plugin install kenaido@agentic-bytes --scope local`.
- **project** — every collaborator, once your team agrees to use kenaido: `claude plugin install kenaido@agentic-bytes --scope project`.

**A copy synced from your claude.ai account can load beside this install,** with no marketplace and no install record, as `kenaido@synced` ([Claude Code's plugin loading reference](https://code.claude.com/docs/en/plugins/loading), "Plugins synced from claude.ai", read 2026-09-25). `claude plugin list` shows every loaded copy as `<name>@<origin>`. **If both share the name `kenaido`,** this install loads and the synced copy shows as not loaded. **To remove the synced copy:** `claude plugin disable kenaido@synced`, or the matching toggle in the `/plugin` Installed tab.

### Step 5: set up each project

Once, from that project, type:
```
/kenaido:setup
```
**You should see:** a line saying it installed the rule files (for example `installed 17 rule files (version <version>)`), and, among its closing lines, `The rules load at the start of every Claude Code session. Start a new session to use them.`

This copies kenaido's rules into `.claude/rules/kenaido/` in the project, where Claude Code loads them at the start of every session, and the rest of the pack into `.claude/kenaido/`, where nothing loads until an agent reads it. It changes nothing else.

**If instead your project has `main` (or `master`) checked out, this installs nothing.** kenaido never changes `main` (`GIT-1`), setup included, so it refuses and prints one of these two messages, then stops:

With an `origin`:
```text
kenaido setup did not run: 'main' is checked out, and kenaido never changes main (GIT-1), so nothing was installed.
Make a work branch first, then type /kenaido:setup again. Type these two commands in a terminal in this project, or ask me to run them and then run setup again — asking me covers both steps:
  git fetch origin
  git switch --no-track -c chore/kenaido-setup origin/main
```

With no `origin` (a new project with nothing pushed yet):
```text
kenaido setup did not run: 'main' is checked out, and kenaido never changes main (GIT-1), so nothing was installed.
Make a work branch first, then type /kenaido:setup again. This project has no origin, so make the branch from your local main. Type this command in a terminal in this project, or ask me to run it and then run setup again — asking me covers both steps:
  git switch -c chore/kenaido-setup
```

Either way, run the commands it shows (or ask Claude Code to run them for you), then type `/kenaido:setup` again.

### Step 6: start a new Claude Code session before using kenaido

Close this session and open a new one in the project before asking for a role agent or a skill. Setup's own output (step 5, above) says why: the rules load only at the start of a session.

**What you get:**
- the role agents, for example `kenaido:architect` and `kenaido:tester`;
- the skills: `/kenaido:start-change`, `/kenaido:record-decision`, `/kenaido:record-note`, `/kenaido:delegate-task`;
- the rules, once `/kenaido:setup` has run (a short index before that);
- **the whole pack the rules cite** — toolbox, templates, guides, each department's interface — in the plugin, and in `.claude/kenaido/` once set up;
- **one rule enforced, not just stated:** while `main` or `master` is checked out, Claude Code refuses a file edit or a shell command that could change it, and tells you to cut a work branch first (`GIT-1`).

**What it loads into every session** (measured from the 1.0.2 package in characters; tokens are an estimate at 3 to 4 characters per token, not a count):
- **the rules, once `/kenaido:setup` has run:** 17 files, 100,971 characters, about 25,000 to 34,000 tokens, in every session of that project. Before setup, an index of them instead: 6,589 characters, about 1,600 to 2,200 tokens;
- **the 41 role agents' names and descriptions:** 13,836 characters, about 3,500 to 4,600 tokens, and the 6 skills' names and descriptions: 1,435 characters. How much of these Claude Code puts into a session before one is used **has not been observed**.

**Update:** `/plugin marketplace update agentic-bytes`, then run `/kenaido:setup` again in each project to refresh its rules.

**Remove:** `/plugin uninstall kenaido@agentic-bytes`. **Observed, 2026-09-24:** typed in Claude Code's `/plugin` interface, this printed no confirmation. **The command that shows kenaido is gone:** run `claude plugin list` afterward and check that `kenaido@agentic-bytes` no longer appears (if a `kenaido@synced` copy is still there, see [Step 4](#step-4-install-the-plugin) to remove it too). Then delete `.claude/rules/kenaido/` and `.claude/kenaido/` from each project. **Observed after a local-scope uninstall:** Claude Code leaves `.claude/settings.local.json` behind, holding `{"enabledPlugins": {}}`. That file is Claude Code's own, not kenaido's, and it is safe to delete.

**What is enforced, and what is not.** Rules in a file are context: the model reads them and may still act against them. A guardrail refuses the action instead. kenaido ships exactly one so far:

| | |
|---|---|
| **Enforced** | While `main` or `master` is checked out: editing a file through `Edit`, `Write` or `NotebookEdit`, and any command through `Bash`, `PowerShell` or `Monitor` that is not on a short list of commands that cannot change files — `git status`, `log`, `diff`, `show`, `branch`, `rev-parse`, `remote -v`, `fetch`, `switch`, `checkout -b`, `ls`, `cat`, `pwd`, `head`, `tail`, `wc` — each alone, in plain words. Quotes, variables, pipes, redirects and `&&` or `;` are refused, since the guardrail cannot be sure what they do. The refusal says how to cut a work branch |
| **Also enforced** | Every MCP tool call (a tool a connected server provides) while `main` or `master` is checked out, read-only ones too: on `main` the only job is to leave it |
| **Not enforced** | Anything a hook never sees, and **anything while another branch is checked out**: from there, `git branch -f main` or `git update-ref` can move `main` without a commit. Only the [optional git hooks](#optional-git-hooks) stop that |

**Windows:** the plugin ships a POSIX guardrail and a PowerShell one, and Claude Code runs whichever its shell allows. **Observed on native Windows on 2026-09-21** (Claude Code 2.1.278, kenaido 0.8.0, Git Bash present): the guardrail refused a file write and a shell write on `main`, allowed `git status` and `git switch -c`, and allowed edits on a work branch; with the POSIX script removed, **the PowerShell guardrail alone refused both writes**. Not yet observed: Windows without Git Bash.

**You can always overrule it.** The guardrail exists to stop an unattended agent, never to overrule you:
- `/plugin disable kenaido@agentic-bytes` turns the whole plugin off, and `disableAllHooks` in your settings turns off every hook from every source. **Claude Code offers no way to disable one hook on its own,** so turning this guardrail off means turning off the plugin or all hooks;
- every refusal says which rule it is and what to do instead.

**It fails open, and says so.** If the guardrail cannot run (script missing, or git not on your `PATH`), **the edit goes through rather than being blocked** — deliberate, since a guardrail must never break your work — but **not in silence:** a `kenaido warning:` appears at every session start and every guarded edit while the script or git is missing.

**What the warning cannot cover:** a plugin that is gone or turned off warns of nothing. **On Windows without Git Bash,** the session-start check (a POSIX command) does not run; a missing PowerShell script shows Claude Code's own `hook error` instead of kenaido's wording, though a missing git still shows kenaido's warning (not yet run on Windows, as above). Git hooks in your own project remain the floor that refuses a commit whatever wrote it.

**Good to know:**
- **Updates:** if an update does not arrive on its own, update by hand with the command above.
- **Windows: observed in Claude Code.** On native Windows on 2026-09-21, kenaido 0.8.0 refused writes on `main` through the file tool and the shell, and the PowerShell guardrail alone did so when the POSIX one could not run. **Tested on:** Linux, inside WSL, and native Windows. **Not yet tested:** macOS. **Also not yet tested:** native Linux — the Linux test above ran inside WSL, not on Linux without it. The plugin's other scripts still run with `sh`, so on native Windows they need Git Bash.

## GitHub Copilot

**You need:** GitHub Copilot in your IDE, and an SSH key on your GitHub account for the clone below (check "Which case am I?" above; for HTTPS instead, see [Claude Code, step 1](#claude-code)).

### Step 1: clone this repository

Once per project, in a terminal, type:
```
git clone git@github.com:agentic-bytes/kenaido.git
```
**You should see:** `Cloning into 'kenaido'...`, ending without an error.

**If you don't:** an SSH or access error means step 1's setup ("Which case am I?", above) isn't done yet.

### Step 2: verify this release

**Verify this release** before installing it, and after every update, from the clone (`bash`, `git`, `sha256sum`). On Windows, use Git Bash (Git for Windows' `bash.exe`) — your `PATH`'s `bash` may lack `sha256sum`.
```
cd kenaido
tail -n +4 RELEASE-MANIFEST | sha256sum -c --quiet && scripts/check-release-manifest.sh
cd ..
```
**You should see:** a line ending `The release is what kenaido <version> at <commit> produced`.

**If you don't:** stop, and don't install. What this shows, and what it doesn't: [How each release is checked](#how-each-release-is-checked).

**From `1.0.1` on, also check the release's signed tag** before you install: [Check the release's signed tag](#check-the-releases-signed-tag). It shows that the release is the one kenaido's maintainer signed, which this step alone cannot show.

### Step 3: install into your project

```
sh kenaido/copilot/install.sh /path/to/your/project
```
**You should see:** a line starting `kenaido <version>: installed <N> rules, <N> agents, and <N> skills into...`.

**If you don't:** a line starting `kenaido: these files already exist and weren't installed by kenaido` names each conflicting file; nothing was written. Rename or remove those files, then run the command again.

It writes kenaido into the project's `.github/` folder, where Copilot reads it:
- **the rules,** as one marked kenaido block in `.github/copilot-instructions.md`. Anything of yours already in that file stays untouched;
- **the role agents,** in `.github/agents/kenaido/`;
- **the skills,** in `.github/skills/kenaido-*/`;
- **a guardrail,** in `.github/hooks/kenaido-no-main-edit.json`, which refuses an edit while `main` or `master` is checked out;
- **the rules one file each, and the rest of the pack** — the toolbox, the templates, the guides, and each department's interface — **with the `LICENSE`, the `NOTICE`, the `DISCLAIMER.md`, and a list of what it wrote,** in `.github/kenaido/`.

It never overwrites a file of your own: if one is in the way, it stops before writing anything and says which. Commit the files if your team should share them.

**Adding this repository as a Copilot plugin marketplace does not install kenaido.** Copilot may accept the address `agentic-bytes/kenaido` and then install nothing. There is no Copilot plugin here: the `.claude-plugin/marketplace.json` in this repository is **Claude Code's** catalog, and the plugin it lists is built in Claude Code's format. GitHub Copilot CLI reads a marketplace file at that same path ([GitHub's documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)), which is why the address is accepted. We cannot move that file, because Claude Code requires it exactly there.

**Even on a surface that reads marketplaces, that plugin's contents would not load for Copilot.** Its role agents are named `agents/<role>.md`, and Copilot reads `<role>.agent.md`; its hook file is written in Claude Code's schema; and its setup skill installs into `.claude/`, which is the wrong place for a Copilot user. This is a structural mismatch, not a missing field: the marketplace file carries every field GitHub lists as required, which is exactly why it is accepted and then does nothing.

**For Copilot, the route is the file install above.** It is the only one this repository supports, and the only one we test.

**What we checked, and what we could not.** GitHub documents plugins and plugin marketplaces for the **Copilot CLI**, the Copilot cloud agent, and the GitHub Copilot app ([About GitHub Copilot plugins](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-cli-plugins)); it does not name Copilot in an IDE. **Nobody here has run the Copilot CLI**, so we cannot tell you whether it warns you or stays silent when a marketplace holds nothing it can use. If you added this repository as a Copilot marketplace, we have seen nothing installed, and we know of nothing it would change in your project; you can remove it and use the file install instead.

**What you get:**
- the rules, always on;
- **the role agents, in the agents dropdown at the bottom of Copilot Chat** — not under "Configure Agents… → Workspace", which manages an agent's file rather than listing it. **Observed:** the installed `kenaido-*` agents, for example `kenaido-architect`, appeared there on 2026-09-17. To add or edit an agent profile yourself: click **Configure Agents…**, then, under **Chat Agents**, click **Workspace** ([GitHub's current documentation](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-custom-agents-in-your-ide), read 2026-09-21). **Custom agents are in public preview for JetBrains IDEs**, per that page, so this can still change;
- **the skills — not seen anywhere in the JetBrains UI.** `.github/skills/kenaido-*/` is on disk, but the same 2026-09-17 test found no menu that lists them.

**What it loads into every session** (measured from the 1.0.2 package in characters; tokens are an estimate at 3 to 4 characters per token, not a count):
- **the rules, in full, in the kenaido block of `copilot-instructions.md`:** 102,175 characters, about 26,000 to 34,000 tokens, with every request Copilot sends from that project;
- **the 41 role agents' names and descriptions:** 14,164 characters, and the 5 skills': 1,306 characters. Whether Copilot sends these before one is picked **has not been observed**.

**Update:** pull this repository and run the same command again. **Remove:** `sh kenaido/copilot/install.sh --remove /path/to/your/project`. It removes only what it wrote, and takes its block out of `copilot-instructions.md`, leaving your own text as it was.

**Tested in:** Copilot in a JetBrains IDE. **Not yet tested:** Copilot in VS Code.

**What is enforced depends on where you run Copilot.** Copilot supports hooks — a hook can refuse an action before it happens — but [GitHub's documentation](https://docs.github.com/en/copilot/concepts/agents/hooks) lists hooks as available for the Copilot CLI and the Copilot cloud agent only. So:

| Where you run Copilot | The rules | The guardrail |
|---|---|---|
| **CLI**, **cloud agent** | Loaded | **Enforced:** an edit on `main` or `master` is refused, and the refusal says how to cut a work branch. **Observed in the Copilot CLI 1.0.86 on Windows, 2026-09-21, with kenaido 0.7.0** (the matcher fix in #314). **Not yet observed in the Copilot cloud agent** |
| **In an IDE** (JetBrains, VS Code) | Loaded | **Not enforced.** Copilot in an IDE runs no hooks, so nothing in this package can refuse an action there |

**The guardrail refuses only the tools it names.** Copilot's hooks pick the actions they check by tool name. kenaido's guardrail checks `create`, `edit`, `str_replace_editor` and `apply_patch`, the file tools GitHub's hooks reference names. **Before 0.7.0 it checked only `create` and `edit`, so an edit made through `apply_patch` was never refused.** Observed on 2026-09-21 in the Copilot CLI 1.0.86 on Windows: the session edited through `apply_patch`, and the edit went through on `main`. Why that session used `apply_patch` rather than `create` is not established; it may depend on the model. **It also checks the shell tools:** a `bash` or `powershell` command runs on `main` only when it is on the same short list as in Claude Code (above), and input sent to a running shell (`write_bash`, `write_powershell`) is refused there. MCP tools (named `<server>-<tool>`) are refused on `main` too, read-only ones included, **but GitHub does not document whether Copilot's hooks see MCP calls at all**, so they may not be guarded; see [Optional git hooks](#optional-git-hooks).

**In an IDE, the rules guide Copilot and do not bind it.** Asked whether an action its rules forbid was allowed, Copilot in our test answered no and gave the rule almost word for word. Asked to do that same kind of thing, it went ahead anyway. Instruction files are context for the model, not a gate in front of its tools. **Keep the checks that enforce whatever the tool:** git hooks in your project, which refuse the commit whoever wrote it, branch protection where your plan offers it, and a person's approval before every push and merge (`GIT-4`, `GIT-5`).

**Good to know:**
- **You can always overrule the guardrail.** It is a plain file in your project: delete `.github/hooks/kenaido-no-main-edit.json`, or run the installer with `--remove`.
- **Windows: observed.** 0.3.0 shipped only a `bash` command, so on Windows there was nothing for Copilot to run. 0.3.1 adds a `powershell` one. **Observed refusing an edit on `main`**, in the Copilot CLI 1.0.86 on Windows, 2026-09-21, with kenaido 0.7.0 (the matcher fix in #314). **Not yet observed:** the Copilot cloud agent on Windows, and Copilot in an IDE on Windows (the IDE runs no hooks at all, so this guardrail does not apply there regardless).
- **It fails open, and says so.** If the guardrail cannot run — its script is missing, or git is not on your `PATH` — **the edit goes through rather than being blocked.** That is deliberate: a guardrail must never break your work. **In the Copilot CLI it does not go through in silence:** at every session start a check shows you a warning that begins `kenaido warning:` and says what to fix, and at every guarded edit the same warning appears in the timeline. **Where no warning can reach you:** in an IDE (no hooks run at all), in the cloud agent (it runs with no person to show a warning to), if the hook file `.github/hooks/kenaido-no-main-edit.json` itself is gone, and **when the guardrail's script is present but fails for any other reason**: that edit goes through too, **with no warning**. **On Windows, 0.3.1 to 0.6.0 did the opposite of failing open:** if the PowerShell script was missing, Copilot, which treats a failing guardrail as a refusal, would have refused every edit (so GitHub's hooks reference describes it; nobody here has seen it happen). The Windows command now checks for its script first. **Observed on Windows, 2026-09-21, with kenaido 0.7.0:** with the script missing, the guarded edit showed the `kenaido warning:` text and was allowed, as designed. **The session-start warning was not observed** in that same test; treat it as still unproven on Windows. Your project's git hooks remain the floor that catches a commit whatever wrote it.
- **Copilot picks the model itself on the free plan,** with no way to choose a stronger one, and a small, fast model follows long instructions less closely. If your plan lets you choose, pick the strongest model available for work that has to follow the rules.
- **Keep the project on the same file system as the IDE.** In our test, Copilot in a JetBrains IDE on Windows could not reach a project living inside WSL: instead of writing in the project, its file tool wrote into its own folder elsewhere on the machine. This is Copilot's behavior, not something the package can change.

## Codex

**You need:** Codex, and an SSH key on your GitHub account for the clone below (check "Which case am I?" above; for HTTPS instead, see [Claude Code, step 1](#claude-code)).

### Step 1: clone this repository

Once per project, in a terminal, type:
```
git clone git@github.com:agentic-bytes/kenaido.git
```
**You should see:** `Cloning into 'kenaido'...`, ending without an error. **If you don't:** an SSH or access error means step 1's setup ("Which case am I?", above) isn't done yet.

### Step 2: verify this release

**Verify this release** before installing it, and after every update, from the clone (`bash`, `git`, `sha256sum`). On Windows, use Git Bash (Git for Windows' `bash.exe`) — your `PATH`'s `bash` may lack `sha256sum`.
```
cd kenaido
tail -n +4 RELEASE-MANIFEST | sha256sum -c --quiet && scripts/check-release-manifest.sh
cd ..
```
**You should see:** a line ending `The release is what kenaido <version> at <commit> produced`. **If you don't:** stop, and don't install. What this shows, and what it doesn't: [How each release is checked](#how-each-release-is-checked).

**From `1.0.1` on, also check the release's signed tag** before you install: [Check the release's signed tag](#check-the-releases-signed-tag). It shows that the release is the one kenaido's maintainer signed, which this step alone cannot show.

### Step 3: install into your project

```
sh kenaido/codex/install.sh /path/to/your/project
```
**You should see:** a line starting `kenaido <version>: installed <N> rules, <N> agents, and <N> skills into...`, and further lines about the guardrail needing to be trusted (see step 4).

**If you don't:** a line starting `kenaido: these files already exist and weren't installed by kenaido` names each conflicting file; nothing was written. Rename or remove those files, then run the command again.

It writes kenaido into your project, where Codex reads it:
- **an index of the rules,** as one marked kenaido block in `AGENTS.md`. Anything of yours already in that file stays untouched;
- **the rules themselves,** one file each, in `.codex/kenaido/rules/`;
- **the role agents,** in `.codex/agents/kenaido-*.toml`, as Codex custom agents;
- **the skills,** in `.codex/kenaido/skills/`;
- **the rest of the pack** — the toolbox, the templates, the guides, and each department's interface — in `.codex/kenaido/`;
- **a guardrail,** in `.codex/hooks.json`.

It never overwrites a file of your own: if one is in the way, it stops before writing anything and says which. `--remove` takes it all out again.

**Why `AGENTS.md` holds an index, not the rules.** Codex caps the instruction chain at about 32 KiB; the 17 rule files total over 80 KiB and, pasted whole, would be **truncated with no error or warning** — rules stopping mid-sentence, with no way to tell. So the block names each rule and where to read it, and Codex reads the ones that apply.

**What you get:**
- the rules, indexed and read on demand;
- **41 role agents**, as `kenaido-<role>`. Ask for one by name, and `/agent` lists them;
- the skills, as files to read. **Not registered commands:** Codex registers skills through a plugin, and this is a file install.

**What it loads into every session** (measured from the 1.0.2 package in characters; tokens are an estimate at 3 to 4 characters per token, not a count):
- **the rules index, in the kenaido block of `AGENTS.md`:** 2,337 characters, about 600 to 800 tokens; each rule is read only when it applies;
- **the 41 role agents' names and descriptions:** 14,164 characters, about 3,500 to 4,700 tokens. Whether Codex sends them before an agent is used **has not been observed**. The skills are plain files, so nothing of them loads until one is read.

### Step 4: turn the guardrail on

It is installed but inert until you trust it: in the Codex CLI, type `/hooks`, review what it runs, and trust it. **You should see:** two hooks to trust, the guardrail itself and a session-start check that warns you when the guardrail cannot run — Codex counts them as installed but not active until then (0.4.x, with one hook, showed `Installed 1 · Active 0`) — and a warning that trusting lets them run outside Codex's sandbox, which is what any guardrail needs in order to check your repository. **After every update, trust them again:** Codex records trust against each hook's exact text, so a changed hook is skipped until you review it. **The hook runs only the script it was installed with:** Codex's trust covers the hook's own text, not the script in `.codex/kenaido/` that it runs, so the hook carries that script's checksum and never runs a script that does not match. On `main` or `master` everything is then refused until you install the package again; on other branches you get a warning.

**Update:** pull this repository and run the same command again. **Remove:** `sh kenaido/codex/install.sh --remove /path/to/your/project`. It removes only what it wrote, and takes its block out of `AGENTS.md`, leaving your own text as it was.

**Tested in:** the Codex CLI on Windows (v0.154.0-alpha.6.2), against a project inside WSL, on 2026-09-16, 2026-09-17, 2026-09-21, and 2026-09-23. The first two tests found the surface and trust limits below, and **a defect in 0.4.0: its Windows guardrail command did not run inside Codex**, so on Windows the guardrail let edits through. **0.4.1 fixes it; if you use Codex on Windows, update.** **Observed on Windows, 2026-09-21, with kenaido 0.7.0: all four steps of the live test passed** — hooks installed and trusted, the edit refused on `main`, the missing-script warning shown at session start and at the edit with the edit allowed, and the edit allowed on a work branch. **Observed on Windows, 2026-09-23, with this package before its 0.11.0 release,** in the Codex CLI v0.154.0-alpha.6.2 (the copy that comes with the Codex desktop app, run from PowerShell), against a project inside WSL: an edit on `main` was refused with nothing written, and the same edit was allowed on a work branch; with the guardrail's script changed by one byte, the edit on `main` was refused with the message telling you to install the package again; as a control, with the checksum check taken out of the hook, Codex asked for the changed hook to be reviewed but not for the changed script, and the same one-byte change then let the edit through; and removal left only the project's own files.

### What is enforced in Codex, and what is not

**Three conditions have to hold before the guardrail does anything, and you control all three.**

| | |
|---|---|
| **1. The surface** | Hooks work in the **Codex CLI**. They do **not** work in the ChatGPT desktop app — `/hooks` does not exist there. Tested on 2026-09-16 |
| **2. Trust** | A project hook does nothing until you review and trust it, and again after every update that changes it. Codex shows the hooks as installed but not active until you do (`Installed 1 · Active 0` in 0.4.x, which had one hook), and warns that hooks can run outside its sandbox once trusted. **Installed is not active** |
| **3. Whether the deny is honored** | **Observed on Windows, twice.** On 2026-09-17 and again on 2026-09-21 (kenaido 0.7.0), in the Codex CLI on Windows, Codex showed `Blocked by hook` with kenaido's reason and did not write the file. Codex has open reports of a `PreToolUse` deny firing while the write proceeds ([#27833](https://github.com/openai/codex/issues/27833), [#26733](https://github.com/openai/codex/issues/26733)), version- and platform-dependent, so another version may behave differently |

**The guardrail refuses only the tools it names.** Codex's hooks pick the actions they check by tool name. kenaido's guardrail checks `apply_patch`, `Edit` and `Write`, Codex's file-edit tools, and **`Bash`, its shell tool**: on `main` a command runs only when it is on the same short list as in Claude Code (above). Codex's own documentation says input sent to a running command (`write_stdin`) does not pass the hook again, and that some tool paths skip hooks. MCP tool calls (a tool a connected server provides) are refused on `main` too, read-only ones included; see [Optional git hooks](#optional-git-hooks).

**What has been observed, precisely:** on 2026-09-17, on Windows, **kenaido 0.4.1 as released** refused an edit on `main` and let the same edit through on a work branch. On 2026-09-21, on Windows, kenaido 0.7.0 confirmed the same, and on 2026-09-23 this package did too, before its 0.11.0 release. **Not yet observed:** Codex on macOS or Linux, and Codex running inside WSL. **Keep git hooks in your own project as well**: they refuse a commit whatever wrote it.

**It fails open, and says so.** If the guardrail cannot run — its script is missing or unreachable, or git is not on your `PATH` — **the edit goes through rather than being blocked.** That is deliberate: a guardrail must never break your work. **It does not go through in silence:** a second hook checks, at every session start, that the guardrail's script is there and that git can be found, and if not, Codex shows you a warning that begins `kenaido warning:` and says what to fix; at every guarded edit, the same warning appears if the script is missing or git cannot be found. **Where no warning can reach you:** in the ChatGPT desktop app (no hooks run), before you trust the hooks (Codex warns about that itself at startup), if `.codex/hooks.json` itself is gone, and **when the guardrail's script is present but fails for any other reason**: that edit goes through too, **with no warning**. **One case refuses instead of failing open:** on `main` or `master`, if the script is not the one installed with the hooks you trusted (its checksum does not match), or the checksum cannot be computed, the script is not run and the action is refused until you install the package again; on other branches you get a warning. **Observed on Windows, 2026-09-23, with the script changed by one byte:** the session-start check's `kenaido warning:` appeared when the first message was sent, not when the session opened, and the edit on `main` was refused. **Observed on Windows, 2026-09-21, with kenaido 0.7.0:** with the script renamed away, both warnings appeared — at session start and at the guarded edit — and the guardrail let the edit through, as designed. (The file itself was then not written, because Codex on Windows cannot write into a WSL folder; see below.)

**You can always overrule it.** It is a plain file in your project: delete `.codex/hooks.json`, untrust it in `/hooks`, or run the installer with `--remove`.

**Where the guardrail looks for itself.** Codex's hook entries have no working-directory setting, and in our live test Codex was running from `C:\Windows\System32\...` rather than from the project. A guardrail that trusted its own directory — or asked git where it was — would have found nothing there and let every edit through in silence. So the hook reads the project path out of the input Codex hands it, and falls back to git only if that is missing. If that path is unclear (named twice, or not a plain full path), the hook uses the folder Codex started it in and refuses the action on `main` or `master`. Running the shipped command from outside any repository is a test in this package, with a control proving the earlier version failed it.

**On Windows with a project inside WSL**, four things we found in testing:

- **Windows git must be allowed to read the project, or the guardrail does nothing.** Out of the box, Git for Windows refuses a repository inside WSL ("detected dubious ownership"), the guardrail cannot tell which branch you are on, and it lets the edit through. Run `git rev-parse --abbrev-ref HEAD` in the project from PowerShell; if it refuses, run the `git config --global --add safe.directory ...` command it prints, for that project only.
- **Codex on Windows could not write into the WSL folder at all** (`Failed to write file`), with or without kenaido, in v0.154.0-alpha.6.2. For a project inside WSL, running Codex inside WSL avoids this; that setup has not yet been tested with kenaido.
- **Codex on Windows could also fail to *read* a file in the WSL project, not only write one.** Asked to quote a line from an installed agent file, it tried a relative PowerShell path, a UNC PowerShell path, and a WSL command, and each failed (`PathNotFound`, then two access-denied errors). It then answered anyway, with a quotation it invented rather than one it read. **Treat any answer about a file in a WSL project as unread until you have seen Codex open it**, and for a project inside WSL, running Codex inside WSL avoids the file-system boundary that causes this.
- **Paths:** Codex reaches the project over a UNC path (`\\wsl.localhost\...`), and `cmd` refuses a UNC path as a working directory. Use PowerShell, which handles it natively, or `pushd`.

## Antigravity

**Observed in the Antigravity app on Windows, 2026-09-22,** with this package before its 0.9.0 release: it loaded as a plugin, and its guardrail refused a file write and a shell write on `main` and let a write through on a work branch. **Not yet observed:** the Antigravity IDE, the CLI, macOS, and Linux.

**You need:** Antigravity (the CLI, Antigravity 2.0, or the Antigravity IDE), git, and an SSH key on your GitHub account for the clone below. Check "Which case am I?" above.

### Step 1: clone this repository

Once per project, in a terminal, type:
```
git clone git@github.com:agentic-bytes/kenaido.git
```
**You should see:** `Cloning into 'kenaido'...`, ending without an error.

### Step 2: verify this release

**Verify this release** before installing it, and after every update, from the clone (`bash`, `git`, `sha256sum`). On Windows, use Git Bash (Git for Windows' `bash.exe`) — your `PATH`'s `bash` may lack `sha256sum`.
```
cd kenaido
tail -n +4 RELEASE-MANIFEST | sha256sum -c --quiet && scripts/check-release-manifest.sh
cd ..
```
**You should see:** a line ending `The release is what kenaido <version> at <commit> produced`. **If you don't:** stop, and don't install. What this shows, and what it doesn't: [How each release is checked](#how-each-release-is-checked).

**From `1.0.1` on, also check the release's signed tag** before you install: [Check the release's signed tag](#check-the-releases-signed-tag). It shows that the release is the one kenaido's maintainer signed, which this step alone cannot show.

### Step 3: install into your project

**On Windows, run this from Git Bash:** it then writes the guardrail's Windows commands. `--windows` or `--posix` chooses by hand.
```
sh kenaido/antigravity/install.sh /path/to/your/project
```
**You should see:** a line starting `kenaido <version>: installed the Antigravity plugin into...`.

**If you don't:** a line starting `kenaido: these files already exist and weren't installed by kenaido` names each conflicting file; nothing was written. Rename or remove those files, then run the command again.

It writes one folder, `.agents/plugins/kenaido/`, which Antigravity loads as a plugin for that project only:
- **an index of the rules,** in `rules/kenaido.md`. Antigravity limits a rule file to 12,000 characters, and two of kenaido's rules are longer, so the index names each rule and where to read it;
- **the rules themselves and the rest of the pack** — the toolbox, the templates, the guides, and each department's interface — in `pack/`;
- **41 role agents**, in `agents/`, as `kenaido-<role>`;
- **the skills,** in `skills/`, as `kenaido-<name>`, which Antigravity also offers as slash commands;
- **a guardrail,** in `hooks.json`.

It never overwrites a file of your own: if one is in the way, it stops before writing anything and says which. `--remove` takes it all out again. To see that Antigravity loaded it, open its Customizations panel, or run `agy plugin list` in the CLI.

**The guardrail.** While `main` or `master` is checked out, it refuses file edits, shell commands outside the same short list as Claude Code (above), and every unrecognized tool — MCP tools included, since Antigravity's documentation does not say how they are named. Read-only tools pass; on a work branch it stays out of the way. **If it cannot run** (script missing, or git not on `PATH`), each call it would have checked is handed to you to decide, with a `kenaido warning:` — never let through in silence.

**What the live session showed,** in the Antigravity app on Windows:
- **the app runs a plugin's hooks,** though the documentation names plugin hooks for the CLI only;
- **a hook that answers nothing lets the call through,** which is how the guardrail passes reads, safe commands, and everything on a work branch;
- **on Windows the guardrail runs as a PowerShell command,** and its refusal reaches the agent word for word.

**Not yet known:** whether the Antigravity IDE and the CLI run plugin hooks the same way; whether MCP tool calls reach the guardrail at all; and the warning shown when the guardrail cannot run.

**What it takes of Antigravity's customization budget.** **Observed** in the Antigravity app (2.0) on Windows, on 2026-09-22, with a package built before the 0.9.0 release: the budget panel showed **Subagents 4,738 tokens, 23.7% of the budget**, and Skills 463 tokens (2.3%), with 74.0% still available. **The agents take that share whether or not you use one.** The panel showed no line for the rules index. What the 0.12.0 package holds (measured from the 0.12.0 package in characters; tokens are an estimate at 3 to 4 characters per token, not a count):
- **the 41 role agents' names and descriptions:** 14,164 characters, the same as in the package observed, so the same share is expected, **not observed on 0.12.0**;
- **the 5 skills' names and descriptions:** 1,306 characters, one skill more than the 4 observed, so their share is likely a little above 2.3%, **not observed**;
- **the rules index,** `rules/kenaido.md`: 2,664 characters, about 670 to 890 tokens.

**Update:** pull this repository and run the same command again. **Remove:** `sh kenaido/antigravity/install.sh --remove /path/to/your/project`. **Keep git hooks in your own project as well** (below): they refuse a commit whatever wrote it.

## pi

**Observed in pi 0.87.0 on Windows, 2026-09-22, with a local model** (`qwen3:8b`, Ollama; package before 0.10.0): pi loaded it and its guardrail refused a file write and a shell write on `main`, letting a write through on a work branch. **Not yet observed:** macOS, Linux, other pi versions or models.

**You need:** pi, a model pi can reach (used under that provider's own terms), git, and an SSH key on your GitHub account for the clone below. Check "Which case am I?" above.

### Step 1: clone this repository

Once per project, in a terminal, type:
```
git clone git@github.com:agentic-bytes/kenaido.git
```
**You should see:** `Cloning into 'kenaido'...`, ending without an error.

### Step 2: verify this release

**Verify this release** before installing it, and after every update, from the clone (`bash`, `git`, `sha256sum`). On Windows, use Git Bash (Git for Windows' `bash.exe`) — your `PATH`'s `bash` may lack `sha256sum`.
```
cd kenaido
tail -n +4 RELEASE-MANIFEST | sha256sum -c --quiet && scripts/check-release-manifest.sh
cd ..
```
**You should see:** a line ending `The release is what kenaido <version> at <commit> produced`. **If you don't:** stop, and don't install. What this shows, and what it doesn't: [How each release is checked](#how-each-release-is-checked).

**From `1.0.1` on, also check the release's signed tag** before you install: [Check the release's signed tag](#check-the-releases-signed-tag). It shows that the release is the one kenaido's maintainer signed, which this step alone cannot show.

### Step 3: install into your project

**On Windows, run this from a shell that has `sh`,** such as Git Bash or WSL. In the live session, it was run in WSL, and the project was then used from Windows.
```
sh kenaido/pi/install.sh /path/to/your/project
```
**You should see:** a line starting `kenaido <version>: installed <N> rules, <N> roles, and <N> skills into...`.

**If you don't:** a line starting `kenaido: these files already exist and weren't installed by kenaido` names each conflicting file; nothing was written. Rename or remove those files, then run the command again.

### Step 4: trust the project

pi loads the roles, the skills, and the guardrail only after you trust the project: start pi in the project and accept its trust prompt, or run `/trust`.

It writes into the project:
- **a kenaido block that indexes the rules,** in the context file pi already reads in the project root: the first that exists of `AGENTS.override.md`, `AGENTS.md`, and `CLAUDE.md`, or a new `AGENTS.md`. The rest of that file is left alone. pi sends the block with every request, and the rules are read when they apply. Other tools that read that file see the block too;
- **41 roles,** as prompt templates in `.pi/prompts/`, called as `/kenaido-<role> <task>`, for example `/kenaido-architect`. pi has no sub-agents, so a role works in your current session;
- **the skills,** in `.pi/skills/`, called as `/skill:kenaido-<name>`;
- **a guardrail,** a pi extension, in `.pi/extensions/kenaido-guard/`;
- **the rules, the complete roles, and the rest of the pack** — the toolbox, the templates, the guides, and each department's interface — in `.pi/kenaido/`.

**What it loads into every session** (measured from the 1.0.2 package in characters; tokens are an estimate at 3 to 4 characters per token, not a count):
- **the kenaido block** in the context file: 2,841 characters, about 700 to 950 tokens, sent with every request;
- **the 41 role prompts' and 5 skills' descriptions:** 14,164 and 1,306 characters. Which of them pi sends before one is called **has not been observed**. The full rules and roles stay in `.pi/kenaido/` until read.

It never overwrites a file of your own: if one is in the way, it stops before writing anything and says which. `--remove` takes it all out again.

**The guardrail.** Once the project is trusted, while `main` or `master` is checked out, it refuses pi's edit and write tools, bash/PowerShell commands that can change files (read-only ones such as `git status` and `git switch -c` still run), other extensions' tools, and your own file-changing `!` commands. On a work branch it stays out of the way. Without git, it lets calls through with a `kenaido warning:`. **pi runs every extension, this one included, with your full system permissions. It cannot catch:** a tool another extension overrides under a built-in name, anything before you trust the project, or your own terminal.

**Turning it off.** pi loads every folder in `.pi/extensions/` regardless of name — renaming the guardrail's folder to `off` there still loaded and refused. Moving the folder out of `.pi/extensions/` turned it off. pi's documentation also lists `pi --no-extensions` and `pi config`; neither was tried.

**What the live session showed,** in pi 0.87.0 on Windows:
- pi's header listed the context file, the 4 skills, the 41 role prompts, and the guardrail, with no kenaido warning;
- on `main`, a file write and `echo hello > notes2.txt` were refused word for word, neither file created; a read and `git status` went through;
- on a work branch, the write went through;
- with the guardrail moved out of `.pi/extensions/`, the same write on `main` went through — the refusals were the guardrail's, not pi's or the model's;
- pi downloaded `fd` and `ripgrep` on first start, without asking, into `.pi\agent\bin\` (pi's doing, not kenaido's);
- the local model found the right rule file from the index, and `/kenaido-architect` expanded into its template, but answered without reading the files it was pointed to — a small local model may not call tools when asked; check that yours does.

**Not yet known:** macOS and Linux; pi versions other than 0.87.0; other models; your own `!` command; the skills in use; and what happens when a conversation outgrows a local model's window (pi showed a 128k window while the local server was set to 16,384 tokens).

**Update:** pull this repository and run the same command again. **Remove:** `sh kenaido/pi/install.sh --remove /path/to/your/project`. **Keep git hooks in your own project as well** (below): they refuse a commit whatever wrote it.

## How each release is checked

Every release is built by kenaido's release scripts, and carries `RELEASE-MANIFEST`: the kenaido commit and version it was built from, and the SHA-256 of every file. On every pull request, this repository's pipeline (`.github/workflows/ci.yml`, which runs `scripts/check.sh`) checks:
- that every file is still exactly as the release scripts wrote it, that nothing was added or removed, and that every package states the same version;
- the shell scripts, with a linter;
- that the installer of every package the release carries installs into an empty project and removes itself cleanly;
- that the guardrail each package installs refuses a file edit on `main`, writing nothing, and allows it on a work branch. For each tool it installs the package into an empty project and runs the hook command the install wrote, the way that tool runs it, with the input that tool's documentation describes; pi's guardrail is loaded as pi loads it. A control runs the same call without the install, and must not be refused;
- the history, for secrets;
- a bill of materials of the repository, for known vulnerabilities.

**What this does not prove:** that an agent actually calls the hook. The pipeline runs each guardrail the way its tool is documented to call it, but no agent runs here, so a tool that skips or misdocuments its hooks is not caught. The Windows (PowerShell) commands don't run either, since the pipeline is Linux; for Claude Code it runs every hook entry as Linux would, showing the Windows-only entry stays silent there — whether it runs on Windows is checked by hand.

**To check a copy you have yourself,** use the verify step in each install section above. **What it shows:** every file is the one `RELEASE-MANIFEST` lists, with its build-time SHA-256, and nothing was added or removed. Your own `sha256sum` checks the files first, the checking script among them, so it runs only if it is the one the release was built with.

**What it does not show on its own: that the release is genuine.** `RELEASE-MANIFEST` is written into the release it describes, so anyone able to change the release can write a matching one and still pass. The signed tag, below, is checked against something the release cannot rewrite.

**Before each release is merged, an AI agent reviews it and the project's maintainer merges it:** kenaido's own pipeline, run from kenaido's `main`, rebuilds the release from the kenaido commit its `RELEASE-MANIFEST` names, which must be on kenaido's `main`. The reviewer agent then checks, with kenaido's own script and its own `sha256sum` and `git`, that every file in the release is the one its `RELEASE-MANIFEST` lists, and that this manifest's SHA-256 equals the rebuilt one's. So a file changed, added, or removed after the release was built stops the release before it is merged, whether its manifest was kept or rewritten to match.

**Releases are built from a private source repository.** kenaido's own development happens in a repository the public cannot read; only its maintainer can run the check above, since only the maintainer can see the commit `RELEASE-MANIFEST`'s `source` line names. Everything a release needs to be checked by anyone else — every file's SHA-256, the version, and, from `1.0.1` on, a signed tag — ships in this public repository instead, so a reader can still verify the release matches what was published, without being able to inspect the commit it came from.

**The Claude Code marketplace entry is not pinned to a commit.** Claude Code's format can pin a plugin to an exact commit (`sha`), but kenaido's entry lives in this repository and is written in the same commit as the plugin it points to, so it cannot name that commit; and a marketplace itself can be pinned only to a branch or a tag, not to a commit ([Claude Code's documentation on plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces), "Marketplace sources vs plugin sources"). A pin written by the same hands as the release would add nothing a changed release could not change too.

### Check the release's signed tag

Every release has a tag, `v<version>`, signed by kenaido's maintainer with a key published on the maintainer's GitHub account, `stefanomarcolini`.

In a terminal (`bash`, `git` 2.34 or later, `curl`, `sha256sum`; on Windows, Git Bash), with the version you want on the first line:
```
V=v1.0.2
git clone -q https://github.com/agentic-bytes/kenaido.git "kenaido-$V"
cd "kenaido-$V"
git -c advice.detachedHead=false checkout -q "$V"
curl -fsS https://api.github.com/users/stefanomarcolini/ssh_signing_keys | grep -o '"key": *"[^"]*"' | sed 's/^"key": *"/stefanomarcolini namespaces="git" /; s/"$//' > .git/allowed_signers
git -c gpg.ssh.allowedSignersFile=.git/allowed_signers tag -v "$V" &&
  git cat-file tag "$V" | grep -qxF "tag $V" &&
  tail -n +4 RELEASE-MANIFEST | sha256sum -c --quiet && scripts/check-release-manifest.sh
cd ..
```
The fifth line downloads the maintainer's published signing keys from GitHub into a file git reads. The sixth checks the tag's signature against them. The seventh checks that the name signed inside the tag is the version you asked for, since a signed tag can be copied under another name. Only if both are good does the eighth, the verify step above, run, so nothing from the release runs before its tag is checked.

**You should see:** the tag's text, including the line `tag v1.0.1`; a line starting `Good "git" signature for stefanomarcolini`; and at the end, a line ending `The release is what kenaido 1.0.1 at <commit> produced`, with the version you asked for.

**If you don't:** stop, and don't install. If the good signature line is there but nothing follows it, the tag was signed for a different version than the one you asked for. A line `Good "git" signature with ...` (without `for stefanomarcolini`) followed by `No principal matched.` is a failure: the tag is signed, but not with a key the maintainer has published. So is `error: no signature found`. The download can fail too (GitHub allows 60 requests an hour without signing in); then the check fails the same way, and you can try again later.

**Install from what you checked.** For GitHub Copilot, Codex, Antigravity, and pi, install from this folder: use `kenaido-v1.0.1` wherever the install steps say `kenaido`. Claude Code installs from its own copy instead: from the folder that holds `kenaido-v1.0.1`, run `cmp kenaido-v1.0.1/RELEASE-MANIFEST "<installLocation>/RELEASE-MANIFEST"`, where `<installLocation>` is the folder from Claude Code's Step 3. No output means Claude Code's copy lists the same files, with the same SHA-256, as the signed release, and its Step 3 then checks every file against that list. Any other output means Claude Code holds a different release: check that release's tag instead.

**What the tag check shows:** the tag, and with it every file of the commit it names, was signed with a key published on the `stefanomarcolini` GitHub account, for the version you asked for. A release changed after it was signed fails, whether its `RELEASE-MANIFEST` was rewritten to match or not. **What it does not show:** that the code is safe or free of mistakes; that the maintainer's GitHub account and signing key were never taken over (whoever controls either one can sign, or publish a key); that this is the newest release (an older signed tag still passes); or the copy Claude Code keeps in its own cache.

## Optional git hooks

**A hook in an agent tool sees only what that tool shows it;** git sees every commit and push, whatever made it. The guardrail's shell check has been observed in a live session only in Claude Code, Antigravity, and pi, on Windows, so these hooks are the floor. Every package ships an opt-in script that installs four git hooks in a project: `pre-commit` and `pre-merge-commit` refuse a commit on `main` or `master`, `pre-push` refuses a push to them, and `reference-transaction` refuses moving them to anything but what origin has — **the only thing that stops an agent on another branch from moving `main` with `git branch -f` or `git update-ref`**. A fast-forward from origin (`git pull --ff-only`) still works. They cannot stop a command that first rewrites the local copy of origin, turns the hooks off, or writes git's files directly; they are a floor, not a lock. `reference-transaction` needs git 2.28.0 or later; an older git ignores it, and the script tells you. Nothing installs them unless you run it, from the project:

```
sh <package>/install-git-hooks.sh
```

The script is `scripts/install-git-hooks.sh` in the Claude Code plugin, and `install-git-hooks.sh` beside `install.sh` in the Copilot, Codex, Antigravity and pi packages; on Windows, run it from Git Bash. It never replaces a hook that is already there, and installs nothing if the project sets `core.hooksPath`. Hooks live in your clone, so any git command can switch them off (`--no-verify`, `-c core.hooksPath`): they are a floor, not a lock. To turn a hook off, delete its file from `.git/hooks/`.

## Other coding agents

The five tools above are what kenaido supports. None more are planned.

## License

**Free to use, change, and share, under the Apache License 2.0** (`LICENSE`), except for the files that describe guides offered under CC BY-SA 4.0: those files are under CC BY-SA 4.0 too. In every package, they include `DISCLAIMER.md`, the Scrum, flow, value, team, and improvement rules, several role agents, and the Sprint templates; each says so at its top, and `NOTICE` lists them and gives the credits. When you share a package, changed or not, include `LICENSE`, `NOTICE`, and `DISCLAIMER.md`, and mark what you changed.

**Acceptable use.** `ACCEPTABLE-USE-POLICY.md`, at this release's top level, and `docs/acceptable-use-policy.md`, inside every tool's own package, state the uses kenaido is not built, sold, or knowingly supported for. It cannot forbid anyone a use of this free, Apache-2.0-licensed code: it is a statement of how kenaido's makers conduct themselves, and it binds a customer of a paid offering or a service only through that customer's contract, where it is a term.

**At your own risk.** The packages are provided "as is", with no warranty, and the authors are not liable for what happens when you use them (sections 7 and 8 of the license). Where the law does not allow a warranty or a liability to be excluded, for example for deliberate or grossly negligent acts, or under consumer law, the exclusion applies only as far as that law allows.

**Names.** The license gives no right to the names "kenaido" or "agentic-bytes". Claude Code, GitHub Copilot, Codex, GitHub, JetBrains, VS Code, ChatGPT, Windows, the Scrum Guide, and every other name mentioned here belong to their owners. They are used only to refer to those products, and kenaido is not affiliated with or endorsed by their owners.
