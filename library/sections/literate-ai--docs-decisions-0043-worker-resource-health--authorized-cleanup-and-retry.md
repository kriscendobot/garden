---
title: "ADR 0043: Authorized cleanup and retry"
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

> Abstract: Cleanup requires fresh exact authorization for named targets and operations, followed by revalidation, supported-tool execution, post-cleanup measurement, and bounded retry.

Authorization binds worker, target, policy, and expiry. Changed targets require a new proposal; recovered capacity is measured, retries require fresh sufficient evidence, and failures never widen deletion scope.

Source: [docs/decisions/0043-worker-resource-health.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0043-worker-resource-health.md) at commit fcc40bc6.
