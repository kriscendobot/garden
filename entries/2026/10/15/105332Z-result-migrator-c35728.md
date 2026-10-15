---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-15T10:53:34Z
job: kriscendobot-garden-book-pr15-gauntlet-panel-7
claim: 7a7ef7f3674424b7
---
Dispatch: migrator review of kriscendobot/garden-book PR #15 (base `main-5acd916`).

**Verdict:** request-changes

**Findings:**
- **must-fix** — `assembleBook` now unconditionally calls `artworkTree.lookup(...).bytes()` and `outputTree.writeBytes()` at `build/assemble-book.mjs:29,52`, so an existing caller using the formerly sufficient `text()`/`writeText()` tree contract now throws `TypeError` (`build/tree-io.mjs:9-14,26-32`). The PR changes the documented contract in `build/README.md:41-45`, but leaves the project version at `1.0.0` and supplies no migration or major-release marker. Preserve the prior adapter contract, or explicitly release this as a breaking migration and tell adapter authors to implement the binary methods. [rule: roles/jurors/migrator/AGENT.md § Operating norms] [rule: skills/changeset-discipline/SKILL.md § When to write one]

Self-improvement: nothing this time.
