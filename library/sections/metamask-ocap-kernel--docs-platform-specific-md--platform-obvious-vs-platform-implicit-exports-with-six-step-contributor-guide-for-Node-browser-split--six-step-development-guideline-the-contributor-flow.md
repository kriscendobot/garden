---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §Six-step-development-guideline (the contributor flow)
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

The doc's §single-most-structurally-interesting-move: a
numbered §six-step-flow for adding a platform-specific
feature:

1. **§Package-Creation** — create or reuse a package.
2. **§Platform-Agnostic-Implementation** — implement
   shared types and abstractions in `my-package/src/`.
3. **§Platform-Specific-Implementation** — choose simple
   (`<platform>/`) or complex (`<feature>/<platform>/`)
   directory structure.
4. **§Package-Configuration** — update `package.json`
   exports.
5. **§Platform-Integration** — wire into runtime package.
6. **§End-to-End-Testing** — add tests to the per-
   platform e2e package.

§Steps-are-ordered-with-explicit-dependency. §Abstraction-
first-then-platforms-then-integration-then-tests. §Tests-
come-last-not-out-of-laziness-but-because-they-validate-
the-prior-five-steps.

§Endo-comparison: Endo's contributor docs (cycle 17's
top-level CONTRIBUTING + per-package READMEs) don't have
this clean a §named-flow for adding platform-specific
features. §Synthesis-target: §six-step-named-flow could
be adopted for Endo's platform additions.
