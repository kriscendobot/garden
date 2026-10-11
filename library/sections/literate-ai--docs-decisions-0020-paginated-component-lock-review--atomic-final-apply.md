---
title: "ADR 0020: Atomic final apply"
source: docs/decisions/0020-paginated-component-lock-review.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Only a final command may replace the lock, after re-resolving and recomputing the whole diff and proving that every source, lock, selector, page, framework, policy, executable, and acknowledgement identity still matches.

No page writes partial authority. Final apply rechecks current lock bytes, proposed lock,
selectors, page chain, framework inputs, and source authority before atomically replacing
the lock and writing the ordinary resolution audit. Any drift invalidates the transaction
and requires a new review. Transaction state is derived and ignored: success removes it,
while abandoned or failed state remains diagnosable until explicit cleanup.

Source: [docs/decisions/0020-paginated-component-lock-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0020-paginated-component-lock-review.md) at commit `fcc40bc6` (source lines 60-74).
