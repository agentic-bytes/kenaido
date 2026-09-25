// kenaido's guardrail for pi: while `main` or `master` is checked out
// (`GIT-1`, `GIT-3`), it refuses file edits, lets shell commands through only
// when they cannot change files (decision 0087), and refuses every tool it
// does not know. It says why, so the agent cuts a work branch instead of
// failing blind. On any other branch it objects to nothing.
//
// pi loads this file itself, as a project extension, once the person trusts
// the project. What it relies on was read in pi's source at v0.87.0
// (https://github.com/earendil-works/pi, 2026-09-22):
// - `tool_call` fires before a tool runs; returning `{ block: true, reason }`
//   stops it, and the first handler that blocks wins
//   (packages/coding-agent/src/core/extensions/runner.ts, `emitToolCall`).
// - Built-in tools are `read`, `grep`, `find`, `ls` (reading), `edit`,
//   `write` (writing), `bash`, `powershell` (a `command` string); any other
//   name is a tool another extension added
//   (packages/coding-agent/src/core/extensions/types.ts, `ToolCallEvent`).
// - `user_bash` fires for a person's `!` and `!!` commands; returning
//   `{ result }` records that result without running the command (same file,
//   `UserBashEventResult`).
//
// It imports nothing from pi, only Node.js built-ins, so its tests run with
// `node --test` and no npm install (decision 0092).
//
// What it cannot catch is in the README (extensions/README.md): tools other
// extensions add or override under a built-in name, anything done before the
// project is trusted, and a person's own terminal.

import { execFileSync } from "node:child_process";

// >>> kenaido shell classifier (decision 0087; the TypeScript copy for pi)
//
// On a protected branch, a shell command runs only when it is one of a short
// list of commands that cannot change files, or the ones needed to leave the
// branch. Anything the guard cannot read with certainty is refused, never
// guessed (fail-closed). extensions/git-hooks/test-shell-classifier-copies.sh
// checks this copy against the POSIX one: the same words, and the same
// answers on a shared list of commands.

// Plain words only: letters, digits, space, and _ . / : = -. They mean the same
// in bash, zsh, and PowerShell. Without the `m` flag, `$` matches only at the
// very end, and a newline is not in the set.
const KENAIDO_PLAIN = /^[A-Za-z0-9 _./:=-]+$/;
const KENAIDO_READ_ONLY = ["ls", "pwd", "cat", "head", "tail", "wc", "Get-ChildItem", "Get-Content", "Get-Location"];
const KENAIDO_BRANCH_LIST = ["-a", "-r", "-v", "-vv", "-l", "--all", "--remotes", "--verbose", "--list", "--show-current"];
const KENAIDO_REMOTE = ["-v", "--verbose"];
const KENAIDO_FETCH = ["--prune", "-p", "--all", "--tags", "--no-tags", "-q", "--quiet", "-v", "--verbose", "--dry-run"];
// Never -C, --force-create, --discard-changes, --force, --merge, --orphan.
const KENAIDO_SWITCH = ["-c", "--create", "--no-track", "--track", "-t", "-q", "--quiet", "--detach", "-d"];
const KENAIDO_CHECKOUT = ["--no-track", "--track", "-t", "-q", "--quiet"];

