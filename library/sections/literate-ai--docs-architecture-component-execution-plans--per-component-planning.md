---
title: Per-Component planning and generation identity
source: docs/architecture/component-execution-plans.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
---

> Abstract: Literate AI compiles an exact Component lock into independently cacheable per-node work whose generation key binds every authority-bearing input, avoiding one repository-wide model request and making reuse decisions explicit.

Planning rechecks dependency and interface constraints, selects an exact model for each node, computes per-node generation keys, and arranges work into stable provider-first layers. The resulting plan is versioned before any model call.

Each generation key covers the ordered specification documents, target and Flavors, implementation skills, workflow and routing policy, model, authored assets, exported public interfaces, and the exact public interfaces of dependencies. Operational transport details and cache locations do not enter semantic identity.

Source: [docs/architecture/component-execution-plans.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/architecture/component-execution-plans.md) at commit `2820f85`.
