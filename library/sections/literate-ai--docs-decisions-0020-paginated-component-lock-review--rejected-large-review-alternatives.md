---
title: "ADR 0020: Rejected large-review alternatives"
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

> Abstract: The ADR rejects ambient limit increases, deleting old authority, partial locks, and mandatory graph refactoring because none proves bounded review of one legitimate indivisible transition.

Removing or increasing the 512-entry limit weakens the review surface. Deleting and
regenerating the old lock discards the very authority being compared. One partial lock per
page would be syntactically valid but semantically represent neither old nor newly
resolved authority. Smaller Component graphs may be good design, but cannot be the
general remedy when a parent transition legitimately changes one root lock extensively.

Source: [docs/decisions/0020-paginated-component-lock-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0020-paginated-component-lock-review.md) at commit `fcc40bc6` (source lines 83-104).
