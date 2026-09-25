#!/bin/sh
# kenaido's optional git hooks (#307, decision 0087). Opt-in: nothing installs
# them unless you run this script yourself.
#
# They are the floor under the agent guardrail: an agent tool's hook sees only
# the tool calls that tool shows it, but git runs these for every commit and
# push, whatever made them — an agent, a script, or a person.
#
#   pre-commit        refuses a commit while main, master, or origin's own
#                     default branch is checked out
#   pre-merge-commit  refuses a merge commit there too
#   pre-push          refuses a push that updates or deletes any of them
#   reference-transaction
#                     refuses any change to the local main, master, or
#                     origin's default branch, unless it moves to exactly
#                     what origin has (refs/remotes/origin/<name>): a
#                     fast-forward from origin, as `git pull --ff-only` does,
#                     still works; `git branch -f main`,
#                     `git update-ref refs/heads/main`, deleting main, and a
#                     commit made with --no-verify are refused, from any
#                     branch (decision 0087). Git runs it from version
#                     2.28.0; an older git ignores it, and this script says
#                     so.
#
# The protected branches are main, master, and, when this project has an
# origin remote with a known HEAD (`git symbolic-ref refs/remotes/origin/HEAD`),
# whatever origin's own default branch is named, even if it is neither main
# nor master. With no origin remote at all — a from-scratch, local-only
# project (#385) — these hooks still let you commit and create main or
# master locally; only the fast-forward-from-origin rule above needs an
# origin to enforce, so it does not apply until one exists. A project with
# no origin and a default branch named something other than main or master
# is not detected: it gets no extra protection until origin is set.
#
# It never replaces a hook that is already there: it skips it and says so. A
# hook it installed before (it carries the kenaido-git-hook line) is updated.
# If the project sets core.hooksPath, it installs nothing and says why. To turn
# a hook off, delete its file from the hooks folder this script prints.
#
# Usage: sh install-git-hooks.sh [project folder]   (default: this folder)
# On Windows, run it from Git Bash, which comes with Git for Windows; git runs
# these hooks with its own sh.
set -eu

project=${1:-.}
if ! cd "$project" 2>/dev/null; then
  echo "kenaido: cannot open the folder $project" >&2
  exit 1
fi
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "kenaido: $project is not a git repository; nothing installed" >&2
  exit 1
fi
if hooks_path=$(git config --get core.hooksPath); then
  echo "kenaido: this project keeps its hooks in its own folder ($hooks_path, set by core.hooksPath)." >&2
  echo "kenaido: nothing installed there. Add a check for main and master to those hooks instead." >&2
  exit 1
fi

hooks_dir=$(git rev-parse --git-path hooks)
mkdir -p "$hooks_dir"
MARK="# kenaido-git-hook"

# write_hook NAME: the hook's body comes on stdin.
write_hook() {
  target="$hooks_dir/$1"
  # A symlink counts as a hook already there, dangling or not: writing
  # through it would create or change a file outside the hooks folder.
  if [ -L "$target" ] || { [ -e "$target" ] && ! grep -q "^$MARK" "$target" 2>/dev/null; }; then
    echo "kenaido: $target already exists and is not kenaido's; left as it was." >&2
    skipped=$((skipped + 1))
    cat >/dev/null
    return 0
  fi
  cat >"$target"
  chmod +x "$target"
  echo "kenaido: installed $target"
}

skipped=0

write_hook pre-commit <<'HOOK'
#!/bin/sh
# kenaido-git-hook: refuses a commit while main, master, or the remote's own
# default branch is checked out (GIT-1, GIT-5). With no `origin` remote at
# all (#385, a from-scratch project), the work-branch instructions don't
# name origin, since there is nothing there yet to fetch or switch from.
# Delete this file to turn it off.
branch=$(git symbolic-ref --short -q HEAD) || exit 0
default_branch=$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
default_branch=${default_branch#origin/}
protected=0
case "$branch" in
  main|master) protected=1 ;;
  *) [ -n "$default_branch" ] && [ "$branch" = "$default_branch" ] && protected=1 ;;
esac
if [ "$protected" -eq 1 ]; then
  echo "kenaido GIT-1: committing on '$branch' is refused. Create a work branch first:" >&2
  if git remote get-url origin >/dev/null 2>&1; then
    echo "  git fetch origin" >&2
    echo "  git switch --no-track -c <type>/<short-description> origin/${default_branch:-main}" >&2
  else
    echo "  git switch --no-track -c <type>/<short-description>" >&2
  fi
  exit 1
