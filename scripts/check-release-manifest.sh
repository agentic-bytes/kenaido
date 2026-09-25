#!/usr/bin/env bash
# Checks that this release is exactly what kenaido's release scripts wrote
# (PBI-108): RELEASE-MANIFEST names a clean kenaido commit and the version,
# lists every file git tracks here and nothing else, and every file still has
# the SHA-256 it had when the release was built. Every package states the
# same version. Built by extensions/plugins-repository/finish-release.sh in
# kenaido; do not edit this copy by hand.
# Usage: scripts/check-release-manifest.sh   (from the repository root)
set -euo pipefail
cd "$(dirname "$0")/.."

problems=0
problem() { echo "RELEASE-MANIFEST: $1" >&2; problems=$((problems + 1)); }

m=RELEASE-MANIFEST
if [ ! -f "$m" ]; then
  echo "RELEASE-MANIFEST: missing; a release is built with kenaido's release scripts, which write it." >&2
  exit 1
fi
[ "$(sed -n 1p "$m")" = "kenaido-release-manifest 1" ] || problem "the first line is not 'kenaido-release-manifest 1'"
source_line=$(sed -n 2p "$m")
if [[ ! "$source_line" =~ ^source\ [0-9a-f]{40}$ ]]; then
  problem "the release was not built from a clean kenaido commit: '$source_line'"
fi
version_line=$(sed -n 3p "$m")
version=${version_line#version }
if [[ ! "$version_line" =~ ^version\ [0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  problem "no valid version line: '$version_line'"
fi

listed=$(mktemp)
tracked=$(mktemp)
trap 'rm -f "$listed" "$tracked"' EXIT
tail -n +4 "$m" | sed 's/^[0-9a-f]\{64\}  //' | LC_ALL=C sort > "$listed"
git ls-files | grep -vxF "$m" | LC_ALL=C sort > "$tracked"
while IFS= read -r f; do problem "not produced by the release scripts: $f"; done < <(comm -13 "$listed" "$tracked")
while IFS= read -r f; do problem "listed, but not in the repository: $f"; done < <(comm -23 "$listed" "$tracked")
while IFS= read -r line; do
  problem "changed since the release was built: ${line%: FAILED*}"
done < <(tail -n +4 "$m" | sha256sum -c --quiet | grep ': FAILED' || true)

check_version() {  # $1: file, $2: what it states
  if [ "$2" != "$version" ]; then problem "$1 states version '$2', the manifest '$version'"; fi
}
check_version copilot/.kenaido-copilot-package "$(sed -n 's/^kenaido-copilot //p' copilot/.kenaido-copilot-package)"
check_version codex/.kenaido-codex-package "$(sed -n 's/^kenaido-codex //p' codex/.kenaido-codex-package)"
# Every package is required: a release missing one was built without that
# tool's release.sh.
for f in copilot/.kenaido-copilot-package codex/.kenaido-codex-package \
         antigravity/.kenaido-antigravity-package antigravity/files/.agents/plugins/kenaido/VERSION \
         pi/.kenaido-pi-package pi/files/.pi/kenaido/VERSION \
         plugins/kenaido/.claude-plugin/plugin.json; do
  [ -f "$f" ] || problem "package file missing: $f; run that tool's release.sh"
done
check_version antigravity/.kenaido-antigravity-package \
  "$(sed -n 's/^kenaido-antigravity //p' antigravity/.kenaido-antigravity-package 2>/dev/null)"
check_version antigravity/files/.agents/plugins/kenaido/VERSION \
  "$(head -n 1 antigravity/files/.agents/plugins/kenaido/VERSION 2>/dev/null)"
check_version pi/.kenaido-pi-package \
  "$(sed -n 's/^kenaido-pi //p' pi/.kenaido-pi-package 2>/dev/null)"
check_version pi/files/.pi/kenaido/VERSION \
  "$(head -n 1 pi/files/.pi/kenaido/VERSION 2>/dev/null)"
check_version plugins/kenaido/.claude-plugin/plugin.json \
  "$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' plugins/kenaido/.claude-plugin/plugin.json | head -n 1)"

if [ "$problems" -gt 0 ]; then
  echo "$problems problem(s): this release differs from what kenaido's release scripts produced." >&2
  exit 1
fi
echo "The release is what kenaido ${version} at ${source_line#source } produced: $(wc -l < "$listed" | tr -d ' ') files, unchanged."
