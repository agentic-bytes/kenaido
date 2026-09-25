# kenaido's PreToolUse guardrail for Google Antigravity, Windows side. The
# POSIX side is no-main-edit.sh. Antigravity's hooks.json has one `command`
# and no Windows override (docs/hooks, "Hook Handler Configuration", read
# 2026-09-21), so the installer writes, on Windows, a command that reaches
# this script through PowerShell, encoded so no parent shell can rewrite it.
#
# The JSON arrives as -InputJson when that command has already read stdin (it
# can only be read once), and on stdin when this script is run directly.
#
# Both sides hold the same rules (decision 0087): while a protected branch is
# checked out in any place the call names (the folder of `TargetFile`, `Cwd`,
# each of `workspacePaths`), file edits are refused, `run_command` runs only
# when it cannot change files, the tools that cannot change anything pass, and
# every other tool, MCP tools included, is refused: Antigravity documents no
# MCP tool name to recognize them by.
#
# Fail-open when the guardrail cannot run (no git): the call goes to the
# person with `ask` and a warning. Fail-closed once it knows the branch is
# protected: a call it cannot read is refused.
param([string]$InputJson)
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

$readOnly = @('view_file', 'list_dir', 'find_by_name', 'grep_search', 'search_web', 'read_url_content', 'list_permissions', 'ask_question')
$editTools = @('write_to_file', 'replace_file_content', 'multi_replace_file_content')

$protected = $false
try {
    $raw = $InputJson
    if (-not $raw) { $raw = [Console]::In.ReadToEnd() }
    $json = $null
    if ($raw) { try { $json = ConvertFrom-Json $raw } catch { $json = $null } }
    $tool = $null
    $toolArgs = $null
    if ($json -and $json.toolCall) { $tool = $json.toolCall.name; $toolArgs = $json.toolCall.args }
    $isReadOnly = ($tool -is [string]) -and ($readOnly -ccontains $tool)

    # Without git this cannot tell the branch. A read-only tool goes through;
    # any other call goes to the person, with the warning (PBI-140).
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        if ($isReadOnly) { exit 0 }
        @{ decision = 'ask'; reason = 'kenaido warning: the guardrail cannot check this action, because git was not found. Edits, shell commands and MCP tool calls on main or master are NOT being refused, so you decide this one. Install git, or put it on PATH.' } | ConvertTo-Json -Compress
        exit 0
    }

    $workspaces = @()
    if ($json -and $json.workspacePaths) { $workspaces = @($json.workspacePaths | Where-Object { $_ -is [string] -and $_ }) }
    $places = @()
    if ($toolArgs -and $toolArgs.TargetFile -is [string] -and $toolArgs.TargetFile) {
        $target = $toolArgs.TargetFile
        if (-not [System.IO.Path]::IsPathRooted($target) -and $workspaces.Count -gt 0) { $target = Join-Path $workspaces[0] $target }
        $folder = Split-Path -Parent $target
        while ($folder -and -not (Test-Path -LiteralPath $folder -PathType Container)) { $folder = Split-Path -Parent $folder }
        if ($folder) { $places += $folder }
    }
    if ($toolArgs -and $toolArgs.Cwd -is [string] -and $toolArgs.Cwd) { $places += $toolArgs.Cwd }
    $places += $workspaces
    if ($places.Count -eq 0) { $places = @((Get-Location).Path) }

    $branch = $null
    $branchPlace = $null
    foreach ($place in $places) {
        & git -C "$place" rev-parse --git-dir *> $null
        if ($LASTEXITCODE -ne 0) { continue }
        $b = (& git -C "$place" rev-parse --abbrev-ref HEAD 2>$null)
        if ($LASTEXITCODE -ne 0 -or -not $b) { continue }
        $b = "$b".Trim()
        if ($b -ceq 'main' -or $b -ceq 'master') { $branch = $b; $branchPlace = $place; break }
        # Origin's own default branch, when known, may be neither main nor
        # master (the default-branch gap; with no origin, this is empty).
        $d = (& git -C "$place" symbolic-ref --short -q refs/remotes/origin/HEAD 2>$null)
        if ($LASTEXITCODE -eq 0 -and $d) {
            $d = "$d".Trim()
            if ($d.StartsWith('origin/')) { $d = $d.Substring(7) }
            if ($d -and $b -ceq $d) { $branch = $b; $branchPlace = $place; break }
        }
    }
    if (-not $branch) { exit 0 }
    # From here the branch is protected: any failure refuses (decision 0087).
    $protected = $true
    if ($isReadOnly) { exit 0 }

    $defaultBranch = (& git -C "$branchPlace" symbolic-ref --short -q refs/remotes/origin/HEAD 2>$null)
    if ($LASTEXITCODE -eq 0 -and $defaultBranch) {
        $defaultBranch = "$defaultBranch".Trim()
        if ($defaultBranch.StartsWith('origin/')) { $defaultBranch = $defaultBranch.Substring(7) }
    }
    else { $defaultBranch = '' }
    # With no origin remote at all (#385, a from-scratch project), the way
    # out does not name origin, since there is nothing there yet.
    & git -C "$branchPlace" remote get-url origin *> $null
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
    $mcpReason = "kenaido GIT-1: '$branch' is checked out, so MCP tool calls are refused, read-only ones too, and so is every tool this guardrail does not know, since Antigravity does not document how MCP tools are named: on main or master the only job is to leave it. $wayOut Then call the tool again on that branch."

    $reason = $mcpReason
    if (($tool -is [string]) -and ($editTools -ccontains $tool)) { $reason = $editReason }
    elseif ($tool -ceq 'run_command') {
        $allowed = $false
        try { if ($toolArgs) { $allowed = Test-KenaidoShellAllowed $toolArgs.CommandLine } } catch { $allowed = $false }
        if ($allowed -is [bool] -and $allowed) { exit 0 }
        $reason = $shellReason
    }

    @{ decision = 'deny'; reason = $reason } | ConvertTo-Json -Compress
    exit 0
}
catch {
    # Fail-open only while the branch is not yet known to be protected.
    if ($protected) { @{ decision = 'deny'; reason = 'kenaido GIT-1: main or master is checked out, and the guardrail failed while checking this action, so it is refused. Create a work branch first: git fetch origin, then git switch --no-track -c <type>/<short-description> origin/main.' } | ConvertTo-Json -Compress }
    exit 0
}
