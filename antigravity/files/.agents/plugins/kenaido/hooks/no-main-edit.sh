#!/bin/sh
# kenaido's PreToolUse guardrail for Google Antigravity, POSIX side. The
# Windows side is no-main-edit.ps1; the installer puts the command for the
# person's system into hooks.json, since Antigravity's hooks.json has one
# `command` and no Windows override (docs/hooks, "Hook Handler Configuration",
# read 2026-09-21).
#
# While a protected branch is checked out (`GIT-1`, `GIT-3`), it refuses file
# edits, lets shell commands through only when they cannot change files
# (decision 0087), and refuses every tool it does not know. It says why, so
# the agent cuts a work branch instead of failing blind.
#
# What it reads (https://antigravity.google/docs/hooks.md, "Supported Tools"
# and "PreToolUse", read 2026-09-21): the hook's JSON on stdin, with the tool
# in `toolCall.name` and its arguments in `toolCall.args`, and the workspace
# folders in `workspacePaths`. The file tools name their file in
# `TargetFile`; `run_command` carries `CommandLine` and `Cwd`.
#
# **Why every tool reaches it, and unknown ones are refused.** The hooks page
# lists no MCP tool name and no MCP prefix, so no matcher can pick MCP calls
# out. hooks.json matches every tool (`*`), and this script lets through only
# the tools it knows cannot change anything; any other name, MCP tools
# included, is refused on main (decision 0087, point 7: refuse, never guess).
#
# **Which repository.** Every place the call names is checked: the folder of
# `TargetFile`, `Cwd`, and each workspace folder. If any of them is on main
# or master, the call is checked as on main. A path this script cannot read
# without a JSON parser (one holding an escape) is skipped, and the workspace
# folders still decide.
#
# Refusing: `{"decision": "deny", "reason": ...}` on stdout, flat, which
# Antigravity documents as "Hard blocks execution immediately". With nothing
# to object to, it prints nothing: Antigravity documents no neutral decision,
# and `allow` would skip the person's own permission settings.
#
# **Fail-open by design** when it cannot run (no git): the call is handed to
# the person with `ask` and a warning, since `reason` is the only text
# Antigravity shows from this hook, and it needs a decision beside it.
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


# kenaido_json_array_strings JSON KEY: prints each string of the array at
# KEY, one per line. Fails when KEY is missing or appears twice, when its
# value is not an array of strings, or when the array holds any escape.
kenaido_json_array_strings() {
  a_rest=${1#*\""$2"\":}
  [ "$a_rest" != "$1" ] || return 1
  case "$a_rest" in *\""$2"\":*) return 1 ;; esac
  case "$a_rest" in \[*) ;; *) return 1 ;; esac
  a_rest=${a_rest#\[}
  a_list=${a_rest%%\]*}
  [ "$a_list" != "$a_rest" ] || return 1
  case "$a_list" in *\\*) return 1 ;; esac
  while :; do
    a_list=${a_list#"${a_list%%[! ]*}"}
    [ -n "$a_list" ] || return 0
    case "$a_list" in \"*) ;; *) return 1 ;; esac
    a_list=${a_list#\"}
    case "$a_list" in *\"*) ;; *) return 1 ;; esac
    a_item=${a_list%%\"*}
    [ -z "$a_item" ] || printf '%s\n' "$a_item"
    a_list=${a_list#*\"}
    a_list=${a_list#"${a_list%%[! ]*}"}
    case "$a_list" in
      ,*) a_list=${a_list#,} ;;
      '') return 0 ;;
      *) return 1 ;;
    esac
  done
}

# The tools that cannot change anything (docs/hooks, "Supported Tools"): they
# pass on main. Every other tool is checked below.
kenaido_read_only_tool() {
  case "$1" in
    view_file|list_dir|find_by_name|grep_search|search_web|read_url_content|list_permissions|ask_question) return 0 ;;
    *) return 1 ;;
  esac
}

# The hook's JSON arrives as the first argument when the command in hooks.json
# has already read stdin to find this script (it can only be read once), and on
# stdin when this script is run directly, as the tests do.
input=${1-}
[ -n "$input" ] || input=$(cat 2>/dev/null || true)
flat=$(kenaido_flat_json "$input")
tool=$(kenaido_json_string "$flat" name) || tool=

