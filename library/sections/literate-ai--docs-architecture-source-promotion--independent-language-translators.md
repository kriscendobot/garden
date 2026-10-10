---
title: Independent language translators
source: docs/architecture/source-promotion.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Inverse translation selects one content-pinned language skill per detected language, partitions admitted evidence before model egress, and requires exact evidence-to-surface coverage so model observations can propose behavior and graph structure without renaming, deleting, or inventing required public surfaces.

Python, C++, Rust, and JavaScript/TypeScript translators run separately from common architecture, behavior, test, security, and operations skills. A provider-neutral inventory gives each required surface a stable detector-owned identity, language, interface kind, exact evidence, and disposition. Model output may map those identities only when its reviewed skill facet agrees with the interface kind; unmapped required items and unknown semantics block derivation.

Every source path receives exactly one pre-egress disposition and byte count. Canonical batches bind each call's language, ordinal, and exact evidence IDs. Acceptance reconstructs the inventory, partition, and batch plan from retained provider-neutral intelligence and requires journals to match before merging observations. The semantic audit covers inputs, normalization, ordering, tie-breaking, outputs, errors, and language-implied runtime failures, not only symbol recovery.

Source: [docs/architecture/source-promotion.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/source-promotion.md) at commit `fcc40bc`.
