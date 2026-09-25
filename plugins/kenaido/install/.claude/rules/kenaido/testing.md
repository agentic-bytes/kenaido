# Testing and quality checks

Code generated without proper checks can be poor quality. Like the coding rules (`CODE-10`, `CODE-11`), these are the default for every project and apply to kenaido too — including to the scripts, hooks, and workflows that run the checks themselves.

- **`TEST-1` Add checks.** Where applicable, always add:
  - **a.** Unit tests
  - **b.** Integration tests
  - **c.** End-to-end (e2e) tests
  - **d.** Security scans of the code and its dependencies
  - **e.** Secret scans, so no passwords, keys, or tokens end up in code or history
  - **f.** Lint checks
  - **g.** Build checks, confirming the application builds
- **`TEST-2` CI/CD pipeline.** Where possible, add a CI/CD pipeline (automated checks and delivery) that runs the checks above on every change before it merges. **When the pipeline runs is a project setting** (`DOC-8`): on every push, or once a change is ready for merging, whichever fits the pipeline allowance the project has. The full checks still run locally on every change while it is worked on. A pipeline job that was skipped is not a pass: before merging, confirm that it ran.
- **`TEST-3` Infrastructure as code.** Where appropriate, test infrastructure as code (IaC) too, e.g. with validation, linting, and security policy checks.
- **`TEST-4` Only proven, enterprise-grade tools, and free ones.** A tool enters this project — a scanner, a linter, an action, a container image, a library, a service — only when it clears every line below. Being available on GitHub, in a marketplace, or in a package registry is **not** a reason to adopt anything.

  | Requirement | How it is checked, before adoption |
  |-------------|-----------------------------------|
  | **Free at the tier we use** | No paid plan in the critical path |
  | **Widely used in serious production settings** | Named users, an ecosystem, or a distribution channel a large organization would rely on. Where adoption cannot be verified from here, say so and label it unverified (`ANLY-2`) — an unverifiable claim of adoption is not evidence of it |
  | **Actively maintained** | Not archived or deprecated, a release within the last few months, and issues being answered. Check it at the source, don't assume it |
  | **Clear, compatible license** | Recorded per tool, with the effect on our own distribution (`COMM-4`). A tool we merely run is not a tool we ship; say which it is |
  | **Known provenance** | A named organization or maintainer team behind it, released through an official channel, signed or digest-addressable |
  | **Pinned** | Every use pins an exact version **and** a content digest, so a run cannot silently change under us |
  | **Scanned** | The tool itself passes `TEST-5` before it is used, and again when its version changes |
  | **Recorded** | The tool, its version, its license, its evidence, and the reason it was chosen go in `project/notes/tool-inventory.md`; adopting or replacing one is a recorded decision (`PRIN-3`) |

  **No exceptions, and that includes our own scripts**: every script, hook, workflow, and helper in this repository is held to the same bar as the product, is linted, is scanned, and pins every tool it calls. When nothing clearing this bar exists for a job, the job is done by hand and recorded as a gap — not by reaching for an unproven tool.
- **`TEST-5` Know what is in the code, and scan it.** Two scans run on every change, locally through `scripts/check.sh` while it is worked on, and in the pipeline before it merges (`TEST-2`):
  - **A software bill of materials** with **syft**: an inventory of everything the repository contains and depends on, generated fresh rather than maintained by hand.
  - **A vulnerability scan** with **grype**, against that inventory. It fails the run at the agreed severity, and the threshold may be lowered but never raised without a recorded decision.

  Both also run **before a new tool or dependency is adopted**, and again when its version changes: a tool that introduces a vulnerability is a vulnerability, whoever published it. A finding is fixed, or a person accepts it as a risk with a reason and a review date — never silently ignored, and never waved through by an agent (`PRIN-2`). Everything in the repository is in scope, our own scripts included.
