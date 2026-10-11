---
title: "ADR 0003: Consequences"
source: docs/decisions/0003-constraint-classification.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Documentation and release notes must name the owner of defaults, conformance tests protect authority-boundary invariants, strict repository policy need not bind every integration, and future architecture descriptions cannot be presented as delivered guarantees without the corresponding status and proof.

Documentation and release notes must identify defaults by owner instead of calling them
framework laws. Conformance tests should protect invariants at authority boundaries.
Repository policy may remain strict—such as the host sample matrix or an exactly pinned
runtime dependency set—without forcing every Literate AI project to adopt it.

The one-page flow remains the stable user story. Detailed architecture documents can
describe stronger future designs, but their status or roadmap heading determines
whether those statements are implemented claims.

Source: [docs/decisions/0003-constraint-classification.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0003-constraint-classification.md) at commit `fcc40bc` (source lines 76–85).