# Without git this cannot tell the branch. A read-only tool goes through; any
# other call goes to the person, with the warning, never in silence (PBI-140).
if ! command -v git >/dev/null 2>&1; then
  kenaido_read_only_tool "$tool" && exit 0
  printf '%s\n' '{"decision": "ask", "reason": "kenaido warning: the guardrail cannot check this action, because git was not found. Edits, shell commands and MCP tool calls on main or master are NOT being refused, so you decide this one. Install git, or put it on PATH."}'
  exit 0
fi

workspaces=$(kenaido_json_array_strings "$flat" workspacePaths) || workspaces=
first_workspace=${workspaces%%
*}

# The places this call names, one per line: the nearest existing folder of the
# file it writes, the folder it runs in, and every workspace folder.
places=$(
  if target=$(kenaido_json_string "$flat" TargetFile) && [ -n "$target" ]; then
    case "$target" in /*) ;; *) target="${first_workspace:-.}/$target" ;; esac
    folder=$(dirname -- "$target")
    while [ ! -d "$folder" ]; do folder=$(dirname -- "$folder"); done
    printf '%s\n' "$folder"
  fi
  if run_in=$(kenaido_json_string "$flat" Cwd) && [ -n "$run_in" ]; then
    printf '%s\n' "$run_in"
  fi
  [ -z "$workspaces" ] || printf '%s\n' "$workspaces"
)
[ -n "$places" ] || places=$(pwd)

branch=
branch_place=
while IFS= read -r place; do
  [ -n "$place" ] || continue
  git -C "$place" rev-parse --git-dir >/dev/null 2>&1 || continue
  b=$(git -C "$place" rev-parse --abbrev-ref HEAD 2>/dev/null) || continue
  case "$b" in
    main|master) branch=$b; branch_place=$place; break ;;
    *)
      d=$(git -C "$place" symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
      d=${d#origin/}
      if [ -n "$d" ] && [ "$b" = "$d" ]; then branch=$b; branch_place=$place; break; fi ;;
  esac
done <<PLACES
$places
PLACES

[ -n "$branch" ] || exit 0

default_branch=$(git -C "$branch_place" symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
default_branch=${default_branch#origin/}
# With no origin remote at all (#385, a from-scratch project), there is
# nothing to fetch or switch from yet.
if git -C "$branch_place" remote get-url origin >/dev/null 2>&1; then
  WAY_OUT="Create a work branch first, from the latest origin/${default_branch:-main}:\n\n  git fetch origin\n  git switch --no-track -c <type>/<short-description> origin/${default_branch:-main}\n\nTypes: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
else
  WAY_OUT="Create a work branch first:\n\n  git switch --no-track -c <type>/<short-description>\n\nTypes: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
fi
EDIT_REASON="kenaido GIT-1: never change '$branch'. $WAY_OUT Then make this edit again on that branch."
SHELL_REASON="kenaido GIT-1: '$branch' is checked out, so this shell command was refused. On main or master only commands that cannot change files run, one at a time, in plain words: no quotes, variables, globs, pipes, redirects, && or ;. They are: git status, log, diff, show, branch (to list), rev-parse, remote -v, fetch, switch, checkout -b; ls, cat, pwd, head, tail, wc. $WAY_OUT Then run the command again on that branch."
MCP_REASON="kenaido GIT-1: '$branch' is checked out, so MCP tool calls are refused, read-only ones too, and so is every tool this guardrail does not know, since Antigravity does not document how MCP tools are named: on main or master the only job is to leave it. $WAY_OUT Then call the tool again on that branch."

deny() {
  printf '{"decision": "deny", "reason": "%s"}\n' "$1"
  exit 0
}

kenaido_read_only_tool "$tool" && exit 0
case "$tool" in
  write_to_file|replace_file_content|multi_replace_file_content) deny "$EDIT_REASON" ;;
  run_command)
    if shell_command=$(kenaido_json_string "$flat" CommandLine) && kenaido_shell_allowed "$shell_command"; then
      exit 0
    fi
    deny "$SHELL_REASON" ;;
esac
deny "$MCP_REASON"
