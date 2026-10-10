---
title: Promotion boundaries and regenerative qualification
source: docs/architecture/source-promotion.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Review may promote a source-derived specification to intent authority, but release implementation authority remains with the exact original source until multiple clean spec-to-source rebuilds pass generated tests, independent parity, complete target/surface coverage, and distinct attestation.

Qualification starts in empty workspaces with the original source excluded from generation context and generated-source cache disabled. The original baseline appears only at the independent parity boundary. Each evidence record binds source snapshot, reviewed specification, target, Flavor lock, recipe, generated tree, build, tests, parity, coverage, cache status, and workspace facts.

The minimum clean-run count applies to every required target, not the matrix in aggregate. Empty target or surface sets, reused attestations, stale locks, partial coverage, cache hits, failed baselines, or caller-supplied evidence leave `source-baseline` as the effective release authority. Completed signed run checkpoints may resume interrupted qualification without reusing generated source.

Source: [docs/architecture/source-promotion.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/source-promotion.md) at commit `fcc40bc`.
