#!/bin/sh
# kenaido for Google Antigravity: installs kenaido's plugin into a project's
# workspace plugins folder, where Antigravity loads it "only when working in
# that project" (https://antigravity.google/docs/plugins.md, "Manual plugin
# installation", read 2026-09-21):
#   .agents/plugins/kenaido/plugin.json        the manifest
#   .agents/plugins/kenaido/rules/kenaido.md   the index rule
#   .agents/plugins/kenaido/agents/            the role agents
#   .agents/plugins/kenaido/skills/            the skills
#   .agents/plugins/kenaido/hooks.json         the guardrail and its self-test
#   .agents/plugins/kenaido/pack/              the rules in full and the rest of
#                                              the pack, read on demand
# plus the license, the version, and the list of what it wrote. It never
# overwrites a file of the project's own, and writes nothing outside that
# folder.
#
# hooks.json has one `command` per hook and no Windows override, so this
# writes the commands for the system it runs on: POSIX, or PowerShell on
# Windows (Git Bash, MSYS2, Cygwin). --windows or --posix chooses by hand.
#
# Usage:
#   sh install.sh [--windows|--posix] <project folder>   install, or update after a new release
#   sh install.sh --remove <project folder>              remove what it installed
set -eu

pkg=$(cd "$(dirname "$0")" && pwd)
mode=install
system=
while [ $# -gt 0 ]; do
  case "$1" in
    --remove) mode=remove; shift ;;
    --windows) system=windows; shift ;;
    --posix) system=posix; shift ;;
    *) break ;;
  esac
done
project=${1:-}
if [ -z "$project" ] || [ ! -d "$project" ]; then
  echo "kenaido: project folder not found: '$project'. Nothing changed." >&2
  exit 1
fi
project=$(cd "$project" && pwd)
if [ "$project" = "$pkg" ]; then
  echo "kenaido: that is the package itself, not a project. Nothing changed." >&2
  exit 1
fi
if [ -z "$system" ]; then
  case "$(uname -s 2>/dev/null)" in
    MINGW*|MSYS*|CYGWIN*) system=windows ;;
    *) system=posix ;;
  esac
fi

plugin_rel=.agents/plugins/kenaido
plugin="$project/$plugin_rel"
gitignore="$project/.gitignore"
for d in "$project/.agents" "$project/.agents/plugins" "$plugin" "$gitignore"; do
  if [ -L "$d" ]; then
    echo "kenaido: $d is a symbolic link. Nothing changed." >&2
    exit 1
  fi
done

list="$plugin/installed-files.txt"
gitignore_pattern='/.work/'
gitignore_begin='# kenaido:gitignore-begin'
gitignore_end='# kenaido:gitignore-end'

# The gitignore markers must be absent, or exactly one begin followed by one
# end; anything else and kenaido doesn't touch the file (#464): a lone begin
# marker, with no matching end, is not kenaido's block to add to or remove.
gitignore_markers_ok() {
  [ -f "$gitignore" ] || return 0
  nb=$(grep -cxF "$gitignore_begin" "$gitignore" || true)
  ne=$(grep -cxF "$gitignore_end" "$gitignore" || true)
  [ "$nb" -eq 0 ] && [ "$ne" -eq 0 ] && return 0
  [ "$nb" -eq 1 ] && [ "$ne" -eq 1 ] || return 1
  lb=$(grep -nxF "$gitignore_begin" "$gitignore" | cut -d: -f1)
  le=$(grep -nxF "$gitignore_end" "$gitignore" | cut -d: -f1)
  [ "$lb" -lt "$le" ]
}

# Ignores kenaido's own working files (.work/) in the project's .gitignore, in
# a marked block, so uninstall can remove only what kenaido added (#395).
# Skipped if the project already ignores .work/ on its own, if kenaido's
# block is already there, or if the markers are broken (#464).
add_gitignore() {
  if [ -f "$gitignore" ] && grep -qxF "$gitignore_begin" "$gitignore"; then
    if gitignore_markers_ok; then
      return 0
    fi
    echo "kenaido: the kenaido:gitignore markers in $gitignore are broken (not exactly one begin before one end). Left as is; fix or remove them by hand." >&2
    return 0
  fi
  if [ -f "$gitignore" ] && grep -qxF "$gitignore_pattern" "$gitignore"; then
    return 0
  fi
  if [ -f "$gitignore" ] && [ -s "$gitignore" ] && [ -n "$(tail -c1 "$gitignore")" ]; then
    printf '\n' >> "$gitignore"
  fi
  {
    printf '%s\n' "$gitignore_begin"
    printf '%s\n' "$gitignore_pattern"
    printf '%s\n' "$gitignore_end"
  } >> "$gitignore"
}

# Takes only kenaido's own marked block back out; a rule the project had on
# its own is left alone. Deletes the file if kenaido's block was all it held.
# Changes nothing if a begin marker is not followed by a matching end marker
# (#464): the block is found by both its markers, never by the begin alone.
remove_gitignore() {
  [ -f "$gitignore" ] || return 0
  grep -qxF "$gitignore_begin" "$gitignore" || return 0
  if ! gitignore_markers_ok; then
    echo "kenaido: the kenaido:gitignore markers in $gitignore are broken (not exactly one begin before one end). Left as is; fix or remove them by hand." >&2
    return 0
  fi
  tmp=$(mktemp)
  awk -v b="$gitignore_begin" -v e="$gitignore_end" '
    $0 == b { skip = 1; next }
    skip && $0 == e { skip = 0; next }
    skip { next }
    { print }
  ' "$gitignore" > "$tmp"
  if grep -q '[^[:space:]]' "$tmp"; then
    cat "$tmp" > "$gitignore"
  else
    rm -f "$gitignore"
  fi
  rm -f "$tmp"
}

