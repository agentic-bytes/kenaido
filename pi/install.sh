#!/bin/sh
# kenaido for pi: installs kenaido's rules, roles, and skills into a project,
# where pi reads them:
#   the context file pi reads         a kenaido block that INDEXES the rules;
#                                     the rest of that file is left alone
#   .pi/prompts/kenaido-*.md          the roles, as prompt templates
#                                     (/kenaido-<role> <task>)
#   .pi/skills/kenaido-*/             the skills
#   .pi/kenaido/roles/                the roles, complete
#   .pi/kenaido/rules/                the rules, one file each, complete
#   .pi/extensions/kenaido-guard/     the guardrail, a pi extension that refuses
#                                     edits and writing commands on main
#   .pi/kenaido/                      the rest of the pack (toolbox, templates,
#                                     guides, departments), the license, the
#                                     version, and the list of what it wrote
# It never overwrites a file of the project's own.
#
# Which context file: pi reads, in each folder, only the FIRST that exists of
# AGENTS.override.md, AGENTS.md, AGENTS.MD, CLAUDE.md, CLAUDE.MD (pi 0.87.0,
# src/core/resource-loader.ts). So the block goes into the one pi already
# reads in the project root, and AGENTS.md is created only when none exists:
# creating AGENTS.md beside a CLAUDE.md would make pi stop reading it.
#
# Why the block holds an index and not the rules: pi sends it with every
# request, and kenaido's rules are over 80 KiB.
#
# The guardrail is a pi extension: pi runs it with the person's full system
# permissions, as every extension, and loads it only once the project is
# trusted. What it refuses and cannot catch is in the message at the end.
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
# pi's context files, in the order pi reads them; the first that exists wins.
CONTEXT_FILES="AGENTS.override.md AGENTS.md AGENTS.MD CLAUDE.md CLAUDE.MD"
for d in "$project/.pi" "$project/.pi/prompts" "$project/.pi/skills" "$project/.pi/kenaido" \
    "$project/.pi/extensions" "$project/.pi/extensions/kenaido-guard"; do
  if [ -L "$d" ]; then
    echo "kenaido: $d is a symbolic link. Nothing changed." >&2
    exit 1
  fi
done

for c in $CONTEXT_FILES; do
  if [ -L "$project/$c" ]; then
    echo "kenaido: $project/$c is a symbolic link. Nothing changed." >&2
    exit 1
  fi
done
gitignore="$project/.gitignore"
if [ -L "$gitignore" ]; then
  echo "kenaido: $gitignore is a symbolic link. Nothing changed." >&2
  exit 1
fi

list="$project/.pi/kenaido/installed-files.txt"
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

# The context file pi reads in the project root: the first that exists, or
# AGENTS.md when none does. On a file system that ignores case, AGENTS.md and
# AGENTS.MD are one file, and the first name found is used.
reads_now() {
  for c in $CONTEXT_FILES; do
    if [ -f "$project/$c" ]; then printf '%s\n' "$c"; return 0; fi
  done
  return 1
}
begin='<!-- kenaido:begin -->'
end='<!-- kenaido:end -->'

# The block's markers in the file $ci must be absent, or exactly one
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

# Take kenaido's block out of the file $ci, and delete the file if
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

# Every context file, checked or stripped in turn: a block may sit in any of
# them, for example if the project added an AGENTS.md after an install.
all_markers_ok() {
  for c in $CONTEXT_FILES; do
    ci="$project/$c"
    markers_ok || { bad_file=$ci; return 1; }
  done
  return 0
}
strip_all_blocks() {
  for c in $CONTEXT_FILES; do
    ci="$project/$c"
    strip_block
  done
}

