---
title: "ADR 0044: Event-driven ready queue and slot bounds"
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

> Abstract: One deterministic event-driven ready queue orders all ready work, including repairs, under explicit per-worker slots and a global cap where `--jobs` is only a cap.

A run uses one deterministic event-driven ready queue, ordering equally ready work by canonical action identity. Source generation and resumed or repaired phases enter the same queue, so no separate generation loop gives post-source phases implicit priority. Controller continuations advance without occupying a worker slot; only ready actions are admitted under the shared slot bound. Candidate repairs re-enter at their actual phase and keep their original failure and retry evidence. The scheduler keeps explicit per-worker slots and a global cap: omitted `--jobs` uses every safe available slot, and an explicit value is only a cap, never permission to exceed worker capacity.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
