#!/usr/bin/env bash
# Runs one tool's guardrail as a person would get it (#252): installs the
# tool's package from this release into an empty git project, takes the
# PreToolUse hook command from the configuration the install wrote, and runs
# it the way that tool runs it, with that tool's own hook input for a file
# edit. On `main` the edit must be refused and nothing written; on a work
# branch it must be allowed. A control runs the same call in a project
# without the install: it must not be refused, and must fail for the stated
# reason (the guardrail is missing), or the refusal above proves nothing.
#
# The hook inputs follow each tool's documentation, as each guardrail's
# header cites it (read 2026-09-21 unless stated):
#   claude_code  code.claude.com/docs/en/hooks.md, "PreToolUse input": the
#                JSON on stdin, `tool_name` and `tool_input`; the command runs
#                in the project with CLAUDE_PLUGIN_ROOT set to the plugin.
#                Every PreToolUse entry runs, as Claude Code on Linux runs it
#                (same page, "Command hook fields" and "Exec form and shell
#                form", read 2026-09-23): `shell: "bash"` in bash, no `shell`
#                with `sh -c`. `shell: "powershell"` fails the check, because
#                with no PowerShell installed Claude Code reports a hook error
#                on every call (#381); an entry that exits other than 0 or 2,
#                or a default-shell entry that prints anything, is a hook
#                error too.
#   copilot      docs.github.com/en/copilot/reference/hooks-reference,
#                "preToolUse": `toolName` and `toolArgs`, which may arrive as
#                a JSON string (.../cloud-agent/use-hooks, "Debugging"); the
#                `bash` command runs in the repository root (`cwd: "."`).
#   codex        learn.chatgpt.com/docs/hooks, "PreToolUse": `cwd`,
#                `tool_name`, `tool_input`; the hook may run from a folder
#                outside the project (live test, 2026-09-16), so it runs from
#                one here, with an empty environment.
#   antigravity  antigravity.google/docs/hooks.md, "PreToolUse": `toolCall`
#                with `name` and `args`, and `workspacePaths`; it runs from a
#                folder outside the project, with no plugin in the home folder.
#   pi           pi's source at v0.87.0, packages/coding-agent/src/core/
#                extensions (read 2026-09-22): pi imports the extension, which
#                registers `tool_call`; the event has `toolName` and `input`,
#                and `{ block: true }` stops the tool. It runs in the pinned
#                Node.js image, sealed (decision 0092). That image has no git,
#                so a stand-in answers `git rev-parse --abbrev-ref HEAD` from
#                the project's own .git/HEAD.
#
# What this does not prove: that an agent calls the hook at all (#368). The
# Windows commands (PowerShell) are not run here: they need Windows (decision
# 0095); for Claude Code, the check proves only that its PowerShell entry
# stays silent where sh runs it. Built by kenaido's release scripts; do not edit this copy by hand.
# Usage: scripts/check-installed-guards.sh <claude_code|copilot|codex|antigravity|pi>
# (from the repository root; NODE_IMAGE is set by scripts/check.sh). Requires Docker.
set -euo pipefail
cd "$(dirname "$0")/.."
: "${NODE_IMAGE:?set NODE_IMAGE, as scripts/check.sh does}"
tool=${1:?usage: scripts/check-installed-guards.sh <tool>}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/bin" "$WORK/home" "$WORK/elsewhere" "$WORK/no-plugin"

failures=0
pass() { echo "PASS: $tool: $1"; }
fail() { echo "FAIL: $tool: $1"; failures=$((failures + 1)); }

PROBE=kenaido-guard-probe.txt

new_repo() {  # $1: folder; an empty git project with one commit, on main
  mkdir -p "$1"
  git -C "$1" init -q --initial-branch=main
  git -C "$1" -c user.name=check -c user.email=check@example.invalid -c commit.gpgsign=false \
    commit -q --allow-empty -m first
}

snapshot() {  # $1: project; what git sees there, and the probe's presence
  git -C "$1" status --porcelain --untracked-files=all
  [ ! -e "$1/$PROBE" ] || echo "probe written"
}

node_run() {  # the pinned Node.js image, sealed; the rest is the command
  docker run --rm -i --network none --read-only --cap-drop ALL --security-opt no-new-privileges \
    --user "$(id -u):$(id -g)" -v "$WORK:$WORK:ro" "$@"
}

