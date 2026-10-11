---
title: "ADR 0035: Durable adoption-stage authority"
source: docs/decisions/0035-explicit-operator-adoption-state.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A canonical dynamic metadata file outside authored authority records explicit evidence-bound transitions from wrapped through retained and drafted to qualified.

The file uses bounded canonical JSON, symlink-resistant reads, exclusive locking, compare-and-swap identity checks, and atomic replacement. Conversion creates only `wrapped`; current retained-harness evidence permits `retained`; current derived projections permit `drafted`; regenerative qualification and independently verified promotion permit `qualified`.

No observer infers or silently advances a stage. Original source remains release authority until qualified, when specification authority becomes valid.

Source: [docs/decisions/0035-explicit-operator-adoption-state.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0035-explicit-operator-adoption-state.md) at commit `fcc40bc6`.