# Only paths kenaido writes may ever be removed, whatever the list says.
is_ours() {
  case "$1" in
    *..*|/*) return 1 ;;
    "$plugin_rel"/*) return 0 ;;
    *) return 1 ;;
  esac
}

# A symbolic link anywhere on a path could lead a write or a delete outside the
# project, so every path kenaido would write or delete is checked, folder by
# folder, before anything changes. A path that crosses one is refused.
crosses_link() {
  here=$project
  rest=$1
  while [ -n "$rest" ]; do
    part=${rest%%/*}
    if [ "$part" = "$rest" ]; then rest=; else rest=${rest#*/}; fi
    here="$here/$part"
    [ -L "$here" ] && return 0
    [ -e "$here" ] || return 1
  done
  return 1
}

# Writes every path this run may write or delete, relative to the project: the
# record, what the record lists, and what the file list given as $1 (if any)
# would write.
touched() {
  printf '%s\n' "${list#"$project"/}"
  if [ -f "$list" ]; then
    while IFS= read -r f; do
      if is_ours "$f"; then printf '%s\n' "$f"; fi
    done < "$list"
  fi
  if [ -n "${1:-}" ]; then cat "$1"; fi
}

# Reads paths on standard input; stops the run, before any change, if one of
# them crosses a symbolic link. Called with a redirect, not a pipe, so its exit
# stops the script itself.
refuse_links() {
  linked=""
  while IFS= read -r f; do
    if crosses_link "$f"; then
      linked="$linked
  $f"
    fi
  done
  if [ -n "$linked" ]; then
    echo "kenaido: these paths go through a symbolic link, which could lead outside the project:$linked" >&2
    echo "Nothing changed. Replace the links with real folders, then run this again." >&2
    exit 1
  fi
}

remove_listed() {
  [ -f "$list" ] || return 0
  while IFS= read -r f; do
    if is_ours "$f"; then
      rm -f "$project/$f"
    fi
  done < "$list"
  rm -f "$list"
  # Folders left empty go too; rmdir never removes a folder that isn't empty.
  if [ -d "$plugin" ]; then
    find "$plugin" -depth -type d -exec rmdir {} \; 2>/dev/null || true
  fi
  rmdir "$project/.agents/plugins" 2>/dev/null || true
  rmdir "$project/.agents" 2>/dev/null || true
}

checks=$(mktemp)
trap 'rm -f "$checks"' EXIT

if [ "$mode" = remove ]; then
  if [ ! -f "$list" ]; then
    echo "kenaido: not installed in $project. Nothing changed."
    exit 0
  fi
  touched > "$checks"
  refuse_links < "$checks"
  remove_listed
  remove_gitignore
  echo "kenaido: removed from $project. The project's own files are untouched."
  exit 0
fi

new_list=$(mktemp)
trap 'rm -f "$new_list" "$checks"' EXIT
(cd "$pkg/files" && find . -type f | sed 's|^\./||' | sort) > "$new_list"

touched "$new_list" > "$checks"
(cd "$pkg/files" && find . -type d | sed 's|^\./||') >> "$checks"
refuse_links < "$checks"

# Refuse, before writing anything, if a file kenaido would write already
# exists and isn't one kenaido wrote.
conflicts=""
while IFS= read -r f; do
  if [ -e "$project/$f" ] && ! { [ -f "$list" ] && grep -qxF "$f" "$list"; }; then
    conflicts="$conflicts
  $f"
  fi
done < "$new_list"
if [ -n "$conflicts" ]; then
  echo "kenaido: these files already exist and weren't installed by kenaido:$conflicts" >&2
  echo "Nothing changed. Rename or remove them, then run this again." >&2
  exit 1
fi

remove_listed
(cd "$pkg/files" && find . -type d | sed 's|^\./||' | while IFS= read -r d; do mkdir -p "$project/$d"; done)
while IFS= read -r f; do
  cp "$pkg/files/$f" "$project/$f"
done < "$new_list"
if [ "$system" = windows ]; then
  cp "$pkg/hooks.windows.json" "$plugin/hooks.json"
fi
cp "$new_list" "$list"
add_gitignore

version=$(cat "$plugin/VERSION" 2>/dev/null || echo unknown)
count_rules=$(grep "^$plugin_rel/pack/rules/" "$list" | grep -vc '/README\.md$' || true)
count_pack=$(grep -c "^$plugin_rel/pack/" "$list" || true)
count_agents=$(grep -c "^$plugin_rel/agents/kenaido-" "$list" || true)
count_skills=$(grep "^$plugin_rel/skills/" "$list" | cut -d/ -f5 | sort -u | wc -l | tr -d ' ')
echo "kenaido $version: installed the Antigravity plugin into $project/$plugin_rel/:"
echo "$count_rules rules, $count_agents agents, and $count_skills skills; the whole pack ($count_pack files) is in pack/."
echo "Its one rule, rules/kenaido.md, indexes the rules; the agent reads each one when it applies."
echo "The guardrail (hooks.json, $system commands) refuses edits, most shell commands, and unknown"
echo "and MCP tools while main or master is checked out. If it cannot run, it hands each call to"
echo "you with a warning. Check that Antigravity lists the plugin (Customizations, or agy plugin list)."
echo "Commit $plugin_rel/ if your team should share it; on another system, run this again there."
echo "kenaido ignores its own working files (.work/) in $project/.gitignore, unless the project"
echo "already ignores them on its own; --remove takes that line back out."
echo "To remove: sh $pkg/install.sh --remove $project"
echo "kenaido's agents are AI models playing roles, not people, and a group of them is not a real Scrum Team. Their output varies with the model; check it, and keep people accountable. See DISCLAIMER.md."
