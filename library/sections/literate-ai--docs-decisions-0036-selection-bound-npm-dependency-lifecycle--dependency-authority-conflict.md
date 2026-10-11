---
title: "ADR 0036: npm dependency authority conflict"
source: docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Package authority allowed a pinned npm closure while generation and build paths either prohibited dependencies or inferred permission from generated manifests, yielding non-executable or over-authorized artifacts.

Static lock and SBOM validation did not replay dependencies. Standard npm lock shapes also omit redundant names and preserve optional and peer relationships, so rejecting those shapes blocked the motivating dependency graph.

Generated `package.json` content cannot grant itself package-manager or network authority; exact Flavor selection must do so.

Source: [docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md) at commit `fcc40bc6`.
