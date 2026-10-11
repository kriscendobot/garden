---
title: "ADR 0015: Exact evidence custody reuse"
source: docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A cache hit reuses verified immutable graph evidence rather than skipping source intelligence, and its key covers the exact source snapshot, provider contract and executable, runtime, extraction schema, canonical artifact path, and required relationship capabilities.

Project indexing remains mandatory wherever policy requires graph-derived evidence. On
an exact key hit, the framework verifies the evidence envelope, artifact digest, source
manifest, provider/runtime closure, and required graph properties before reuse. Missing,
stale, corrupt, differently keyed, or foreign-provider custody invokes CodeGraph and is
published atomically only after verification.

Equal trees may share custody across different disposable host paths because paths are
not evidence-key material. The reusable index remains a derived attachment in
framework-owned cache custody and is never copied into source authority.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