// kenaidoShellAllowed(command): true when the command may run on a protected branch.
export function kenaidoShellAllowed(command: unknown): boolean {
  if (typeof command !== "string" || command === "") return false;
  if (!KENAIDO_PLAIN.test(command)) return false;
  const words = command.split(" ").filter((w) => w !== "");
  if (words.length < 1) return false;
  // zsh expands =cmd to a path.
  if (words.some((w) => w.startsWith("="))) return false;
  const [first, ...rest] = words;
  if (KENAIDO_READ_ONLY.includes(first)) return true;
  if (first !== "git") return false;
  // git must be followed by its subcommand: a global option such as -c can
  // run a program.
  if (rest.length < 1) return false;
  const [sub, ...args] = rest;
  switch (sub) {
    case "status":
    case "rev-parse":
      return true;
    case "log":
    case "diff":
    case "show":
      // --output=<file> writes a file, and git accepts abbreviated long options.
      return args.every((w) => w === "--oneline" || !w.startsWith("--o"));
    case "branch":
      return args.every((w) => KENAIDO_BRANCH_LIST.includes(w));
    case "remote":
      return args.length === 0 || (args.length === 1 && KENAIDO_REMOTE.includes(args[0]));
    case "fetch":
      // No refspec (a ':' can write a local branch) and no URL.
      return args.every((w) => KENAIDO_FETCH.includes(w) || (!w.startsWith("-") && !w.includes(":")));
    case "switch": {
      let names = 0;
      for (const w of args) {
        if (KENAIDO_SWITCH.includes(w)) continue;
        if (w === "-") names += 1;
        else if (w.startsWith("-")) return false;
        else names += 1;
      }
      return names >= 1 && names <= 2;
    }
    case "checkout": {
      // Only to create a branch: every other form can overwrite files.
      let names = 0;
      let create = 0;
      for (const w of args) {
        if (w === "-b") create += 1;
        else if (KENAIDO_CHECKOUT.includes(w)) continue;
        else if (w.startsWith("-")) return false;
        else names += 1;
      }
      return create === 1 && names >= 1 && names <= 2;
    }
    default:
      return false;
  }
}
// <<< kenaido shell classifier

export const PROTECTED = ["main", "master"];
export const READ_TOOLS = ["read", "grep", "find", "ls"];
export const EDIT_TOOLS = ["edit", "write"];
export const SHELL_TOOLS = ["bash", "powershell"];

// The default way out, used whenever a caller doesn't say otherwise (kept as
// the default parameter value below, so every existing caller and test that
// passes no way-out string keeps behaving exactly as before).
const DEFAULT_WAY_OUT =
  "Create a work branch first, from the latest origin/main:\n\n" +
  "  git fetch origin\n" +
  "  git switch --no-track -c <type>/<short-description> origin/main\n\n" +
  "Types: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert.";
const SHELL_LIST =
  "On main or master only commands that cannot change files run, one at a time, in plain words: " +
  "no quotes, variables, globs, pipes, redirects, && or ;. They are: git status, log, diff, show, " +
  "branch (to list), rev-parse, remote -v, fetch, switch, checkout -b; ls, cat, pwd, head, tail, wc.";

// The real way out, once the branch and the origin situation are known
// (#385): with no origin remote at all, there is nothing yet to fetch or
// switch from, so the fetch/origin lines are left out; with one, the
// branch named is origin's own default branch when it is known (which may
// be neither main nor master), falling back to "main" otherwise.
export function wayOutText(hasOrigin: boolean, defaultBranchName: string): string {
  const base = defaultBranchName || "main";
  if (!hasOrigin) {
    return (
      "Create a work branch first:\n\n" +
      "  git switch --no-track -c <type>/<short-description>\n\n" +
      "Types: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
    );
  }
  return (
    `Create a work branch first, from the latest origin/${base}:\n\n` +
    "  git fetch origin\n" +
    `  git switch --no-track -c <type>/<short-description> origin/${base}\n\n` +
    "Types: feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert."
  );
}

