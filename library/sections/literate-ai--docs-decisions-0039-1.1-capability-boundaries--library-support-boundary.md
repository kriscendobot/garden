---
title: "ADR 0039: Importable library support boundary"
source: docs/decisions/0039-1.1-capability-boundaries.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, testing]
status: current
---

> Abstract: A provider-neutral library contract starts with independently accepted Python pure functions, exact in-process consumer binding, drift invalidation, and refusal for unqualified languages.

The contract names exports, call shapes, artifact identity, runtime or ABI requirements, and consumer binding. Verifier-owned code imports exact bytes in-process; qualification covers negative cases, regeneration, drift, and retirement of one retained boundary.

Source: [docs/decisions/0039-1.1-capability-boundaries.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0039-1.1-capability-boundaries.md) at commit fcc40bc6.
