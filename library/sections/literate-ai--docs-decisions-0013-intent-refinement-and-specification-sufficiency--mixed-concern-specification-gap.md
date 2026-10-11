---
title: "ADR 0013: Mixed-concern specification gap"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Literate AI's validation, lock, and planning gates begin after authors know what to specify, leaving abstract requests vulnerable to plausible but unauthorized model choices when one product mixes UI, protocol, numerical, hardware, measurement, and deployment concerns.

Existing authorities distinguish Component behavior, public contracts, Flavors, assets,
skills, and acceptance evidence, but do not tell a user whether an initial mission is
complete enough to become those authorities. A distributed pi-service request exposes
the gap: its presentation, lifecycle, numerical correctness, CPU/GPU realization,
resource accounting, and machine placement require different kinds and depths of
specification.

A compiling program, convincing generated tests, model confidence, and a structurally
valid Component cannot establish that omitted product decisions match user intent.
Likewise, one HIGH, MEDIUM, or LOW label for an entire project either under-specifies
hard concerns or pushes needless implementation detail into simple ones. The proposed
boundary instead decomposes intent, selects authority per concern, exposes decisions,
and gives users a stopping rule before generation authority exists.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 8-54).
