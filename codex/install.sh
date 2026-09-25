#!/bin/sh
# kenaido for Codex: installs kenaido's rules, role agents, and skills into a
# project, where Codex reads them:
#   AGENTS.md                         a kenaido block that INDEXES the rules;
#                                     the rest of that file is left alone
#   .codex/agents/kenaido-*.toml      the role agents, as Codex custom agents
#   .codex/kenaido/rules/             the rules, one file each, complete
#   .codex/kenaido/skills/            the skills, as files to read
#   .codex/kenaido/                   the rest of the pack (toolbox, templates,
#                                     guides, departments), the license, and
#                                     the list of what it wrote
# It never overwrites a file of the project's own.
#
# Why AGENTS.md holds an index and not the rules: Codex caps the instruction
# chain at about 32 KiB and kenaido's rules are far larger, so a full block
# would be truncated with no error. The block names each rule and where to
# read it (project/notes/findings.md, 2026-09-16).
#
# Usage:
#   sh install.sh <project folder>            install, or update after a new release
#   sh install.sh --remove <project folder>   remove what it installed
set -eu

pkg=$(cd "$(dirname "$0")" && pwd)
mode=install
if [ "${1:-}" = "--remove" ]; then
  mode=remove
  shift
fi
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
gitignore="$project/.gitignore"
for d in "$project/.codex" "$project/.codex/agents" "$project/.codex/kenaido" "$project/AGENTS.md" "$gitignore"; do
  if [ -L "$d" ]; then
    echo "kenaido: $d is a symbolic link. Nothing changed." >&2
    exit 1
  fi
done

list="$project/.codex/kenaido/installed-files.txt"
ci="$project/AGENTS.md"
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
begin='<!-- kenaido:begin -->'
end='<!-- kenaido:end -->'

# The block's markers in AGENTS.md must be absent, or exactly one
# begin followed by one end; anything else is refused before any write.
markers_ok() {
  [ -f "$ci" ] || return 0
  nb=$(grep -cxF "$begin" "$ci" || true)
  ne=$(grep -cxF "$end" "$ci" || true)
  [ "$nb" -eq 0 ] && [ "$ne" -eq 0 ] && return 0
  [ "$nb" -eq 1 ] && [ "$ne" -eq 1 ] || return 1
  lb=$(grep -nxF "$begin" "$ci" | cut -d: -f1)
  le=$(grep -nxF "$end" "$ci" | cut -d: -f1)
  [ "$lb" -lt "$le" ]
}

# Take kenaido's block out of AGENTS.md, and delete the file if
# nothing of the project's own is left in it.
strip_block() {
  [ -f "$ci" ] || return 0
  tmp=$(mktemp)
  # Also drops the one blank line the installer puts before the block.
  awk -v b="$begin" -v e="$end" '
    skip { if ($0 == e) skip = 0; next }
    $0 == b { pend = 0; skip = 1; next }
    { if (pend) print ""; pend = 0 }
    $0 == "" { pend = 1; next }
    { print }
    END { if (pend) print "" }
  ' "$ci" > "$tmp"
  if grep -q '[^[:space:]]' "$tmp"; then
    cat "$tmp" > "$ci"
  else
    rm -f "$ci"
  fi
  rm -f "$tmp"
}

# Only paths kenaido writes may ever be removed, whatever the list says.
is_ours() {
  case "$1" in
    *..*|/*) return 1 ;;
    .codex/agents/kenaido-*.toml) return 0 ;;
    .codex/kenaido/*) return 0 ;;
    .codex/hooks.json) return 0 ;;
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
# record, the instructions file, what the record lists, and what the file list
# given as $1 (if any) would write.
touched() {
  printf '%s\n' "${list#"$project"/}" "${ci#"$project"/}"
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
  # kenaido's own folder is walked deepest first, whatever the pack holds.
  if [ -d "$project/.codex/kenaido" ]; then
    find "$project/.codex/kenaido" -depth -type d -exec rmdir {} \; 2>/dev/null || true
  fi
  rmdir "$project/.codex/agents" 2>/dev/null || true
  rmdir "$project/.codex" 2>/dev/null || true
  # AGENTS.md is the project's file; if kenaido's block was all it held, it is
  # left empty rather than deleted — removing a file we did not create is not
  # ours to do.
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
  if ! markers_ok; then
    echo "kenaido: the kenaido markers in $ci are broken. Nothing changed. Fix or remove them by hand." >&2
    exit 1
  fi
  strip_block
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
if ! markers_ok; then
  echo "kenaido: the kenaido markers in $ci are broken (only one of them, two blocks, or the end before the begin)." >&2
  echo "Nothing changed. Fix or remove them by hand, then run this again." >&2
  exit 1
fi
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
mkdir -p "$project/.codex/kenaido"
cp "$new_list" "$list"

# The rules block: replace kenaido's own block, keep everything else.
strip_block
if [ -f "$ci" ]; then
  printf '\n' >> "$ci"
  cat "$pkg/agents-block.md" >> "$ci"
else
  cp "$pkg/agents-block.md" "$ci"
fi
add_gitignore

version=$(sed -n 's/^kenaido-codex //p' "$pkg/.kenaido-codex-package" 2>/dev/null)
count_rules=$(grep '^\.codex/kenaido/rules/' "$list" | grep -vc '/README\.md$' || true)
count_pack=$(grep -c '^\.codex/kenaido/' "$list" || true)
count_agents=$(grep -c '^\.codex/agents/kenaido-' "$list" || true)
count_skills=$(grep '^\.codex/kenaido/skills/' "$list" | cut -d/ -f4 | sort -u | wc -l | tr -d ' ')
echo "kenaido $version: installed $count_rules rules, $count_agents agents, and $count_skills skills into $project/.codex/."
echo "The whole pack ($count_pack files, the rules and skills included) is in .codex/kenaido/."
echo "AGENTS.md now indexes the rules; Codex reads each one when it applies."
echo "The guardrail in .codex/hooks.json is installed but not active: in the Codex CLI,"
echo "run /hooks to review and trust its two hooks, the guardrail and the session-start"
echo "check that warns you when the guardrail cannot run. Trust them again after every"
echo "update. Trusting lets them run outside Codex's sandbox."
echo "Commit them if your team should share them."
echo "kenaido ignores its own working files (.work/) in $project/.gitignore, unless the project"
echo "already ignores them on its own; --remove takes that line back out."
echo "To remove: sh $pkg/install.sh --remove $project"
echo "kenaido's agents are AI models playing roles, not people, and a group of them is not a real Scrum Team. Their output varies with the model; check it, and keep people accountable. See DISCLAIMER.md."
