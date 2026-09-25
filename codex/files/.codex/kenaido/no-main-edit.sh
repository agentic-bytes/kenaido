#!/bin/sh
# kenaido's PreToolUse guardrail for Codex, POSIX side. The Windows side is
# no-main-edit.ps1, reached through `commandWindows` in hooks.json.
#
# While the project's protected branch is checked out (`GIT-1`, `GIT-3`), it
# refuses file edits, and it lets shell commands through only when they cannot
# change files (decision 0087). It says why, so the agent cuts a work branch
# instead of failing blind.
#
# The matcher in hooks.json decides which tools reach it; this script then
# decides by `tool_name` in the hook's JSON: `Bash` (shell commands and
# unified exec) carries its command in `tool_input.command`, which is checked
# against the allow-list below; any other tool is treated as an edit
# (https://learn.chatgpt.com/docs/hooks, "Tool coverage" and "PreToolUse",
# read 2026-09-21). On Windows, Codex runs `Bash` commands through
# PowerShell, so the allow-list uses only words that mean the same in both.
#
# **It takes the project from the hook's own input, not from its working
# directory.** Codex passes `cwd` in the JSON, and the live test of 2026-09-16
# showed the hook running from `C:\Windows\System32\...` rather than the
# project — so a script that trusts its own directory finds no repository,
# fails open, and never denies anything (`project/notes/findings.md`, F-CX5).
#
# **The command in hooks.json finds this script the same way,** from that same
# `cwd`, because a command that used a relative path or `git rev-parse` would
# itself be looking in System32 and would never find this file at all.
#
# Codex does not pass the branch, so git is asked, with `-C` so the answer is
# about the project rather than about wherever this process happens to be.
#
# Denying: JSON on stdout, nested under hookSpecificOutput — Codex's shape and
# Claude Code's, not Copilot's flat one.
#
# **Fail-open by design:** any problem at all lets the action through, so a
# guardrail can never break unrelated work. Stated in the install steps.
set -u
# Byte-wise character checks, whatever the person's locale.
LC_ALL=C
export LC_ALL

# >>> kenaido shell classifier (decision 0087; the same in every kenaido guard)
#
# On a protected branch, a shell command runs only when it is one of a short
# list of commands that cannot change files, or the ones needed to leave the
# branch. Anything the guard cannot read with certainty is refused, never
# guessed (fail-closed).

