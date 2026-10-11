---
title: "ADR 0027: Coherent snapshot publication"
source: docs/decisions/0027-durable-split-service-pattern.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A collection window becomes current only after all required writes validate, so readers see either the prior complete snapshot or the new complete snapshot and never partial collection state.

This is a cache-capability postcondition rather than an implementation suggestion left
for generated code. Failed collection preserves availability from the last completed
snapshot while acceptance tests can check that incomplete windows are never published.

Source: [docs/decisions/0027-durable-split-service-pattern.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0027-durable-split-service-pattern.md) at commit `fcc40bc6`.
