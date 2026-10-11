---
title: "ADR 0043: Bounded read-only investigation"
source: docs/decisions/0043-worker-resource-health.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [worker-observability, capability-security]
status: current
---

> Abstract: Disk incidents trigger only a bounded read-only scan of task-owned locations, producing identity-bound cleanup candidates without deletion authority.

Traversal limits entries, depth, accounting, and time, rejects link traversal, and reports partial scans. Candidates bind identity, size, ownership, active-use uncertainty, and recovery cost; uncertain data remains protected.

Source: [docs/decisions/0043-worker-resource-health.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0043-worker-resource-health.md) at commit fcc40bc6.
