---
title: "ADR 0018: Lexical binding versus runtime cursor"
source: docs/decisions/0018-never-empty-per-agent-model-stack.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Immutable parent-linked model bindings remain lock and cache identity, but they cannot serve as a per-agent runtime cursor that specifications can push, pop, query, and isolate during concurrent generation.

The ADR records a separate runtime stack whose first frame is the session model, whose
depth never reaches zero, and whose top selects the coding model. Component, Flavor,
skill, and authored-section scopes may change that cursor. The design is governed scope
because multiple plausible semantics existed for emptiness, inference, errors, and
representation.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
