# Coding

How code is planned, designed, and written, and the quality attributes every design must cover.

- **`CODE-1` Best practices.** Always follow coding best practices.
- **`CODE-2` Plan first.** Before changing code, make a plan and follow it. For significant changes, share the plan with the user before starting.
- **`CODE-3` No rework.** Order the plan so prerequisites are built first and every step rests on finished work. Run tasks that don't depend on each other in parallel.
- **`CODE-4` Clean Code.** Apply Clean Code principles: clear names, small functions that do one thing, no duplication, clear error handling, and code that reads easily.
- **`CODE-5` Design patterns.** Know and apply design patterns where they fit: the classic Gang of Four patterns (creational, structural, behavioral) and newer ones such as dependency injection, repository, or ports and adapters. Don't force a pattern where it adds nothing.
- **`CODE-6` Loose coupling.** Parts of the system depend on each other only through clear interfaces, never on each other's internals, so each part can change or be replaced on its own.
- **`CODE-7` SOLID.** Apply all five principles:
  - **S:** each class or module has one reason to change.
  - **O:** open to extension, closed to modification.
  - **L:** a subtype must work anywhere its parent type works.
  - **I:** small, focused interfaces instead of large general ones.
  - **D:** depend on abstractions, not on concrete implementations.
- **`CODE-8` Contract first.** Define each interface in a contract before writing the code, e.g. OpenAPI 3 for HTTP APIs. Build and test the code against the contract.
- **`CODE-9` Quality attributes are mandatory.** Every design must cover these; more may be added:

  | Attribute | Meaning |
  |-----------|---------|
  | Security | Only the right people and systems can do the right things |
  | Data protection | Personal and sensitive data is kept safe and handled lawfully |
  | Observability | Logs, metrics, and traces show what the system is doing |
  | Maintainability | Code is easy to understand, change, and test |
  | Availability | The system is up when people need it |
  | Operability | The system is easy to deploy, configure, run, and support |
  | Reliability | The system works correctly and recovers from failures |
  | Disaster recovery | Data and service can be restored after a major failure, within agreed time and data-loss limits |

- **`CODE-10` Default for every project.** These rules are the default setup for any project built with kenaido. Users can change some of them to fit their needs, but some will likely stay mandatory in every case, so the app can't be used to create poor-quality projects or code. Which rules are locked is still open.
- **`CODE-11` kenaido included.** All of the above also applies to the kenaido app itself.
