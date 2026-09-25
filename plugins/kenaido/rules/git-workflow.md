# Git workflow and naming

How changes move from an idea to `main`, and how the releases built from them are numbered: every change on its own branch, `main` changed only through reviewed pull requests, only humans push, and every release carries a version that says what it does to its users. The `start-change` skill walks through the first part.

## Workflow

- **`GIT-1` Never change `main`.** Do not edit files, commit, merge, rebase, reset, or cherry-pick while `main` is checked out. If the current branch is `main`, create a work branch first (`GIT-2`) before modifying anything.
- **`GIT-2` Every change goes on a new branch cut from the latest `origin/main`**, so work starts aligned with the newest main:
  ```bash
  git fetch origin
  git switch --no-track -c <type>/<short-description> origin/main
  ```
  `--no-track` keeps `origin/main` from becoming the branch's upstream, so a bare `git push`/`git pull` can never target main. Cut from a different base branch only when the user explicitly says so for that change. **With no `origin` yet** (a project just started): cut the branch from local `main` instead (`git switch --no-track -c <type>/<short-description>`), or ask the user if it's unclear a project has none.
- **`GIT-3` Coding agents commit only on branches derived from `main`, never on `main` itself.** Check the current branch before every commit.
- **`GIT-4` Pushing is a human action by default.** Never run `git push`, push tags, or run anything that pushes on your behalf (e.g. `gh pr create` pushing an unpublished branch, `gh pr merge`) unless the accountable human explicitly authorizes it. Authorization comes in exactly two forms:
  - **A single push** (the normal case): the human authorizes that one push. It covers that case only and does not carry over to later pushes.
  - **An exceptional delegation:** the accountable human may hand pushing to agents for a **stated scope and period**, for example the branches of one task or the current Sprint. It is recorded as a decision (`PRIN-3`), it is revocable at any moment, and it ends when its scope or period ends, after which the default returns. It never covers `main` (`GIT-5`), tags, or releases, and it never replaces the approver of a pull request (`GIT-6`).

  The default holds at **every autonomy level**, including 3 and 4: raising a team's autonomy level never hands pushing to agents. A level 3 or 4 run either pauses for a human to push, or runs inside an exceptional delegation as above.
- **`GIT-5` `main` changes only through pull requests.** Code reaches `main` only by merging a child branch through a pull request (PR on GitHub; merge request, or MR, on GitLab). Never commit, merge, or push to `main` directly, not even locally.
- **`GIT-6` Every pull request has a requester and an approver who is not its author.** The author opens the pull request (requester), and an approver reviews it before it is merged. The approver is never the author, and never the same agent in any of its combined roles (`TEAM-12`). Below autonomy level 3, the approver is always a human, and coding agents never approve pull requests. At levels 3 and 4, an independent agent may approve within the guardrails, and a human still approves delivery of each Increment. At every level, an agent merges only when the user explicitly authorizes that specific merge (see `GIT-4`).
- **`GIT-7` Never delete history, on GitHub either.** History is never deleted: not the repository's, and not the records kept on the platform that hosts the work. Working files that are not records may be deleted (`TRACE-7`).
  - **Close, never delete:** issues, pull requests, comments, project items, and labels in use are closed or marked as superseded, never deleted.
  - **Never rewrite published history:** no force-push, no rewriting a pushed commit (`GIT-4`).
  - **Changes that can replace records need the accountable person's approval first.** Some GitHub operations replace records wholesale — for example, updating a project's iteration settings recreates every iteration with a new identity. Before such a change, **list what it would remove** (for example, every iteration and the items linked to it), **ask the accountable person first**, and **after it, verify that every link is restored**.

## Naming

- **`NAME-1` Allowed types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`, `style`, `revert`.
- **`NAME-2` Branches:** `<type>/<short-kebab-case-description>`, e.g. `feat/user-login`, `fix/null-token-crash`, `docs/add-claude-md`.
- **`NAME-3` Commits:** [Conventional Commits](https://www.conventionalcommits.org/): `<type>: <short description>`, optionally with a scope, `<type>(<scope>): <short description>`. Write the subject in the imperative, lowercase, no trailing period, at most ~72 characters. Examples: `feat: add user login endpoint`, `fix(auth): handle expired tokens`, `docs: add CLAUDE.md with project rules`.

## Versioning

How a release's version number is chosen, so anyone can tell from the number alone whether upgrading may break them. The default follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html), described here in our own words; where kenaido differs, it says so (`SCRUM-4`).

- **`VER-1` Every release has a version `<major>.<minor>.<patch>`**, three whole numbers, stated once in the project and read from there by everything that ships it.
- **`VER-2` Which number goes up is decided by what the release does to the people who use it:**

  | Number | Goes up when the release… | Example |
  |--------|---------------------------|---------|
  | **major** | **breaks something:** a user must change what they do, or what they built on it, to keep working | a rule or file removed or renamed, an install layout moved, an interface changed incompatibly |
  | **minor** | **adds a feature, and stays backward compatible:** everything that worked still works | new files, a new command, a new option with a safe default |
  | **patch** | **fixes or improves the current minor version**, without adding a feature or breaking anything | a bug fix, a clearer message, a faster check |

  Raising a number resets the ones to its right to 0: `1.4.2` becomes `1.5.0` or `2.0.0`. **A kenaido adaptation:** Semantic Versioning keeps a patch to bug fixes; here a patch may also improve what the current minor version already does.
- **`VER-3` Each project names its public interface** — what its users rely on, and so what a breaking change breaks — in its own settings (`DOC-8`). When a change could be read as either a feature or a break, it is treated as a break (the stricter reading, as `PRIN-4` does for terms).
- **`VER-4` Before `1.0.0`, nothing is promised yet.** While the major number is 0, the interface may still change, as Semantic Versioning allows. **A kenaido convention, not a Semantic Versioning requirement:** a breaking change then raises the minor number, and the release notes say plainly that it breaks (`ETH-8`). Moving to `1.0.0` is a decision a person makes (`PRIN-2`), and go-live makes it (`VER-7`).
- **`VER-5` A released version never changes.** Whatever was released under a number stays as it was; a correction is a new release with a new number (`GIT-7`).
- **`VER-6` Every release says which number moved and why,** in its pull request and its release notes, so the reviewer can check the choice against `VER-2` (`ANLY-8`).
- **`VER-7` Go-live requires at least `1.0.0`.** The release that first puts a product into live use by its intended users is `1.0.0` or later. If the version has not reached `1.0.0` by then, that release is `1.0.0`, whatever `VER-2` would otherwise choose. From then on, the interface is a promise, and `VER-2` applies in full. Each project states in its own settings what counts as its go-live (`DOC-8`).