export function editReason(branch: string, wayOut: string = DEFAULT_WAY_OUT): string {
  return `kenaido GIT-1: never change '${branch}'. ${wayOut} Then make this edit again on that branch.`;
}
export function shellReason(branch: string, wayOut: string = DEFAULT_WAY_OUT): string {
  return `kenaido GIT-1: '${branch}' is checked out, so this shell command was refused. ${SHELL_LIST} ${wayOut} Then run the command again on that branch.`;
}
export function unknownToolReason(branch: string, tool: string, wayOut: string = DEFAULT_WAY_OUT): string {
  return (
    `kenaido GIT-1: '${branch}' is checked out, so the tool '${tool}' was refused. kenaido's guard knows pi's ` +
    "own tools only; a tool another extension added may write files, so on main or master it is refused, " +
    `read-only ones too: the only job there is to leave it. ${wayOut} Then call the tool again on that branch.`
  );
}
export function userShellReason(branch: string, wayOut: string = DEFAULT_WAY_OUT): string {
  return (
    `kenaido GIT-1: '${branch}' is checked out, so this ! command was not run. ${SHELL_LIST} ${wayOut} ` +
    "Your own terminal is not checked by kenaido."
  );
}
export const NO_GIT_WARNING =
  "kenaido warning: the guardrail cannot check this action, because git was not found. " +
  "Edits, shell commands and other tools on main or master are NOT being refused. Install git, or put it on PATH.";
export function errorReason(branch: string, error: unknown, wayOut: string = DEFAULT_WAY_OUT): string {
  return `kenaido GIT-1: '${branch}' is checked out, and the guard hit an error, so this call was refused rather than let through: ${String(error)}. ${wayOut}`;
}

// What the guard answers for one tool call, once the branch is known.
export type Decision = { block: true; reason: string } | undefined;

export function decideToolCall(
  toolName: unknown,
  input: unknown,
  branch: string,
  protectedBranches: string[] = PROTECTED,
  wayOut: string = DEFAULT_WAY_OUT,
): Decision {
  if (!protectedBranches.includes(branch)) return undefined;
  const tool = typeof toolName === "string" ? toolName : "";
  if (READ_TOOLS.includes(tool)) return undefined;
  if (EDIT_TOOLS.includes(tool)) return { block: true, reason: editReason(branch, wayOut) };
  if (SHELL_TOOLS.includes(tool)) {
    const command = input !== null && typeof input === "object" ? (input as Record<string, unknown>).command : undefined;
    return kenaidoShellAllowed(command) ? undefined : { block: true, reason: shellReason(branch, wayOut) };
  }
  return { block: true, reason: unknownToolReason(branch, tool || "(no name)", wayOut) };
}

// The branch checked out in a folder, as git reports it.
export type BranchState = { kind: "branch"; name: string } | { kind: "none" } | { kind: "no-git" };
export type Git = (args: string[], cwd: string) => string;

export const realGit: Git = (args, cwd) =>
  execFileSync("git", args, {
    cwd,
    encoding: "utf8",
    stdio: ["ignore", "pipe", "ignore"],
    timeout: 10_000,
    windowsHide: true,
  });

export function readBranch(cwd: string, git: Git = realGit): BranchState {
  try {
    const name = git(["rev-parse", "--abbrev-ref", "HEAD"], cwd).trim();
    // Detached HEAD: no branch to protect, as in the other kenaido guards.
    return name === "" || name === "HEAD" ? { kind: "none" } : { kind: "branch", name };
  } catch (e) {
    // Not a repository, or no commit yet: nothing to protect. No git at all:
    // the guard cannot tell, and says so.
    return (e as NodeJS.ErrnoException)?.code === "ENOENT" ? { kind: "no-git" } : { kind: "none" };
  }
}

// Origin's own default branch, when this folder has an origin remote with a
// known HEAD (`git symbolic-ref refs/remotes/origin/HEAD`); "" when there is
// no origin, or its default branch is not known here (#385, the Architect's
// finding that a default branch named neither main nor master got no
// protection at all).
export function readDefaultBranch(cwd: string, git: Git = realGit): string {
  try {
    const ref = git(["symbolic-ref", "--short", "-q", "refs/remotes/origin/HEAD"], cwd).trim();
    return ref.startsWith("origin/") ? ref.slice("origin/".length) : ref;
  } catch {
    return "";
  }
}

// Whether this folder has an origin remote configured at all. With none —
// a from-scratch, local-only project (#385) — the way out must not tell the
// user to fetch or switch from an origin that does not exist.
export function readHasOrigin(cwd: string, git: Git = realGit): boolean {
  try {
    git(["remote", "get-url", "origin"], cwd);
    return true;
  } catch {
    return false;
  }
}

