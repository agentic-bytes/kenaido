# kenaido's PreToolUse guardrail for Claude Code, Windows side. The POSIX side
# is no-main-edit.sh, and both hold the same rules (decision 0087): while the
# project's protected branch is checked out, file edits are refused, and shell
# commands (`Bash`, `PowerShell`, `Monitor`, command in `tool_input.command`)
# run only when they cannot change files.
#
# Claude Code picks the shell itself: bash on macOS and Linux, Git Bash on
# Windows when it is installed, and **PowerShell on Windows when it is not**.
# The shipped command was `sh ...`, which PowerShell cannot run — so on a
# Windows machine without Git Bash the guardrail silently did nothing
# (found 2026-09-16).
#
# Claude Code has no per-platform command field; it has a `shell` field. So
# this ships as a second hook entry with `shell: "powershell"`, and Claude Code
# runs whichever suits the machine. Where both run, both deny, and a deny from
# either one blocks.
#
# Fail-open when the guardrail cannot run (no git, no repository). Fail-closed
# once it knows the branch is protected: a call it cannot read is refused.
$ErrorActionPreference = 'SilentlyContinue'

# >>> kenaido shell classifier (decision 0087; the same in every kenaido guard)
#
# On a protected branch, a shell command runs only when it is one of a short
# list of commands that cannot change files, or the ones needed to leave the
# branch. Anything the guard cannot read with certainty is refused, never
# guessed (fail-closed). The POSIX guards hold the same list.
function Test-KenaidoShellAllowed {
    param([object]$Command)
    if ($Command -isnot [string] -or $Command.Length -eq 0) { return $false }
    # Plain words only: letters, digits, space, and _ . / : = -. They mean the
    # same in bash, zsh, and PowerShell. \z, not $: in .NET, $ also matches
    # before a final newline.
    if ($Command -cnotmatch '\A[A-Za-z0-9 _./:=-]+\z') { return $false }
    $w = @($Command.Split([char[]]@(' '), [System.StringSplitOptions]::RemoveEmptyEntries))
    if ($w.Count -lt 1) { return $false }
    foreach ($x in $w) { if ($x.StartsWith('=', [System.StringComparison]::Ordinal)) { return $false } }
    if (@('ls', 'pwd', 'cat', 'head', 'tail', 'wc', 'Get-ChildItem', 'Get-Content', 'Get-Location') -ccontains $w[0]) { return $true }
    # git must be followed by its subcommand: a global option such as -c can
    # run a program.
    if ($w[0] -cne 'git' -or $w.Count -lt 2) { return $false }
    $sub = $w[1]
    $rest = @()
    if ($w.Count -gt 2) { $rest = @($w[2..($w.Count - 1)]) }
    if ($sub -ceq 'status' -or $sub -ceq 'rev-parse') { return $true }
    if (@('log', 'diff', 'show') -ccontains $sub) {
        # --output=<file> writes a file, and git accepts abbreviated long options.
        foreach ($x in $rest) { if ($x -cne '--oneline' -and $x -clike '--o*') { return $false } }
        return $true
    }
    if ($sub -ceq 'branch') {
        foreach ($x in $rest) {
            if (@('-a', '-r', '-v', '-vv', '-l', '--all', '--remotes', '--verbose', '--list', '--show-current') -cnotcontains $x) { return $false }
        }
        return $true
    }
    if ($sub -ceq 'remote') {
        if ($rest.Count -eq 0) { return $true }
        return ($rest.Count -eq 1 -and (@('-v', '--verbose') -ccontains $rest[0]))
    }
    if ($sub -ceq 'fetch') {
        # No refspec (a ':' can write a local branch) and no URL.
        foreach ($x in $rest) {
            if (@('--prune', '-p', '--all', '--tags', '--no-tags', '-q', '--quiet', '-v', '--verbose', '--dry-run') -ccontains $x) { continue }
            if ($x -clike '-*' -or $x -clike '*:*') { return $false }
        }
        return $true
    }
    if ($sub -ceq 'switch') {
        # Never -C, --force-create, --discard-changes, --force, --merge, --orphan.
        $names = 0
        foreach ($x in $rest) {
            if (@('-c', '--create', '--no-track', '--track', '-t', '-q', '--quiet', '--detach', '-d') -ccontains $x) { continue }
            if ($x -ceq '-') { $names++; continue }
            if ($x -clike '-*') { return $false }
            $names++
        }
        return ($names -ge 1 -and $names -le 2)
    }
    if ($sub -ceq 'checkout') {
        # Only to create a branch: every other form can overwrite files.
        $names = 0
        $create = 0
        foreach ($x in $rest) {
            if ($x -ceq '-b') { $create++; continue }
            if (@('--no-track', '--track', '-t', '-q', '--quiet') -ccontains $x) { continue }
            if ($x -clike '-*') { return $false }
            $names++
        }
        return ($create -eq 1 -and $names -ge 1 -and $names -le 2)
    }
    return $false
}
# <<< kenaido shell classifier

