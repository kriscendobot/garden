---
title: "ADR 0044: Selecting every safe compatible worker"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, worker-observability]
status: current
---

> Abstract: An identity-bound eligibility plan admits only fresh, healthy, capable, transport-complete workers; dispatch binds route and inputs, and failure cancels only descendants.

The controller reads the private execution-worker catalog and fresh observations through existing user-configuration adapters and derives an identity-bound eligibility plan from action requirements, target profile, OS/architecture, toolchain and accelerator capabilities, health/capacity decision, transport support, and slot count. A worker without explicit safe capacity gets one slot; unknown, stale, unhealthy, incompatible, or transport-incomplete workers are ineligible.

Ready work goes dynamically to idle eligible slots, preferring verified exact cache/artifact affinity and then stable worker ID for reproducibility. The dispatch request and result bind worker, catalog/observation identities, action, inputs, predecessors, cache decisions, and deadline, so a changed route or stale observation cannot resume as exact-current evidence. Command and SSH handlers must execute a serializable request on the selected worker (a locally run callback is not remote); predecessor exports cross workers only through verified content-addressed custody. Failure cancels transitive descendants, not independent branches.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
