---
title: "ADR 0026: Entrypoint cardinality and authority"
source: docs/decisions/0026-multi-entrypoint-deployment-units.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Every entrypoint resolves to one uniquely named deployment unit, but cooperating surfaces that must not share private authority should still be modeled as separate Components connected by public capability edges.

The common single-entrypoint case keeps an implicit same-named unit. Multi-entrypoint
Components may also default each unit name from its entrypoint, while duplicate resolved
names fail closed because execution, receipt, restart, and acceptance selectors would
otherwise be ambiguous. Shared authority is the criterion for grouping, not convenience.

Source: [docs/decisions/0026-multi-entrypoint-deployment-units.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md) at commit `fcc40bc6`.
