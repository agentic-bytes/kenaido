#!/bin/sh
# kenaido's session-start hook. Three jobs:
#
# 1. **The guardrail's self-test (PBI-140).** The PreToolUse guardrail fails
#    open: if it cannot run, the edit goes through. That must never be silent,
#    so this checks, at every session start, the two things it needs — its own
#    script, and git to ask which branch is checked out — and when either is
#    missing it returns `systemMessage`, which Claude Code shows the person as
#    a warning (https://code.claude.com/docs/en/hooks.md, "JSON output", read
#    2026-09-21).
# 2. **A second copy synced from claude.ai (#384).** A plugin turned on for
#    the person's claude.ai account, with the same name as this one, also
#    loads at session start, as "<name>@synced" — but an installed copy on
#    this machine always outranks it, so the synced one is silently dropped
#    (Plugin loading reference, "Name conflicts", rows 3 and 5:
#    https://code.claude.com/docs/en/plugins/loading.md, read 2026-09-25).
#    `claude plugin list --json` reports the drop on the shadowed entry's own
#    object, as a `notes` line with `noteDetails[].type` set to
#    `synced-plugin-shadowed` (reproduced directly on this machine,
#    2026-09-25: `claude plugin list --json` on a machine with kenaido both
#    installed and synced from claude.ai; the shadowed object was
#    `{"id": "kenaido@synced", ..., "noteDetails": [{"type":
#    "synced-plugin-shadowed", "related": "kenaido@agentic-bytes"}]}`, see
#    `.work/sprint-25/r-lane-h.md`, "Findings"). The reply is read with
#    `awk`, not Python: on Windows, `python3` is often only the Microsoft
#    Store's placeholder, which is found on PATH but runs nothing, and that
#    silently hid this warning in a live test (2026-09-25). The call is
#    stopped after 5 seconds. This says nothing when `claude` is missing,
#    fails, is too slow, or the reply doesn't match, rather than guess
#    (`ETH-8`).
# 3. **The rules index,** when the project hasn't installed kenaido's rules
#    yet: their short index and how to install them. Once /kenaido:setup has
#    run, Claude Code loads the rules themselves from .claude/rules/kenaido/,
#    so this adds nothing.
#
# All three answers go out as ONE JSON object, because Claude Code parses
# stdout once: the warning(s) are put in front of the index's own fields.
#
# The warning names no path: a Windows path carries backslashes, which would
# need escaping to stay valid JSON, and the person needs the fix, not the
# path. For the same reason, neither warning uses a double quote, a
# backslash, or a backtick: this script builds its JSON with plain `printf`,
# not a JSON encoder, so those characters would break the output.

root="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"

problem=
if ! command -v git >/dev/null 2>&1; then
  problem="git was not found, so it cannot tell which branch is checked out. Install git, or put it on PATH, and start a new session."
fi
if [ ! -r "$root/hooks/no-main-edit.sh" ]; then
  problem="its script, hooks/no-main-edit.sh, is missing from the kenaido plugin. Update or reinstall the plugin (/plugin), then start a new session."
fi

# SECOND-COPY-AT-SESSION-START (#384): only runs when it can check for real.
synced_warning=
manifest="$root/.claude-plugin/plugin.json"
name=
[ -r "$manifest" ] && name=$(sed -n \
  's/^[[:space:]]*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  "$manifest" | head -n 1)
if [ -n "$name" ] && command -v claude >/dev/null 2>&1 \
  && list=$(mktemp 2>/dev/null); then
  # Run the list in the background and stop it after 5 seconds, so a slow
  # or stuck `claude` never holds up the session. The watchdog writes
  # nothing to this hook's output, so it cannot keep the output open.
  claude plugin list --json >"$list" 2>/dev/null </dev/null &
  list_pid=$!
  (sleep 5 && kill "$list_pid") >/dev/null 2>&1 </dev/null &
  watchdog_pid=$!
  # dash reports a job the watchdog killed ("Terminated") on stderr.
  if wait "$list_pid" 2>/dev/null; then
    # One entry at a time: walk the JSON outside its strings and drop the
    # spaces between tokens. For each top-level object of the array, keep
    # its own keys (depth 2) apart from the items of its own "noteDetails"
    # list (depth 4), so a match nested anywhere else never counts. Warn
    # only when the entry's own id is "<name>@synced" and one of its own
    # noteDetails items has the "synced-plugin-shadowed" type.
    if awk -v id="\"id\":\"$name@synced\"" \
      -v marker='"type":"synced-plugin-shadowed"' '
      function add(c) {
        if (depth == 2) top = top c
        else if (in_nd && depth == 4) nd = nd c
      }
      {
        n = length($0)
        for (i = 1; i <= n; i++) {
          c = substr($0, i, 1)
          if (instr) {
            if (esc) esc = 0
            else if (c == "\\") esc = 1
            else if (c == "\"") instr = 0
            add(c)
            continue
          }
          if (c == " " || c == "\t" || c == "\r") continue
          if (c == "\"") instr = 1
          if (c == "{" || c == "[") {
            if (depth == 2 && c == "[" \
              && substr(top, length(top) - 13) == "\"noteDetails\":") in_nd = 1
            depth++
            if (depth == 2) { top = ""; nd = "" }
          }
          add(c)
          if (c == "}" || c == "]") {
            if (depth == 3 && c == "]") in_nd = 0
            if (depth == 2 && index(top, id) && index(nd, marker)) found = 1
            depth--
          }
        }
      }
      END { exit found ? 0 : 1 }' "$list" 2>/dev/null; then
      synced_warning="a second copy of this plugin is synced to your claude.ai account, and was not loaded: Claude Code runs only the copy installed on this machine. To run the synced copy instead, disable the local install; to stop offering the synced one, remove or update it on claude.ai."
    fi
  fi
  kill "$watchdog_pid" 2>/dev/null
  rm -f "$list"
fi

warning=
messages=
if [ -n "$problem" ]; then
  messages="the guardrail that refuses edits, shell commands and MCP tool calls on main or master cannot run, so this session will NOT refuse them. Reason: $problem Until it is fixed, only your project's own git hooks, if it has any, stop a commit to main."
fi
if [ -n "$synced_warning" ]; then
  if [ -n "$messages" ]; then
    messages="$messages $synced_warning"
  else
    messages="$synced_warning"
  fi
fi
if [ -n "$messages" ]; then
  warning="kenaido warning: $messages"
fi

if [ -f "${CLAUDE_PROJECT_DIR:-.}/.claude/rules/kenaido/.kenaido" ]; then
  [ -n "$warning" ] && printf '{"systemMessage": "%s"}\n' "$warning"
  exit 0
fi

context="$root/hooks/session-start-context.json"
if [ ! -r "$context" ]; then
  # A plugin missing its index too: the warning alone, still valid JSON.
  [ -n "$warning" ] && printf '{"systemMessage": "%s"}\n' "$warning"
  exit 0
fi
if [ -n "$warning" ]; then
  # The context file is one JSON object on one line, starting with `{`:
  # open a new object with the warning, then continue with the file's fields.
  printf '{"systemMessage": "%s", ' "$warning"
  sed '1s/^{//' "$context"
else
  cat "$context"
fi