# The PreToolUse command the installed configuration gives an edit tool: the
# only one whose matcher matches that tool's name.
cat > "$WORK/hook-command.mjs" <<'JS'
import { readFileSync } from "node:fs";
const [tool, name] = process.argv.slice(2);
const c = JSON.parse(readFileSync(0, "utf8"));
const cmds = (e) => (e.hooks ?? []).filter((h) => h.type === "command").map((h) => h.command);
const matches = (m) => m === undefined || m === "*" || new RegExp(`^(?:${m})$`).test(name);
if (tool === "claude_code") {
  // Every entry Claude Code runs for this tool, as NUL-separated pairs: shell, command.
  const all = c.hooks.PreToolUse.filter((e) => matches(e.matcher)).flatMap((e) => (e.hooks ?? []).filter((h) => h.type === "command"));
  if (all.some((h) => h.shell === "powershell")) {
    console.error(`claude_code: a PreToolUse entry has shell: "powershell"; on Linux and WSL, with no PowerShell installed, Claude Code reports a hook error on every call (#381)`);
    process.exit(1);
  }
  if (!all.some((h) => h.shell === "bash")) {
    console.error(`claude_code: no PreToolUse entry with shell: "bash" matches '${name}'`);
    process.exit(1);
  }
  process.stdout.write(all.map((h) => `${h.shell ?? "default"}\0${h.command}\0`).join(""));
  process.exit(0);
}
const entries = {
  copilot: () => c.hooks.preToolUse.map((e) => ({ m: e.matcher, cmds: [e.bash] })),
  codex: () => c.hooks.PreToolUse.map((e) => ({ m: e.matcher, cmds: cmds(e) })),
  antigravity: () => c["kenaido-guardrail"].PreToolUse.map((e) => ({ m: e.matcher, cmds: cmds(e) })),
}[tool]();
const found = entries.filter((e) => matches(e.m)).flatMap((e) => e.cmds);
if (found.length !== 1) {
  console.error(`${tool}: ${found.length} PreToolUse commands match '${name}' in the installed configuration; expected 1`);
  process.exit(1);
}
process.stdout.write(found[0]);
JS

# pi: import the installed extension as pi does, and fire one tool_call.
cat > "$WORK/pi-tool-call.mjs" <<'JS'
const [ext, cwd, toolName, input] = process.argv.slice(2);
const handlers = {};
const mod = await import(ext);
await mod.default({ on: (event, handler) => { handlers[event] = handler; } });
const result = await handlers.tool_call({ type: "tool_call", toolCallId: "call-1", toolName, input: JSON.parse(input) }, { cwd, hasUI: false });
process.stdout.write(JSON.stringify(result ?? null) + "\n");
JS
cat > "$WORK/bin/git" <<'SH'
#!/bin/sh
# Stands in for git in the Node.js image: the branch from this folder's .git/HEAD.
[ "$*" = "rev-parse --abbrev-ref HEAD" ] || { echo "git stand-in: only rev-parse --abbrev-ref HEAD" >&2; exit 2; }
head=$(cat .git/HEAD 2>/dev/null) || { echo "fatal: not a git repository" >&2; exit 128; }
case $head in "ref: refs/heads/"*) echo "${head#ref: refs/heads/}" ;; *) echo HEAD ;; esac
SH
chmod +x "$WORK/bin/git"

hook_command() {  # $1: installed configuration, $2: the edit tool's name
  node_run "$NODE_IMAGE" node "$WORK/hook-command.mjs" "$tool" "$2" < "$1"
}