# Only paths kenaido writes may ever be removed, whatever the list says.
is_ours() {
  case "$1" in
    *..*|/*) return 1 ;;
    .pi/prompts/kenaido-*.md) return 0 ;;
    .pi/skills/kenaido-*/*) return 0 ;;
    .pi/kenaido/*) return 0 ;;
    .pi/extensions/kenaido-guard/*) return 0 ;;
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
  printf '%s\n' "${list#"$project"/}"
  for c in $CONTEXT_FILES; do printf '%s\n' "$c"; done
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
  for d in "$project/.pi/kenaido" "$project/.pi/skills" "$project/.pi/extensions"; do
    if [ -d "$d" ]; then
      find "$d" -depth -type d -exec rmdir {} \; 2>/dev/null || true
    fi
  done
  rmdir "$project/.pi/prompts" 2>/dev/null || true
  rmdir "$project/.pi" 2>/dev/null || true
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
  if ! all_markers_ok; then
    echo "kenaido: the kenaido markers in $bad_file are broken. Nothing changed. Fix or remove them by hand." >&2
    exit 1
  fi
  listed=0
  while IFS= read -r f; do
    if is_ours "$f" && [ -f "$project/$f" ]; then listed=$((listed + 1)); fi
  done < "$list"
  blocks=""
  for c in $CONTEXT_FILES; do
    if [ -f "$project/$c" ] && grep -qxF "$begin" "$project/$c"; then blocks="$blocks $c"; fi
  done
  strip_all_blocks
  remove_listed
  remove_gitignore
  echo "kenaido: removed $listed file(s) it had installed from $project."
  if [ -n "$blocks" ]; then
    for c in $blocks; do
      if [ -f "$project/$c" ]; then
        echo "kenaido: took its block out of $c; the rest of that file is as it was."
      else
        echo "kenaido: deleted $c, which held only kenaido's block."
      fi
    done
  else
    echo "kenaido: no kenaido block was found in a context file."
  fi
  left=$(find "$project/.pi" -type f 2>/dev/null | wc -l | tr -d ' ')
  if [ "$left" -gt 0 ]; then
    echo "kenaido: $left file(s) of the project's own are still in .pi/, untouched."
  fi
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
if ! all_markers_ok; then
  echo "kenaido: the kenaido markers in $bad_file are broken (only one of them, two blocks, or the end before the begin)." >&2
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
mkdir -p "$project/.pi/kenaido"
cp "$new_list" "$list"

# The rules block: take kenaido's block out of every context file, then put
# it into the one pi reads. A file the block alone made is gone by then, so
# the choice falls on the project's own file, or on a new AGENTS.md.
strip_all_blocks
target=$(reads_now || printf 'AGENTS.md\n')
ci="$project/$target"
if [ -f "$ci" ]; then
  printf '\n' >> "$ci"
  cat "$pkg/agents-block.md" >> "$ci"
else
  cp "$pkg/agents-block.md" "$ci"
fi
add_gitignore

version=$(sed -n 's/^kenaido-pi //p' "$pkg/.kenaido-pi-package" 2>/dev/null)
count_rules=$(grep '^\.pi/kenaido/rules/' "$list" | grep -vc '/README\.md$' || true)
count_pack=$(grep -c '^\.pi/kenaido/' "$list" || true)
count_roles=$(grep -c '^\.pi/prompts/kenaido-' "$list" || true)
count_skills=$(grep '^\.pi/skills/' "$list" | cut -d/ -f3 | sort -u | wc -l | tr -d ' ')
echo "kenaido $version: installed $count_rules rules, $count_roles roles, and $count_skills skills into $project/.pi/."
echo "The whole pack ($count_pack files, the rules and complete roles included) is in .pi/kenaido/."
echo "$target now indexes the rules; pi sends it with every request, and the rules are read when they apply."
echo "Other tools that read $target see the block too."
echo "pi loads the roles and skills only after you trust this project: start pi in"
echo "$project and accept its trust prompt, or run /trust. Then call a role as"
echo "/kenaido-<role> <task>, for example /kenaido-architect, and a skill as /skill:kenaido-<name>."
echo "The guardrail is in .pi/extensions/kenaido-guard/. Once the project is trusted, on main or"
echo "master it refuses pi's edit and write tools, bash and powershell commands that can change"
echo "files (read-only ones such as git status, and git switch -c, still run), tools other"
echo "extensions added, and your own ! commands that can change files. Observed in pi 0.87.0"
echo "on Windows, 2026-09-22: it refused an edit and a writing command on main, and nothing"
echo "was written. Not yet observed on macOS or Linux, other pi versions, or your own ! command."
echo "pi loads every folder in .pi/extensions/, so renaming the guardrail's folder there does"
echo "not turn it off; moving it out of .pi/extensions/ does."
echo "It cannot catch: tools another extension overrides under a built-in name, anything"
echo "before you trust the project, and your own terminal. pi runs every extension, this one"
echo "included, with your full system permissions. To refuse commits and pushes on main in"
echo "git itself, whatever made them, run: sh $pkg/install-git-hooks.sh $project"
echo "kenaido ignores its own working files (.work/) in $project/.gitignore, unless the project"
echo "already ignores them on its own; --remove takes that line back out."
echo "To remove: sh $pkg/install.sh --remove $project"
echo "kenaido's agents are AI models playing roles, not people, and a group of them is not a real Scrum Team. Their output varies with the model; check it, and keep people accountable. See DISCLAIMER.md."
