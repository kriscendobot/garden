---
title: "ADR 0040: Incremental Cargo bridge gap"
source: docs/decisions/0040-retained-cargo-library-bridge.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Retiring one provider crate requires an exact qualified-package bridge without converting every consumer or making generated source a second authority.

Path dependencies and workspace membership otherwise point at absent source. Ignored caches are not reproducible, committed generated packages compete with authority, and model reruns do not consume accepted bytes.

Source: [docs/decisions/0040-retained-cargo-library-bridge.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0040-retained-cargo-library-bridge.md) at commit fcc40bc6.