# Per tool: how to install, where the configuration is, the edit's input, how
# the tool runs the command, what a refusal looks like, and what the control
# must say.
case "$tool" in
  claude_code)
    install() { sh plugins/kenaido/scripts/setup.sh "$1" > /dev/null; }
    config() { echo "$PWD/plugins/kenaido/hooks/hooks.json"; }
    edit_tool="Write"
    edit_input() { printf '{"session_id":"kenaido-check","transcript_path":"/dev/null","cwd":"%s","permission_mode":"default","hook_event_name":"PreToolUse","tool_name":"Write","tool_input":{"file_path":"%s/%s","content":"probe"}}' "$1" "$1" "$PROBE"; }
    # $1 project, $2 plugin root: every entry in $WORK/claude-entries, each
    # in the shell Claude Code on Linux gives it; a hook error is reported.
    run_hook() {
      local shell entry runner status out
      while IFS= read -r -d '' shell && IFS= read -r -d '' entry; do
        runner="sh"
        [ "$shell" != bash ] || runner=bash
        status=0
        out=$(cd "$1" && edit_input "$1" | CLAUDE_PLUGIN_ROOT="$2" CLAUDE_PROJECT_DIR="$1" "$runner" -c "$entry" 2>&1) || status=$?
        printf '%s\n' "$out"
        if [ "$status" -ne 0 ] && [ "$status" -ne 2 ]; then echo "hook error: the $shell entry exited $status"; fi
        if [ "$shell" = default ] && [ -n "$out" ]; then echo "hook error: the default-shell entry printed output"; fi
      done < "$WORK/claude-entries"
    }
    refused='"permissionDecision": *"deny"'
    missing='hooks/no-main-edit.sh is missing'
    ;;
  copilot)
    install() { sh copilot/install.sh "$1" > /dev/null; }
    config() { echo "$1/.github/hooks/kenaido-no-main-edit.json"; }
    edit_tool="edit"
    edit_input() { printf '{"timestamp":1704614400000,"cwd":"%s","toolName":"edit","toolArgs":"{\\"path\\":\\"%s\\",\\"new_str\\":\\"probe\\"}"}' "$1" "$PROBE"; }
    run_hook() { (cd "$1" && edit_input "$1" | bash -c "$cmd"); }
    refused='"permissionDecision": *"deny"'
    missing='its script in .github/kenaido/ is missing'
    ;;
  codex)
    install() { sh codex/install.sh "$1" > /dev/null; }
    config() { echo "$1/.codex/hooks.json"; }
    edit_tool="apply_patch"
    edit_input() { printf '{"session_id":"kenaido-check","transcript_path":null,"cwd":"%s","hook_event_name":"PreToolUse","model":"m","turn_id":"t","tool_name":"apply_patch","tool_use_id":"call-1","tool_input":{"command":"*** Begin Patch\\n*** Add File: %s\\n+probe\\n*** End Patch"}}' "$1" "$PROBE"; }
    run_hook() { (cd "$WORK/elsewhere" && edit_input "$1" | env -i PATH="$PATH" HOME="$WORK/home" sh -c "$cmd"); }
    refused='"permissionDecision": *"deny"'
    missing='its script in .codex/kenaido/ is missing'
    ;;
  antigravity)
    install() { sh antigravity/install.sh "$1" > /dev/null; }
    config() { echo "$1/.agents/plugins/kenaido/hooks.json"; }
    edit_tool="write_to_file"
    edit_input() { printf '{"toolCall":{"name":"write_to_file","args":{"TargetFile":"%s/%s","CodeContent":"probe"}},"stepIdx":3,"conversationId":"c","workspacePaths":["%s"],"modelName":"m"}' "$1" "$PROBE" "$1"; }
    run_hook() { (cd "$WORK/elsewhere" && edit_input "$1" | env -i PATH="$PATH" HOME="$WORK/home" sh -c "$cmd"); }
    refused='"decision": *"deny"'
    missing='its script in .agents/plugins/kenaido/hooks/ is missing'
    ;;
  pi)
    install() { sh pi/install.sh "$1" > /dev/null; }
    config() { echo ""; }
    edit_tool="write"
    run_hook() {
      node_run -v "$1:$1:ro" -w "$1" -e PATH="$WORK/bin:/usr/local/bin:/usr/bin:/bin" "$NODE_IMAGE" \
        node "$WORK/pi-tool-call.mjs" "$1/.pi/extensions/kenaido-guard/index.ts" "$1" write \
        "{\"path\":\"$PROBE\",\"content\":\"probe\"}"
    }
    refused='"block":true'
    missing='ERR_MODULE_NOT_FOUND'
    ;;
  *)
    echo "$tool: this release carries a package with no installed-guardrail check; add one to extensions/plugins-repository/ci/check-installed-guards.sh" >&2
    exit 1
    ;;
esac

project="$WORK/project"
new_repo "$project"
install "$project"
plugin_root="$PWD/plugins/kenaido"
cmd=""
if [ "$tool" = claude_code ]; then
  hook_command "$(config "$project")" "$edit_tool" > "$WORK/claude-entries" || { fail "the installed PreToolUse entries for '$edit_tool' would not run cleanly on Linux"; exit 1; }
elif [ -n "$(config "$project")" ]; then
  cmd=$(hook_command "$(config "$project")" "$edit_tool") || { fail "no PreToolUse command in the installed configuration reaches '$edit_tool'"; exit 1; }
fi

## On main: refused, and nothing written.
before=$(snapshot "$project")
out=$(run_hook "$project" "$plugin_root" 2>&1 || true)
if printf '%s' "$out" | grep -q '^hook error:'; then
  fail "on main, $(printf '%s' "$out" | grep '^hook error:' | head -1)"
elif ! printf '%s' "$out" | grep -qE "$refused"; then
  printf '%s\n' "$out" | tail -5
  fail "on main, the installed guardrail did not refuse the edit ($edit_tool)"
elif [ "$(snapshot "$project")" != "$before" ]; then
  fail "on main, the edit was refused, but something was written"
else
  pass "on main, the installed guardrail refuses the edit ($edit_tool), and nothing is written"
fi

## On a work branch: allowed.
git -C "$project" switch -q --no-track -c feat/some-work
out=$(run_hook "$project" "$plugin_root" 2>&1 || true)
if printf '%s' "$out" | grep -q '^hook error:'; then
  fail "on a work branch, $(printf '%s' "$out" | grep '^hook error:' | head -1)"
elif printf '%s' "$out" | grep -qE "$refused"; then
  fail "on a work branch, the installed guardrail refused the edit"
elif printf '%s' "$out" | grep -qF -- "$missing"; then
  fail "on a work branch, the installed guardrail did not run: $out"
else
  pass "on a work branch, the installed guardrail allows the edit"
fi

## CONTROL: the same call on main, in a project without the install.
bare="$WORK/bare"
new_repo "$bare"
out=$(run_hook "$bare" "$WORK/no-plugin" 2>&1 || true)
if printf '%s' "$out" | grep -qE "$refused"; then
  fail "CONTROL: without the install, the call was still refused; the check above proves nothing"
elif printf '%s' "$out" | grep -qF -- "$missing"; then
  pass "CONTROL: without the install, the same call is not refused ('$missing')"
else
  printf '%s\n' "$out" | tail -5
  fail "CONTROL: without the install, the call was not refused, but not for the missing guardrail"
fi

[ "$failures" -eq 0 ]
