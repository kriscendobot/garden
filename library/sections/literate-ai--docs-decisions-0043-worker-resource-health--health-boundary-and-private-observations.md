---
title: "ADR 0043: Worker health boundary and private observations"
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

> Abstract: Worker health is a short-lived scheduling observation over storage, quota, inode, memory, CPU, paging, progress, and GPU roles, not hardware authority or a safety guarantee.

Private policy maps roles on the actual worker with allocation, reserves, and probe budgets. Observations bind alias, job, policy, window, and expiry while withholding paths and distinguishing unsupported, denied, stale, unreachable, and malformed data.

Source: [docs/decisions/0043-worker-resource-health.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0043-worker-resource-health.md) at commit fcc40bc6.
