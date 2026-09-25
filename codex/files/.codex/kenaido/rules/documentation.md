# Documentation

What project documentation covers, who it's for, and how it stays current.

- **`DOC-1` Tied to the architecture.** Documentation describes the application's architecture and follows its structure.
- **`DOC-2` Always current.** Update documentation in the same change as the code it describes, so it always matches the current code.
- **`DOC-3` Readable where it's read.** Where the tool a team uses has a documentation panel or an equivalent view, write documentation so it reads well there, for both users and agents.
- **`DOC-4` Follows the communication rules** in [`communication.md`](communication.md) (`COMM-1` to `COMM-7`).
- **`DOC-5` Professional and easy for every reader.** Structure it so business and technical readers of any seniority quickly find and understand what they need: open each document with a short summary, then go into detail.
- **`DOC-6` Complete.** Describe every part of the application: components, infrastructure (if any), sequences (how parts interact over time), data (models, flows, and storage), interfaces, and so on. Use diagrams where they help.
- **`DOC-7` Standard sections.** Include at least: architecture decision records (ADRs, in the project's record: `project/decisions/` under `DOC-8`), a new joiner's guide, a glossary, project setup, and a quick start, plus any other section that helps readers.
- **`DOC-8` Keep the product separate from the record of how it is built.** Every project built with kenaido keeps two areas apart. The **product**, which its users receive, goes in `product/`. The **project's own record** — decisions, Sprints, task briefs, interaction records, notes, and the project's own settings — goes in `project/`. The repository's own setup (instructions for the agent tools, checks, CI) stays at the root.
  - **Links point one way:** the record may link to the product; the product never links to the record, and a check on every change enforces it.
  - **The product is written generically:** no dates, quotes, or decisions of the project that built it, and no names of who holds a role there.
  - This is the default approach. It is re-evaluated if evidence shows a better way to keep the record of building a product.

