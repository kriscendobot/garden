---
title: "ADR 0020: Large-review transaction"
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

> Abstract: A genuine lock diff beyond the ordinary 512-entry review limit starts a separate ignored transaction that binds both lock identities, resolution inputs, ordering rules, page identities, and framework policy without changing authority.

The existing limit correctly keeps one response bounded but cannot review a downstream
transition with more than 512 actual semantic changes. Deleting the old lock would erase
the authority under review, raising the limit would make output unbounded, and partial
writes would not correspond to a resolved plan. Ordinary lock, check, and diff commands
therefore keep failing closed; an explicit transaction records the project, Component,
target, ordered Flavors, exact old lock bytes and identity, proposed identity, diff
version, counts, page identities, and installed framework and policy identities.

Source: [docs/decisions/0020-paginated-component-lock-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0020-paginated-component-lock-review.md) at commit `fcc40bc6` (source lines 1-42).
