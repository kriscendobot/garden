---
title: "ADR 0026: Compatibility and implementation consequences"
source: docs/decisions/0026-multi-entrypoint-deployment-units.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Additive version-2 contracts preserve byte-identical projection for existing single-entrypoint Components, while command projection, lock schemas, receipts, and acceptance dispatch absorb the complexity of independent multi-entrypoint operation.

Component-kind validation now considers the set of entrypoint kinds and still rejects
contradictions such as a library with an executable entrypoint. The implementation cost
is concentrated in the command contract and evidence schema; the payoff is independent
health, browser acceptance, and restart control for later durable-service designs.

Source: [docs/decisions/0026-multi-entrypoint-deployment-units.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md) at commit `fcc40bc6`.
