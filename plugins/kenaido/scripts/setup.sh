#!/bin/sh
# kenaido setup: installs kenaido into a project, in two folders:
#   .claude/rules/kenaido/   the rules, which Claude Code loads at the start of
#                            every session
#   .claude/kenaido/         the rest of the pack the rules cite (toolbox,
#                            templates, guides, departments, skills), which
#                            nothing loads until an agent reads it
# It also adds a marked block to the project's .gitignore, ignoring kenaido's
# own working files (.work/), unless the project already ignores them on its
# own (#395); it touches nothing else in the project. Run by the plugin's
# /kenaido:setup skill. Only the rules go under .claude/rules/, because Claude
# Code loads every Markdown file there, in every folder, in every session.
#
# Usage: setup.sh <project folder>
set -eu

plugin_root=$(cd "$(dirname "$0")/.." && pwd)
project=${1:-}

if [ -z "$project" ] || [ ! -d "$project" ]; then
  echo "kenaido setup: project folder not found: '$project'. Nothing changed." >&2
  exit 1
fi

rules="$project/.claude/rules/kenaido"
pack="$project/.claude/kenaido"
src="$plugin_root/install"
gitignore="$project/.gitignore"
gitignore_pattern='/.work/'
gitignore_begin='# kenaido:gitignore-begin'
gitignore_end='# kenaido:gitignore-end'

if [ ! -d "$src/.claude/rules/kenaido" ] || [ ! -d "$src/.claude/kenaido" ]; then
  echo "kenaido setup: the plugin is incomplete ($src is missing). Nothing changed." >&2
  exit 1
fi

# Refuse a symbolic link on the way to either folder, or inside one, since it
# could lead a write or a delete outside the project. Checked before any change.
for d in "$project/.claude" "$project/.claude/rules" "$rules" "$pack" "$gitignore"; do
  if [ -L "$d" ]; then
    echo "kenaido setup: $d is a symbolic link, which could lead outside the project. Nothing changed." >&2
    exit 1
  fi
done

# The gitignore markers must be absent, or exactly one begin followed by one
# end; anything else and kenaido doesn't touch the file (#464): a lone begin
# marker, with no matching end, is not kenaido's block to add to.
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
# a marked block, so it can be told apart from a rule the project already
# had. Skipped if the project already ignores .work/ on its own, if kenaido's
# block is already there, or if the markers are broken (#464). Setup has no
# automated removal (see below), so this is added but not taken back out.
add_gitignore() {
  if [ -f "$gitignore" ] && grep -qxF "$gitignore_begin" "$gitignore"; then
    if gitignore_markers_ok; then
      return 0
    fi
    echo "kenaido setup: the kenaido:gitignore markers in $gitignore are broken (not exactly one begin before one end). Left as is; fix or remove them by hand." >&2
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
for dest in "$rules" "$pack"; do
  if [ -d "$dest" ] && [ -n "$(find "$dest" -type l | head -n 1)" ]; then
    echo "kenaido setup: $dest holds a symbolic link, which could lead outside the project. Nothing changed." >&2
    exit 1
  fi
done

# Refuse a folder kenaido didn't create rather than overwrite someone else's
# files. Both folders are checked before either is written.
for dest in "$rules" "$pack"; do
  if [ -d "$dest" ] && [ ! -f "$dest/.kenaido" ] && [ -n "$(ls -A "$dest")" ]; then
    echo "kenaido setup: $dest exists and wasn't created by kenaido. Nothing changed." >&2
    exit 1
  fi
done

# An update replaces kenaido's own files; both folders are kenaido's alone.
if [ -f "$rules/.kenaido" ]; then
  rm -f "$rules"/*.md
fi
if [ -f "$pack/.kenaido" ]; then
  rm -rf "$pack"
fi

mkdir -p "$rules" "$pack"
count=0
for f in "$src"/.claude/rules/kenaido/*.md; do
  cp "$f" "$rules/"
  count=$((count + 1))
done
cp -R "$src"/.claude/kenaido/. "$pack/"
files=$(find "$pack" -type f | wc -l | tr -d ' ')

# The license and its notice travel with the files, so every copy says what
# it is licensed under.
for name in LICENSE NOTICE; do
  if [ -f "$plugin_root/$name" ]; then
    cp "$plugin_root/$name" "$rules/$name"
    cp "$plugin_root/$name" "$pack/$name"
  fi
done
# The disclaimer goes only beside the pack: every Markdown file under
# .claude/rules/ loads as a rule in every session.
if [ -f "$plugin_root/DISCLAIMER.md" ]; then
  cp "$plugin_root/DISCLAIMER.md" "$pack/DISCLAIMER.md"
fi

version=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$plugin_root/.claude-plugin/plugin.json" | head -n 1)
printf 'kenaido %s\n' "$version" > "$rules/.kenaido"
printf 'kenaido %s\n' "$version" > "$pack/.kenaido"
add_gitignore

echo "kenaido: installed $count rule files (version $version) into .claude/rules/kenaido/,"
echo "and the rest of the pack ($files files) into .claude/kenaido/."
echo "The rules load at the start of every Claude Code session. Start a new session to use them."
echo "kenaido ignores its own working files (.work/) in $project/.gitignore, unless the project"
echo "already ignores them on its own."
echo "To remove them, delete the .claude/rules/kenaido/ and .claude/kenaido/ folders, and the"
echo "kenaido:gitignore-begin/end block in .gitignore if you added it and no longer need it."
echo "kenaido's agents are AI models playing roles, not people, and a group of them is not a real Scrum Team. Their output varies with the model; check it, and keep people accountable. See DISCLAIMER.md."
