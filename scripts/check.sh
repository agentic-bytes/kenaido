#!/usr/bin/env bash
# The checks this releases repository runs on every pull request (PBI-108):
# the release is what kenaido's release scripts produced; the shipped shell
# scripts pass lint; each installer installs into an empty project and
# removes itself cleanly, and the guardrail it installed refuses an edit on
# main and allows it on a work branch; no secret is in the history; and a bill of
# materials is built and scanned for known vulnerabilities (`TEST-1`,
# `TEST-5`). Every tool is pinned by version and content digest (`TEST-4`),
# with the same pins kenaido uses. Built by kenaido's release scripts; do not
# edit this copy by hand. Requires Docker. Usage: scripts/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."

SHELLCHECK_IMAGE="koalaman/shellcheck:v0.11.0@sha256:61862eba1fcf09a484ebcc6feea46f1782532571a34ed51fedf90dd25f925a8d"
GITLEAKS_IMAGE="ghcr.io/gitleaks/gitleaks:v8.30.1@sha256:c00b6bd0aeb3071cbcb79009cb16a60dd9e0a7c60e2be9ab65d25e6bc8abbb7f"
SYFT_IMAGE="ghcr.io/anchore/syft:v1.51.1@sha256:95fe0835e5bebc6f8b1f8acef68d47d63d594ef4c0f25c097ff853b23cbac74c"
GRYPE_IMAGE="ghcr.io/anchore/grype:v0.118.0@sha256:8a93fc48da96bd6ec5981279d099b69de11541dc68fdf222fb9161f8ff284af7"
# Node.js, only to read the installed hook configurations and to load the pi
# guardrail as pi does, sealed (decision 0092).
NODE_IMAGE="node:24.21.0-alpine3.24@sha256:ebfe2f90462722a7a4de65e91990e97fe0d401c70e0e762c5b53302f905ec1c1"
export NODE_IMAGE
GRYPE_FAIL_ON="${GRYPE_FAIL_ON:-medium}"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

echo "== The release is what kenaido's release scripts produced"
scripts/check-release-manifest.sh

echo "== Lint the shell scripts"
mapfile -t shell_scripts < <(git ls-files '*.sh')
docker run --rm --network none -v "$PWD:/mnt:ro" -w /mnt "$SHELLCHECK_IMAGE" -x "${shell_scripts[@]}"

echo "== Each installer installs into an empty project, and removes itself cleanly"
# The tools are the packages this release carries, never a hand-kept list
# (#364): every top-level folder with a .kenaido-<tool>-package marker or an
# install.sh. After the loop, every one of them must have been installed and
# removed, so a tool left out of the loop fails here instead of shipping an
# installer nobody ran.
shipped_tools() {
  local f
  for f in */.kenaido-*-package */install.sh; do
    if [ -f "$f" ]; then echo "${f%%/*}"; fi
  done | LC_ALL=C sort -u
}
mapfile -t tools < <(shipped_tools)
if [ "${#tools[@]}" -eq 0 ]; then
  echo "no tool package in this release; run each extensions/<tool>/release.sh" >&2
  exit 1
fi
exercised=()
for tool in "${tools[@]}"; do
  if [ ! -f "$tool/install.sh" ]; then
    echo "$tool: no $tool/install.sh in this release; run extensions/$tool/release.sh" >&2
    exit 1
  fi
  project="$WORK_DIR/$tool-project"
  mkdir -p "$project"
  sh "$tool/install.sh" "$project" > /dev/null
  if [ -z "$(ls -A "$project")" ]; then
    echo "$tool: the install wrote nothing" >&2
    exit 1
  fi
  sh "$tool/install.sh" --remove "$project" > /dev/null
  if [ -n "$(ls -A "$project")" ]; then
    echo "$tool: --remove left files behind:" >&2
    find "$project" >&2
    exit 1
  fi
  echo "$tool: installed and removed cleanly."
  scripts/check-installed-guards.sh "$tool"
  exercised+=("$tool")
done
skipped=$(comm -23 <(shipped_tools) <(printf '%s\n' "${exercised[@]}" | LC_ALL=C sort -u))
if [ -n "$skipped" ]; then
  for tool in $skipped; do
    echo "$tool: ships a package, but its installer was never installed and removed here" >&2
  done
  exit 1
fi
project="$WORK_DIR/claude-project"
mkdir -p "$project"
sh plugins/kenaido/scripts/setup.sh "$project" > /dev/null
shipped=$(find plugins/kenaido/install/.claude/rules/kenaido -name '*.md' | wc -l | tr -d ' ')
installed=$(find "$project/.claude/rules/kenaido" -name '*.md' | wc -l | tr -d ' ')
if [ "$shipped" -eq 0 ] || [ "$installed" -ne "$shipped" ]; then
  echo "claude code: setup installed $installed of $shipped rule files" >&2
  exit 1
fi
echo "claude code: setup installed all $installed rule files."
scripts/check-installed-guards.sh claude_code

echo "== Scan all git history for secrets"
# shellcheck source=scripts/lib/secret-scan-guard.sh
. scripts/lib/secret-scan-guard.sh
run_gitleaks "$PWD" 2>&1 | tee "$WORK_DIR/gitleaks.log"
secret_scan_guard "$WORK_DIR/gitleaks.log"

echo "== Build the software bill of materials, and scan it"
mkdir -p "$WORK_DIR/sbom"
docker run --rm -v "$PWD:/src:ro" -v "$WORK_DIR/sbom:/out" "$SYFT_IMAGE" \
  scan dir:/src --output "cyclonedx-json=/out/sbom.cyclonedx.json" --output table
docker run --rm -v "$WORK_DIR/sbom:/out:ro" "$GRYPE_IMAGE" \
  "sbom:/out/sbom.cyclonedx.json" --fail-on "$GRYPE_FAIL_ON"

echo
echo "All checks passed."
