---
title: "ADR 0015: Acceptance and invalidation matrix"
source: docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, software-supply-chain]
status: current
---

> Abstract: Acceptance requires explicit maintainer approval, an evidence-enumerated roadmap, one invocation for identical trees, invalidation on every evidence-defining input, tamper rejection, bounded non-secret diagnostics, fail-closed graph gates, and a green Linux/macOS/Windows matrix.

Reuse is denied when source, provider executable or runtime, extraction version,
capability contract, artifact bytes, or evidence envelope changes. Tests must show that
different workspace paths do not prevent independently verified reuse, while provider
failures remain actionable without exposing the sanitized environment. Both project
indexing and generated-source graph evidence continue to fail closed.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
