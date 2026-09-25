#!/bin/sh
# kenaido's new-sprint script: starts a Sprint's folder with all five of its
# records at once (`SCRUM-9`), so no Sprint ever starts with only some of them.
#
#   sh <kenaido folder>/scripts/new-sprint.sh <N>     start Sprint N
#   sh <kenaido folder>/scripts/new-sprint.sh --check list Sprint folders that
#                                                     are missing a record
#
# Run it from anywhere inside the project: it finds the project with git, and
# the templates in the `templates/` folder beside its own. It creates
# `project/sprints/sprint-<NN>/`, its `tasks/` folder, and `planning.md`,
# `sprint-backlog.md`, `daily.md`, `review.md` and `retrospective.md`, each
# from the first block of its template, "not held yet". It also writes the
# Sprint's state file, `.work/sprint-<NN>/STATUS.md` (`CONT-9`), but only when
# git ignores `.work/` here; otherwise it says so, and writes nothing there.
#
# **It never writes to a file that already exists.** Every write refuses an
# existing file (the shell's noclobber option), so running it twice, or on a
# folder whose records already hold text, changes nothing that is there: it
# creates only what is missing and reports the rest as kept. It commits
# nothing: commit the new files on a work branch, as for any change.
#
# `sprint-00/`, which holds work from before Scrum started (`CONT-3`), is not
# a Sprint, and `--check` does not look at it.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
templates="$here/../templates"
RECORDS="planning sprint-backlog daily review retrospective"

say() { printf '%s\n' "$*"; }
refuse() { printf 'new-sprint: %s\n' "$*" >&2; exit 1; }

root=$(git rev-parse --show-toplevel 2>/dev/null) ||
  refuse "not inside a git repository; run it from inside the project."
sprints="$root/project/sprints"

# The number of records a Sprint folder holds, of the five.
count_records() {
  c=0
  for r in $RECORDS; do
    if [ -f "$1/$r.md" ]; then c=$((c + 1)); fi
  done
  echo "$c"
}

if [ "${1:-}" = "--check" ]; then
  short=0
  for d in "$sprints"/sprint-[0-9]*; do
    [ -d "$d" ] || continue
    case "${d##*/}" in sprint-00) continue ;; esac
    c=$(count_records "$d")
    if [ "$c" -lt 5 ]; then
      say "short: ${d#"$root"/} holds $c of the five records; run: sh $0 ${d##*/sprint-}"
      short=$((short + 1))
    fi
  done
  if [ "$short" -gt 0 ]; then
    say "new-sprint --check: $short Sprint folder(s) missing a record."
    exit 1
  fi
  say "new-sprint --check: every Sprint folder holds its five records."
  exit 0
fi

case "${1:-}" in
  ''|*[!0-9]*) refuse "usage: sh $0 <Sprint number>, or sh $0 --check" ;;
esac
# A whole number, read as decimal whatever its leading zeros.
n=$(printf '%s' "$1" | sed 's/^0*//')
[ -n "$n" ] || refuse "Sprint numbers start at 1; sprint-00 holds work from before Scrum started (CONT-3)."
nn=$(printf '%02d' "$n")

for r in $RECORDS state-file; do
  [ -f "$templates/$r.md" ] || refuse "template missing: $templates/$r.md; install kenaido's package again."
done

# first_block TEMPLATE: the template's first ```markdown block, with the
# Sprint number put in.
first_block() {
  awk '/^```markdown[[:space:]]*$/ { if (!seen) { inside = 1; seen = 1; next } }
       inside && /^```[[:space:]]*$/ { exit }
       inside { print }' "$1" | sed -e "s/<NN>/$nn/g" -e "s/<N>/$n/g"
}

created=0 kept=0 notwritten=0
# write_new FILE TEMPLATE: writes the block into FILE only if FILE does not
# exist. noclobber (set -C) makes the shell itself refuse an existing file,
# so a file that appears between the test and the write is still not touched.
write_new() {
  if [ -e "$1" ] || [ -L "$1" ]; then
    say "kept:        ${1#"$root"/} (already there; not touched)"
    kept=$((kept + 1))
    return 0
  fi
  block=$(first_block "$2")
  [ -n "$block" ] || refuse "no starting block in $2"
  if (set -C; printf '%s\n' "$block" > "$1") 2>/dev/null; then
    say "created:     ${1#"$root"/}"
    created=$((created + 1))
  else
    say "kept:        ${1#"$root"/} (appeared while running; not touched)"
    kept=$((kept + 1))
  fi
}

dir="$sprints/sprint-$nn"
if [ "$n" -gt 1 ]; then
  prev="$sprints/sprint-$(printf '%02d' $((n - 1)))"
  if [ ! -d "$prev" ]; then
    say "warning:     no ${prev#"$root"/}; starting Sprint $n anyway."
  elif [ "$(count_records "$prev")" -lt 5 ]; then
    say "warning:     ${prev#"$root"/} holds $(count_records "$prev") of the five records; run: sh $0 $((n - 1))"
  fi
fi

mkdir -p "$dir/tasks"
for r in $RECORDS; do
  write_new "$dir/$r.md" "$templates/$r.md"
done

state="$root/.work/sprint-$nn/STATUS.md"
if git -C "$root" check-ignore -q ".work/sprint-$nn/STATUS.md"; then
  mkdir -p "${state%/*}"
  write_new "$state" "$templates/state-file.md"
else
  say "not written: .work/sprint-$nn/STATUS.md, the state file: git does not ignore .work/ here. Add .work/ to .gitignore and run this again."
  notwritten=1
fi

have=$(count_records "$dir")
[ "$have" -eq 5 ] || refuse "Sprint $n's folder holds $have of the five records after this run; see the lines above."
say "new-sprint: Sprint $n: $created created, $kept kept, $notwritten not written. All five records are in ${dir#"$root"/}/."
say "Next: hold Sprint Planning and write it into these files. Nothing was committed."
