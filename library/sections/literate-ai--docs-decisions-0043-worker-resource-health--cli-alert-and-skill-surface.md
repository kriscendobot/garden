---
title: "ADR 0043: CLI, alert, and skill surface"
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

> Abstract: One deterministic implementation powers health inspection, investigation, cleanup plan/apply, dispatch integration, deduplicated alerts, and a thin shipped skill.

Transitions emit structured events and concise alerts. Bounded private state deduplicates unchanged findings while preserving escalation and recovery; no daemon, account, or notification channel is added.

Source: [docs/decisions/0043-worker-resource-health.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0043-worker-resource-health.md) at commit fcc40bc6.
