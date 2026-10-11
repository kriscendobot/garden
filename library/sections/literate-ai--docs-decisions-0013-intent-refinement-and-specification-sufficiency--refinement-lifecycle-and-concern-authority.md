---
title: "ADR 0013: Refinement lifecycle and concern authority"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Refinement inserts a non-authoritative design draft and explicit human review before accepted authoring, while assigning every concern to the narrowest authority that can make its acceptance decidable instead of choosing one project-wide specification level.

The lifecycle becomes mission request, draft, explicit decisions, authored authority,
validation, lock, plan, generation, and acceptance. Refinement may use deterministic
analysis or an agent, but it is not generation and cannot accept specifications.
Validation still proves structure, lock still resolves exact identities without a
model, and plan still proves that locked inputs form an exact generation plan.

Concern shape determines authority. Product outcomes belong in Component behavior;
independently deployed surfaces become Component revisions; cross-Component exchanges
need versioned public contracts; numerical work adds properties, bounds, and independent
oracles; literal vectors become content-pinned assets; protocols may use appropriate
structured providers; target selection belongs to Flavors; reusable techniques belong
to skills; local invariants use language-native contracts; and proof belongs to
acceptance contracts with verifier-only evidence. Representation follows semantics,
not apparent complexity.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 56-111).
