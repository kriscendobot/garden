---
title: "ADR 0042: Verifier and consumer custody"
source: docs/decisions/0042-cpp-library-products.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security, testing]
status: current
---

> Abstract: Independent acceptance compiles verifier-owned code solely against sealed headers, binaries, and dependencies, then consumers bind those same identities.

Producer sources and caches are absent. Include, link, and loader paths exclude ambient lookalikes, a non-inline implementation is invoked, and header, binary, ABI, or dependency drift invalidates evidence.

Source: [docs/decisions/0042-cpp-library-products.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0042-cpp-library-products.md) at commit fcc40bc6.
