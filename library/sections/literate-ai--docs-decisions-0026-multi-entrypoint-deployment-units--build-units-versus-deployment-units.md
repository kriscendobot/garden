---
title: "ADR 0026: Build units versus deployment units"
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

> Abstract: One immutable Component revision remains the generation, source-cache, build, test, and publication unit, while each invocable entrypoint becomes an independently startable, restartable, and health-evidenced deployment unit.

The distinction captures operational topology without splitting every shared source tree
into unrelated build identities. A CLI, listening service, or scheduled loop is an
entrypoint; the corresponding deployment unit is the independent operational axis.
Restarting one unit need not restart its siblings.

Source: [docs/decisions/0026-multi-entrypoint-deployment-units.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md) at commit `fcc40bc6`.