fi
exit 0
HOOK

write_hook pre-merge-commit <<'HOOK'
#!/bin/sh
# kenaido-git-hook: refuses a merge commit while main, master, or the
# remote's own default branch is checked out (GIT-5). Delete this file to
# turn it off.
branch=$(git symbolic-ref --short -q HEAD) || exit 0
default_branch=$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
default_branch=${default_branch#origin/}
case "$branch" in
  main|master) ;;
  *) [ -n "$default_branch" ] && [ "$branch" = "$default_branch" ] || exit 0 ;;
esac
echo "kenaido GIT-5: merging into '$branch' is refused; main changes only through pull requests." >&2
exit 1
HOOK

write_hook pre-push <<'HOOK'
#!/bin/sh
# kenaido-git-hook: refuses a push that updates or deletes main, master, or
# origin's own default branch, on any remote (GIT-4, GIT-5). Delete this
# file to turn it off.
default_branch=$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
default_branch=${default_branch#origin/}
# git sends one line per ref: <local ref> <local oid> <remote ref> <remote oid>
while read -r _local_ref _local_oid remote_ref _remote_oid; do
  case "$remote_ref" in
    refs/heads/main|refs/heads/master) ;;
    *)
      [ -n "$default_branch" ] && [ "$remote_ref" = "refs/heads/$default_branch" ] || continue ;;
  esac
  echo "kenaido GIT-5: pushing to '${remote_ref#refs/heads/}' is refused; main changes only through pull requests." >&2
  exit 1
done
exit 0
HOOK

write_hook reference-transaction <<'HOOK'
#!/bin/sh
# kenaido-git-hook: refuses any change to the local main, master, or the
# remote's own default branch, unless it moves to exactly what origin has
# (GIT-1, GIT-5; decision 0087). A fast-forward from origin (git pull
# --ff-only) still works. With no `origin` remote at all (#385), there is
# nothing yet to protect against, so a from-scratch project may still create
# and move these branches locally; deleting one is still always refused.
# Delete this file to turn it off.
# git sends one line per ref: <old value> <new value> <ref name>, and stops
# the whole transaction when this exits non-zero in the "prepared" state.
if [ "${1-}" != prepared ]; then
  cat >/dev/null
  exit 0
fi
default_branch=$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null)
default_branch=${default_branch#origin/}
has_origin=0
git remote get-url origin >/dev/null 2>&1 && has_origin=1
while read -r _old new ref; do
  case "$ref" in
    refs/heads/main|refs/heads/master) ;;
    *)
      [ -n "$default_branch" ] && [ "$ref" = "refs/heads/$default_branch" ] || continue ;;
  esac
  name=${ref#refs/heads/}
  case "$new" in
    *[!0]*) ;;
    *) echo "kenaido GIT-5: deleting '$name' is refused." >&2
       exit 1 ;;
  esac
  if [ "$has_origin" -eq 0 ]; then
    continue
  fi
  upstream=$(git rev-parse -q --verify "refs/remotes/origin/$name^{commit}" 2>/dev/null) || upstream=
  if [ -z "$upstream" ] || [ "$new" != "$upstream" ]; then
    echo "kenaido GIT-5: '$name' may only move to what origin has (origin/$name); this change is refused. Work on a branch of your own instead." >&2
    exit 1
  fi
done
exit 0
HOOK

# Git runs reference-transaction from 2.28.0 (it first appears in githooks
# for v2.28.0); an older git never calls it.
git_major=$(git --version | sed -n 's/^git version \([0-9][0-9]*\)\.[0-9][0-9]*.*/\1/p')
git_minor=$(git --version | sed -n 's/^git version [0-9][0-9]*\.\([0-9][0-9]*\).*/\1/p')
if [ "${git_major:-0}" -lt 2 ] || { [ "${git_major:-0}" -eq 2 ] && [ "${git_minor:-0}" -lt 28 ]; }; then
  echo "kenaido: this git ($(git --version)) is older than 2.28.0 and never runs reference-transaction, so moving main without a commit is NOT refused. Update git." >&2
fi

if [ "$skipped" -gt 0 ]; then
  echo "kenaido: $skipped hook(s) skipped because a hook of the same name was already there." >&2
  exit 2
fi
echo "kenaido: done. Commits and merges on main or master, pushes to them, and moving them to anything but what origin has are now refused in this clone."
