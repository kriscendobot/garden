---
title: Monorepo adoption: explicit root selection and shared-source custody
source: docs/architecture/monorepo-adoption.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: Under ADR 0039, build markers are only candidate roots and the default conversion stays a single retained wrapper; `litai onboard adopt PATH --root-plan SELECTION.json` reviews an explicit selection of nonoverlapping Component roots with operator-declared commands, and every remaining captured source file needs exactly one `shared_sources` owner with explicit consumers, a declared custody rather than an inferred dependency graph.

ADR 0039 (`docs/decisions/0039-1.1-capability-boundaries.md`) governs this design. Build markers are candidate roots, not inferred Components or proof of independent buildability. The default conversion remains a single retained wrapper.

`litai onboard adopt PATH --root-plan SELECTION.json` reviews an explicit `literate-ai/monorepo-adoption-selection@1` document. `components` contains unique portable `name` values, nonoverlapping detected `root` paths, and explicit `commands`. Every command specifies `id`, `command`, project-relative `cwd`, and a source-file `evidence` path. Commands are operator-reviewed declarations, not qualification; planning never executes them. Duplicate stage IDs within a Component are invalid.

Files beneath a selected root belong to that Component. Every remaining captured source file requires exactly one `shared_sources` assignment: `path` (a file or directory prefix), `owner` (Component name), and explicit `consumers` (other Component names, possibly empty). Assignments may not overlap one another or selected roots. This is custody and declared usage, not an inferred dependency graph. Root-level aggregate drivers do not automatically own their children's source. A command may cite its own source or explicitly shared input, and may run at the repository root or beneath its Component root. Cross-root invocation is not inferred.

The read-only result lists exact owned and shared input files per Component and binds their raw bytes, executable bits, selection, and commands into a content identity. The source universe is the existing retained-source capture policy (Git-visible tracked plus nonignored untracked files, or a pruned filesystem fallback). Uncaptured or ignored files are not silently admitted. A selection file inside that universe is itself source and needs ownership. Symlink/reparse source paths and separate Git histories are unsupported for refinement and refuse explicitly.

Source: [docs/architecture/monorepo-adoption.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/monorepo-adoption.md) at commit `fcc40bc`.