# kenaido_json_string JSON KEY: prints the raw text of the string at KEY. The
# JSON's whitespace around ':' must already be removed. Fails when KEY is
# missing or appears twice, when its value is not a string, or when the text
# holds any escape. With no escape, the first '"' after the value's opening
# quote is its closing quote, so the text printed is the whole value, exactly.
kenaido_json_string() {
  k_rest=${1#*\""$2"\":}
  [ "$k_rest" != "$1" ] || return 1
  case "$k_rest" in *\""$2"\":*) return 1 ;; esac
  case "$k_rest" in \"*) ;; *) return 1 ;; esac
  k_rest=${k_rest#\"}
  k_value=${k_rest%%\"*}
  case "$k_value" in *\\*) return 1 ;; esac
  printf '%s' "$k_value"
}

# kenaido_flat_json JSON: the same JSON on one line, with no whitespace around
# ':'. Inside a JSON string a '"' is always escaped, so only keys are touched,
# and a value this could alter holds an escape, which is refused anyway.
kenaido_flat_json() {
  printf '%s' "$1" | tr '\n\r\t' '   ' | sed 's/"[[:space:]]*:[[:space:]]*/":/g'
}

# kenaido_shell_allowed COMMAND: returns 0 when COMMAND may run on a protected
# branch, 1 otherwise.
kenaido_shell_allowed() {
  [ -n "$1" ] || return 1
  # Plain words only: letters, digits, space, and _ . / : = -. They mean the
  # same in bash, zsh, and PowerShell: no quote, escape, variable, glob, pipe,
  # redirect, chaining, subshell, comment, tab, or newline.
  case "$1" in
    *[!ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\ _./:=-]*) return 1 ;;
  esac
  k_ifs=$IFS
  IFS=' '
  set -f
  # shellcheck disable=SC2086 # split into words on purpose; every character is plain
  set -- $1
  set +f
  IFS=$k_ifs
  [ $# -ge 1 ] || return 1
  for k_word in "$@"; do
    case "$k_word" in =*) return 1 ;; esac # zsh expands =cmd to a path
  done
  case "$1" in
    ls|pwd|cat|head|tail|wc|Get-ChildItem|Get-Content|Get-Location) return 0 ;;
    git) shift ;;
    *) return 1 ;;
  esac
  # git must be followed by its subcommand: a global option such as -c can
  # run a program.
  [ $# -ge 1 ] || return 1
  k_sub=$1
  shift
  case "$k_sub" in
    status|rev-parse) return 0 ;;
    log|diff|show)
      # --output=<file> writes a file, and git accepts abbreviated long options.
      for k_word in "$@"; do
        case "$k_word" in --oneline) ;; --o*) return 1 ;; esac
      done
      return 0 ;;
    branch)
      for k_word in "$@"; do
        case "$k_word" in
          -a|-r|-v|-vv|-l|--all|--remotes|--verbose|--list|--show-current) ;;
          *) return 1 ;;
        esac
      done
      return 0 ;;
    remote)
      [ $# -eq 0 ] && return 0
      [ $# -eq 1 ] || return 1
      case "$1" in -v|--verbose) return 0 ;; esac
      return 1 ;;
    fetch)
      # No refspec (a ':' can write a local branch) and no URL.
      for k_word in "$@"; do
        case "$k_word" in
          --prune|-p|--all|--tags|--no-tags|-q|--quiet|-v|--verbose|--dry-run) ;;
          -*|*:*) return 1 ;;
        esac
      done
      return 0 ;;
    switch)
      # Never -C, --force-create, --discard-changes, --force, --merge, --orphan.
      k_names=0
      for k_word in "$@"; do
        case "$k_word" in
          -c|--create|--no-track|--track|-t|-q|--quiet|--detach|-d) ;;
          -) k_names=$((k_names + 1)) ;;
          -*) return 1 ;;
          *) k_names=$((k_names + 1)) ;;
        esac
      done
      [ "$k_names" -ge 1 ] && [ "$k_names" -le 2 ] ;;
    checkout)
      # Only to create a branch: every other form can overwrite files.
      k_names=0
      k_create=0
      for k_word in "$@"; do
        case "$k_word" in
          -b) k_create=$((k_create + 1)) ;;
          --no-track|--track|-t|-q|--quiet) ;;
          -*) return 1 ;;
          *) k_names=$((k_names + 1)) ;;
        esac
      done
      [ "$k_create" -eq 1 ] && [ "$k_names" -ge 1 ] && [ "$k_names" -le 2 ] ;;
    *) return 1 ;;
  esac
}
# <<< kenaido shell classifier


# The hook's JSON arrives as the first argument when the command in hooks.json
# has already read stdin to find this script (it can only be read once), and on
# stdin when this script is run directly, as the tests do.
input=${1-}
[ -n "$input" ] || input=$(cat 2>/dev/null || true)