$protected = $false
try {
    $raw = [Console]::In.ReadToEnd()
    $json = $null
    if ($raw) { try { $json = ConvertFrom-Json $raw } catch { $json = $null } }
    $project = $null
    if ($json) { $project = $json.cwd }
    if (-not $project) { $project = $env:CLAUDE_PROJECT_DIR }
    if (-not $project) { $project = (Get-Location).Path }

    # Without git this cannot tell the branch, so it lets the edit through,
    # but never in silence (PBI-140): systemMessage shows the person a warning
    # and carries no decision, so the edit still proceeds (fail-open).
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        @{ systemMessage = 'kenaido warning: the guardrail cannot check this action, because git was not found. Edits, shell commands and MCP tool calls on main or master are NOT being refused. Install git, or put it on PATH.' } | ConvertTo-Json -Compress
        exit 0
    }

    & git -C "$project" rev-parse --git-dir *> $null
    if ($LASTEXITCODE -ne 0) { exit 0 }
    $branch = (& git -C "$project" rev-parse --abbrev-ref HEAD 2>$null)
    if ($LASTEXITCODE -ne 0 -or -not $branch) { exit 0 }
    $branch = $branch.Trim()
    if ($branch -eq 'HEAD') { exit 0 }
    # Origin's own default branch, when known, may be neither main nor
    # master; with no origin at all, this stays empty.
    $defaultBranch = (& git -C "$project" symbolic-ref --short -q refs/remotes/origin/HEAD 2>$null)
    if ($LASTEXITCODE -eq 0 -and $defaultBranch) {
        $defaultBranch = $defaultBranch.Trim()
        if ($defaultBranch.StartsWith('origin/')) { $defaultBranch = $defaultBranch.Substring(7) }
    }
    else { $defaultBranch = '' }
    if ($branch -ne 'main' -and $branch -ne 'master' -and $branch -ne $defaultBranch) { exit 0 }
    # From here the branch is protected: any failure refuses (decision 0087).
    $protected = $true

    # With no origin remote at all (#385, a from-scratch project), the way
    # out does not name origin, since there is nothing there yet.
    & git -C "$project" remote get-url origin *> $null
    $hasOrigin = ($LASTEXITCODE -eq 0)
    $baseBranch = if ($defaultBranch) { $defaultBranch } else { 'main' }
    if ($hasOrigin) {
        $wayOut = "Create a work branch first, from the latest origin/${baseBranch}:`n`n  git fetch origin`n  git switch --no-track -c <type>/<short-description> origin/${baseBranch}`n`nTypes: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
    }
    else {
        $wayOut = "Create a work branch first:`n`n  git switch --no-track -c <type>/<short-description>`n`nTypes: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
    }
    $editReason = "kenaido GIT-1: never change '$branch'. $wayOut Then make this edit again on that branch."
    $shellReason = "kenaido GIT-1: '$branch' is checked out, so this shell command was refused. On main or master only commands that cannot change files run, one at a time, in plain words: no quotes, variables, globs, pipes, redirects, && or ;. They are: git status, log, diff, show, branch (to list), rev-parse, remote -v, fetch, switch, checkout -b; ls, cat, pwd, head, tail, wc. $wayOut Then run the command again on that branch."
    $mcpReason = "kenaido GIT-1: '$branch' is checked out, so MCP tool calls are refused, read-only ones too: on main or master the only job is to leave it. $wayOut Then call the tool again on that branch."

    $reason = $editReason
    $tool = $null
    if ($json) { $tool = $json.tool_name }
    if (@('Bash', 'PowerShell', 'Monitor') -ccontains $tool) {
        $allowed = $false
        try { if ($json.tool_input) { $allowed = Test-KenaidoShellAllowed $json.tool_input.command } } catch { $allowed = $false }
        if ($allowed -is [bool] -and $allowed) { exit 0 }
        $reason = $shellReason
    }
    elseif ($tool -is [string] -and $tool.StartsWith('mcp__', [System.StringComparison]::Ordinal)) { $reason = $mcpReason }

    $out = @{ hookSpecificOutput = @{
        hookEventName            = 'PreToolUse'
        permissionDecision       = 'deny'
        permissionDecisionReason = $reason
    } }
    $out | ConvertTo-Json -Depth 5 -Compress
    exit 0
}
catch {
    # Fail-open only while the branch is not yet known to be protected.
    if ($protected) { @{ hookSpecificOutput = @{ hookEventName = 'PreToolUse'; permissionDecision = 'deny'; permissionDecisionReason = 'kenaido GIT-1: main or master is checked out, and the guardrail failed while checking this action, so it is refused. Create a work branch first: git fetch origin, then git switch --no-track -c <type>/<short-description> origin/main.' } } | ConvertTo-Json -Depth 5 -Compress }
    exit 0
}
