---
title: "ADR 0044: Scheduler and shared-cache consequences"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, content-addressed-storage]
status: current
---

> Abstract: The controller becomes a bounded action scheduler but not a fleet provisioner; shared caching adds security and poisoning concerns contained by private configuration.

The controller becomes a bounded action scheduler, not a fleet provisioner: private dispatchers still own provisioning, queueing, leases, priorities, and machine lifecycle. More concurrency raises resource pressure, making worker-health admission and explicit slot limits part of correctness rather than optional telemetry. Shared caching speeds only reproducible actions with complete keys and adds server security, namespace, eviction, poisoning, and credential concerns, which the design contains in private configuration and verifier-owned admission; a network cache failure can slow but never invalidate a build or release.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
