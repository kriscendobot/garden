---
title: "ADR 0020: Automation-safe interface"
source: docs/decisions/0020-paginated-component-lock-review.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Machine-readable start, acknowledge, status, apply, and cleanup operations expose stable reason codes and bounded results, while interactive shells remain optional presentations of the same protocol.

The large-review interface cannot depend on an interactive-only prompt. Continuous
integration, coding agents, and accessibility tools receive the same complete protocol
and deterministic results as a human shell, which may add ergonomic presentation without
changing acknowledgement or application semantics.

Source: [docs/decisions/0020-paginated-component-lock-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0020-paginated-component-lock-review.md) at commit `fcc40bc6` (source lines 76-81).
