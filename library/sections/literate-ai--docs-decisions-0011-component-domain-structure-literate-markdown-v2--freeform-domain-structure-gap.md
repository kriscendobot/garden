---
title: "ADR 0011: Freeform domain-structure gap"
source: docs/decisions/0011-component-domain-structure-literate-markdown-v2.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Component metadata expressed authority plumbing but left protocols, schemas, measurable acceptance, and other domain structure in bounded freeform prose, forcing framework prompt special cases and leaving acceptance selectors untyped and unenforced.

Component Markdown already named coordinates, capabilities, Flavor slots, entrypoints,
source dependencies, assets, and provider resolution. Semantic structure remained in a
16 KiB description that no machine could validate. The Rust/JavaScript sample's output
fields, argument wiring, and role layout consequently entered the framework prompt
builder before being moved into sample prose.

Acceptance contracts were untyped URI selectors, and the starter sample declared none.
The independent-verifier architecture and lock binding were already suitable; the gap
was typed structure, not a new trust model. Adding keys to v1 was unavailable because
strict unknown-key rejection and published-schema immutability must remain intact.

Source: [docs/decisions/0011-component-domain-structure-literate-markdown-v2.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0011-component-domain-structure-literate-markdown-v2.md) at commit `fcc40bc6` (source lines 1-33).
