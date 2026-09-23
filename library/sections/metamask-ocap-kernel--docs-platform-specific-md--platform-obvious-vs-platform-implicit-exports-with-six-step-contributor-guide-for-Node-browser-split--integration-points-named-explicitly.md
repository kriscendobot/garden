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
title: §Integration-points-named-explicitly
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

For Node:
- `vat-worker.ts` — vat-related features.
- `make-kernel.ts` — kernel construction features.

For browser:
- `kernel-worker.ts` — kernel worker functionality.
- `iframe.ts` — vat iframe functionality.

§Don't-leave-the-contributor-guessing-where-to-wire-things-
in. §Concrete-file-paths-as-integration-targets. §The-
contributor-knows-which-file-to-edit-from-step-5.

§Endo-comparison: Endo's contributor docs typically say
"register your service" without naming the file. §Synthesis-
target: §name-the-integration-file would make Endo
contributor work more concrete.
