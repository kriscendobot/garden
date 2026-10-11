---
title: "ADR 0027: Scheduler and lease authority"
source: docs/decisions/0027-durable-split-service-pattern.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance, testing]
status: current
---

> Abstract: Scheduling is generation guidance for an application's worker, not a framework daemon, and persists jitter choice, completion, retry, and an expiring single-writer lease in the same store that guards cache writes.

The contract uses injectable clocks and randomness, preserves a chosen instant across
restart, prevents rerunning a completed window, and permits recovery after an expired
lease. Retry state is distinct from the next daily schedule. Lease and cache share one
migration lineage because both enforce the same single-writer invariant.

Source: [docs/decisions/0027-durable-split-service-pattern.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0027-durable-split-service-pattern.md) at commit `fcc40bc6`.
