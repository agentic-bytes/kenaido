# shellcheck shell=bash
# Shared by scripts/check.sh and scripts/test-secret-scan-guard.sh (#89).
# Sourced, not run directly.
#
# gitleaks exits 0 even when it scanned 0 commits or could not read the
# repository at all (for example inside a git worktree, whose .git is a file
# that points outside the folder scripts/check.sh mounts into the container).
# secret_scan_guard reads gitleaks' own log and fails the check itself in
# that case, with a plain message; it prints the commits-scanned count when
# the scan is real.
#
# secret_scan_guard <log-file>: returns 0 and prints "Secret scan: N commits
# scanned." when the log shows at least one commit scanned; otherwise prints
# a plain failure message to stderr and returns 1. Sourced, not executed.
secret_scan_guard() {
  local log_file=$1
  local commits_line
  commits_line="$(grep -oE '[0-9]+ commits scanned' "$log_file" | tail -1 || true)"
  case "$commits_line" in
    '' | '0 commits scanned')
      echo "Secret scan failed: it scanned 0 commits, or could not read the repository. Run scripts/check.sh from a clone, not a worktree (a worktree's .git points outside the folder the scan can read)." >&2
      return 1
      ;;
    *)
      echo "Secret scan: $commits_line."
      return 0
      ;;
  esac
}

# run_gitleaks <dir>: the one hardened gitleaks run (decision 0057), shared by
# scripts/check.sh and its test so the two can't drift. It scans <dir>'s git
# history with no network, a read-only file system and mount, no Linux
# capabilities, no privilege escalation, and the caller's own user, which
# shrinks what the image's known findings could reach. Needs GITLEAKS_IMAGE.
run_gitleaks() {
  docker run --rm --network none --read-only --cap-drop ALL --security-opt no-new-privileges \
    --user "$(id -u):$(id -g)" -v "$1:/repo:ro" "$GITLEAKS_IMAGE" git --redact /repo
}
