---
title: "ADR 0039: Bounded execution claims"
source: docs/decisions/0039-1.1-capability-boundaries.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Execution must state its actual isolation level, require acceptance and acknowledgment, and refuse unavailable containment instead of silently weakening the requested boundary.

The original boundary authorized same-user local execution and made host-resource exposure explicit. ADR 0041 later superseded that release scope with full containment while leaving local-execution claims accurate until new backends qualify.

Source: [docs/decisions/0039-1.1-capability-boundaries.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0039-1.1-capability-boundaries.md) at commit fcc40bc6.
