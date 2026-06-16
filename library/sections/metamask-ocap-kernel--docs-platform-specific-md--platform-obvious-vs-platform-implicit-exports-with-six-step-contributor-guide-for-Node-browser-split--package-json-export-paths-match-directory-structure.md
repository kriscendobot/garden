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
title: §Package-json-export-paths-match-directory-structure
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> *Ensure the export paths match your implementation
> directory structure and follow the project's naming
> conventions.*

§Discipline-named: §directory-structure-becomes-export-
paths. §No-mismatch-between-filesystem-and-package-graph.

§Why-this-matters: when the directory structure and export
paths diverge, the reader must do §two-lookups to find code
(open package.json, find the export path, find the file).
When they match, §one-lookup suffices. §Reduce-cognitive-
overhead-by-removing-renames.

§Endo-cycles-67-69-marshal observation: Endo's marshal
package has some indirection between exports and file paths
(historical baggage). The convention here would reduce
that overhead going forward.
