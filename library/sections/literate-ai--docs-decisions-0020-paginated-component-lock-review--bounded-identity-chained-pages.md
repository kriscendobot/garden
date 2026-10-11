---
title: "ADR 0020: Bounded identity-chained pages"
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

> Abstract: Each page carries at most 512 complete differences and is chained by exact identities; continuation acknowledges the reviewed page identity rather than trusting a page number, cursor, or force flag.

Pages preserve deterministic path ordering and carry transaction, page, total-page,
previous-page, and current-page identities. Missing, skipped, reordered, duplicated,
malformed, or cross-transaction acknowledgements fail closed. Pagination bounds only the
presentation surface: the full transaction still has separate ceilings for traversal
work and total differences, so the protocol does not authorize unbounded computation or
storage.

Source: [docs/decisions/0020-paginated-component-lock-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0020-paginated-component-lock-review.md) at commit `fcc40bc6` (source lines 44-58).
