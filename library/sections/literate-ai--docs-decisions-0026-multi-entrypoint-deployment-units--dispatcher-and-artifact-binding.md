---
title: "ADR 0026: Dispatcher and artifact binding"
source: docs/decisions/0026-multi-entrypoint-deployment-units.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: `litai run COMPONENT --entrypoint NAME` selects an entrypoint explicitly, while omitted selection preserves first-entrypoint compatibility and remote locators bind both artifact bytes and the execution manifest.

The existing serve mode becomes one case of a generalized dispatcher. Local exports
retain a shared artifact root with a closed identity-bound command set. Remote worker
cache locators include command identity as well as payload identity so equal bytes with
different execution semantics cannot reuse stale state.

Source: [docs/decisions/0026-multi-entrypoint-deployment-units.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md) at commit `fcc40bc6`.