# `cwd` out of the hook's JSON, **only when that reading is certain** (#244,
# the project owner's answer to Q4 in Sprint 20): the key `"cwd":` appears
# exactly once, and its value is a string that starts with '/' and holds no
# escape (`kenaido_json_string`). Codex sends one top-level `cwd` before
# `tool_input`: on the wire it is a `String` (openai/codex,
# codex-rs/hooks/src/schema.rs, `PreToolUseCommandInput`), filled from an
# internal `AbsolutePathBuf` (codex-rs/hooks/src/events/pre_tool_use.rs,
# `request.cwd.display().to_string()`), both read 2026-09-22. The string
# itself is still checked here, and key order is not a promise,
# and a tool's own arguments may carry a `cwd` too. So a second `"cwd":`, a
# value that is not such a string, or an escape makes the input ambiguous:
# the project then comes from this process's own directory, which Codex sets
# to the session's `cwd` (learn.chatgpt.com/docs/hooks, "Config shape", read
# 2026-09-22), and on main or master the action is refused, whatever it is,
# because the guard cannot be sure what it is judging. Missing, it is not
# ambiguous: the same directory is used, as before. The command in hooks.json
# reads `cwd` by the same rules.
flat=$(kenaido_flat_json "$input")
project=
ambiguous=
case "$flat" in
  *'"cwd":'*)
    if ! project=$(kenaido_json_string "$flat" cwd); then
      project=
      ambiguous=1
    fi
    case "$project" in /*) ;; *) project= ; ambiguous=1 ;; esac
    ;;
esac
[ -n "$project" ] || project=$(pwd)

# Without git this cannot tell the branch, so it lets the edit through — but
# never in silence (PBI-140): Codex shows `systemMessage` as a warning, and it
# carries no decision, so the edit still proceeds.
if ! command -v git >/dev/null 2>&1; then
  printf '%s\n' '{"systemMessage": "kenaido warning: the guardrail cannot check this action, because git was not found. Edits, shell commands and MCP tool calls on main or master are NOT being refused. Install git, or put it on PATH."}'
  exit 0
fi

git -C "$project" rev-parse --git-dir >/dev/null 2>&1 || exit 0
branch=$(git -C "$project" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
[ "$branch" = "HEAD" ] && exit 0

default_branch=$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
default_branch=${default_branch#origin/}
case "$branch" in
  main|master) ;;
  *) [ -n "$default_branch" ] && [ "$branch" = "$default_branch" ] || exit 0 ;;
esac

# With no origin remote at all (#385, a from-scratch project), there is
# nothing to fetch or switch from yet.
if git remote get-url origin >/dev/null 2>&1; then
  WAY_OUT="Create a work branch first, from the latest origin/${default_branch:-main}:\n\n  git fetch origin\n  git switch --no-track -c <type>/<short-description> origin/${default_branch:-main}\n\nTypes: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
else
  WAY_OUT="Create a work branch first:\n\n  git switch --no-track -c <type>/<short-description>\n\nTypes: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
fi
EDIT_REASON="kenaido GIT-1: never change '$branch'. $WAY_OUT Then make this edit again on that branch."
SHELL_REASON="kenaido GIT-1: '$branch' is checked out, so this shell command was refused. On main or master only commands that cannot change files run, one at a time, in plain words: no quotes, variables, globs, pipes, redirects, && or ;. They are: git status, log, diff, show, branch (to list), rev-parse, remote -v, fetch, switch, checkout -b; ls, cat, pwd, head, tail, wc. $WAY_OUT Then run the command again on that branch."
AMBIGUOUS_REASON="kenaido GIT-1: '$branch' is checked out, and this action's hook input names its folder (cwd) in a way the guard cannot read with certainty: more than once, or not as a plain absolute path. So it is refused. $WAY_OUT Then try again on that branch."
MCP_REASON="kenaido GIT-1: '$branch' is checked out, so MCP tool calls are refused, read-only ones too: on main or master the only job is to leave it. $WAY_OUT Then call the tool again on that branch."

deny() {
  cat <<JSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "$1"
  }
}
JSON
  exit 0
}

[ -z "$ambiguous" ] || deny "$AMBIGUOUS_REASON"

tool=$(kenaido_json_string "$flat" tool_name) || tool=
case "$tool" in
  Bash)
    if shell_command=$(kenaido_json_string "$flat" command) && kenaido_shell_allowed "$shell_command"; then
      exit 0
    fi
    deny "$SHELL_REASON" ;;
  mcp__*) deny "$MCP_REASON" ;;
  *) deny "$EDIT_REASON" ;;
esac
