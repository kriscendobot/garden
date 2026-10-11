---
title: "ADR 0043: Health classification and dispatch"
source: docs/decisions/0043-worker-resource-health.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, worker-observability]
status: current
---

> Abstract: Health findings and job decisions are separate: bounded evidence yields healthy, warning, critical, or unknown plus proceed, hold, or retry-after-recheck.

Pressure combines utilization with stalled progress, paging, failures, or queue impact. One classifier serves admission, polling, and failures; it may reduce only authorized concurrency or select an authorized worker, never kill unrelated processes.

Source: [docs/decisions/0043-worker-resource-health.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0043-worker-resource-health.md) at commit fcc40bc6.
