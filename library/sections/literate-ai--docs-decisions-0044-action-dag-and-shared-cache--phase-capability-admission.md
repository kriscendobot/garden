---
title: "ADR 0044: Phase capability and hardware admission"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [worker-observability, capability-security]
status: current
---

> Abstract: Opted-in workers answer bounded challenges with identity, receiver code, runtime, and hardware facts; admission composes these with health and revalidates before dispatch and acceptance.

Command workers opt into probing with an `action_protocol` declaration; without it the legacy identity stays and no capability is invoked. A declared worker answers a bounded, finite-deadline challenge with its configured identity, exact receiver code identity (canonical paths and bytes of package `.py` files, bounded to 65,536 entries, 4,096 files, 64 MiB, links refused), Python runtime identity, implemented actions (currently INDEX), and source-handoff support, never disclosing private paths or credentials. Observations older than five minutes, future-dated, or with changed routes or code refuse admission. Probes are capped at the earlier of the action deadline and 60 seconds (raised from 30 after native Windows evidence), with 16 KiB stdin/stdout, 4 KiB stderr, and owned descendants terminated.

Command phase admission composes fresh hardware eligibility, live capabilities, and an explicit health-admission identity, revalidated before dispatch and before accepting results; a failed candidate is excluded with a bounded public reason and an empty pool is an explicit refusal. The Standard rebuild factory binds an admitted INDEX pool and source-publication CAS as one configuration from private `action-execution.json` (or `LITAI_ACTION_EXECUTION_CONFIG`); an absent default keeps local indexing, invalid configuration refuses. Hardware comes from a separate `--describe-hardware` request collected by the worker itself, never substituted by the controller, and timestamped conservatively from probe start. Within one admission a verified observation is reused only while fresh and bound to the same worker; changed hardware facts invalidate it. Multi-worker probing keeps verified peers, removes stale observations for failed workers, never writes an empty success file, and reports failure when any probe fails.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
