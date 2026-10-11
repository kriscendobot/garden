---
title: "ADR 0015: Rejected policy downgrades"
source: docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: The ADR rejects making CodeGraph advisory, removing it from the release, treating path shortening as the whole remedy, or keying reuse by source digest alone because each choice either weakens declared evidence or confuses unequal provider closures.

Advisory execution would let receipts claim a weaker boundary without a migration.
Removal would discard useful navigation and source-intelligence evidence through a much
larger provider-contract change. Shortening paths addresses one symptom but not repeated
execution over identical immutable trees. A source digest alone cannot distinguish
different executables, runtimes, schemas, or capability contracts.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
