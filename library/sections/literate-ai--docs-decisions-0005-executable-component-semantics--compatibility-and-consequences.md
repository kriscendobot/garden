---
title: "ADR 0005: Compatibility and consequences"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The new version-2 contracts establish executable vocabulary for interfaces, edges, selections, assets, repair, driver trust, and invalidation without claiming the current flattened CLI planner implements it; maintained identity-bearing public interfaces are the deliberate cost of bounded agent context and reviewable propagation.

These are new version-2 wire contracts. They do not change the frozen version-2
Component definition or claim that the current CLI planner already honors the boundary.
Catalog registration is additive. Existing flattened generation remains a known
temporary implementation gap until `LOCK-200`, `SPEC-205`, and `DAG-210` land.

The immediate benefit is one executable vocabulary for those later slices: interfaces,
edges, node selections, assets, repair, driver trust, and invalidation can no longer be
reinterpreted independently by each adapter. The cost is that public interfaces and
re-exports become maintained, identity-bearing API artifacts. That cost is intentional:
it is what bounds coding-agent context and makes change propagation reviewable.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 161–172).