// The parts of pi's API the guard uses, by shape, so it needs no import from pi.
export interface GuardContext {
  cwd: string;
  hasUI?: boolean;
  ui?: { notify(message: string, level?: string): void };
}
export interface GuardApi {
  on(event: string, handler: (event: any, ctx: GuardContext) => unknown): unknown;
}

// A `!` command's result that records the refusal without running anything.
function refusedResult(output: string) {
  return { result: { output, exitCode: 1, cancelled: false, truncated: false } };
}

function warn(ctx: GuardContext, message: string): void {
  // Never in silence (PBI-140): in the TUI as a notice, otherwise on stderr.
  if (ctx.hasUI && ctx.ui) ctx.ui.notify(message, "warning");
  else process.stderr.write(message + "\n");
}

// The branches to protect, and the way out to give, for this folder right
// now (#385, and the default-branch gap): main and master always; origin's
// own default branch too, when it is known and differs from both; the way
// out names that branch, and leaves out the fetch/origin lines entirely
// when there is no origin remote at all.
function effectiveProtection(cwd: string, git: Git): { protectedBranches: string[]; wayOut: string } {
  const defaultBranchName = readDefaultBranch(cwd, git);
  const protectedBranches = defaultBranchName && !PROTECTED.includes(defaultBranchName) ? [...PROTECTED, defaultBranchName] : PROTECTED;
  const wayOut = wayOutText(readHasOrigin(cwd, git), defaultBranchName);
  return { protectedBranches, wayOut };
}

export function createGuard(git: Git = realGit) {
  return function kenaidoGuard(pi: GuardApi): void {
    pi.on("session_start", (_event, ctx) => {
      if (readBranch(ctx.cwd, git).kind === "no-git") warn(ctx, NO_GIT_WARNING);
    });

    pi.on("tool_call", (event, ctx) => {
      let branch: string | undefined;
      try {
        const state = readBranch(ctx.cwd, git);
        if (state.kind === "no-git") {
          warn(ctx, NO_GIT_WARNING);
          return undefined;
        }
        if (state.kind === "none") return undefined;
        branch = state.name;
        const { protectedBranches, wayOut } = effectiveProtection(ctx.cwd, git);
        return decideToolCall(event?.toolName, event?.input, branch, protectedBranches, wayOut);
      } catch (e) {
        // Once the branch is known to be protected, an error refuses
        // (decision 0087, review C3); before that, the guard cannot tell, and warns.
        if (branch !== undefined && (PROTECTED.includes(branch) || branch === readDefaultBranch(ctx.cwd, git))) {
          return { block: true, reason: errorReason(branch, e, wayOutText(readHasOrigin(ctx.cwd, git), readDefaultBranch(ctx.cwd, git))) };
        }
        warn(ctx, `kenaido warning: the guardrail could not check this call (${String(e)}); it was not refused.`);
        return undefined;
      }
    });

    pi.on("user_bash", (event, ctx) => {
      let branch: string | undefined;
      try {
        const cwd = event?.cwd || ctx.cwd;
        const state = readBranch(cwd, git);
        if (state.kind === "no-git") {
          warn(ctx, NO_GIT_WARNING);
          return undefined;
        }
        const { protectedBranches, wayOut } = effectiveProtection(cwd, git);
        if (state.kind !== "branch" || !protectedBranches.includes(state.name)) return undefined;
        branch = state.name;
        if (kenaidoShellAllowed(event?.command)) return undefined;
        return refusedResult(userShellReason(branch, wayOut));
      } catch (e) {
        if (branch !== undefined) return refusedResult(errorReason(branch, e));
        warn(ctx, `kenaido warning: the guardrail could not check this command (${String(e)}); it was not refused.`);
        return undefined;
      }
    });
  };
}

export default createGuard();
