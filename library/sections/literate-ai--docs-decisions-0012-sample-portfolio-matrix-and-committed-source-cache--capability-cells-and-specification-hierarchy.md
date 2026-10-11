---
title: "ADR 0012: Capability cells and specification hierarchy"
source: docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, repository-governance]
status: current
---

> Abstract: Each sample owns explicit language, OS, build, packaging, deployment, and skill cells at a starter, composed, or frontier tier; redundant proposals must add a cell or tier, and complex examples keep product intent, interfaces, and target-specific Flavor requirements in their proper authority layers.

The three tiers progress from one Component and slot family, through multi-Component
graphs and packaging, to multi-language roles, accelerators, deployment images, and
multiple repositories. Review rejects a new sample that duplicates owned cells without
adding coverage or complexity.

Composed and frontier samples use the full specification hierarchy. Component Markdown
contains observable product intent, named wire contracts live under declared
specification roots, and target-specific requirements come only from selected Flavors
and their pinned skills. Flavor-specific implementation rules do not leak back into
Component prose.

Source: [docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md) at commit `fcc40bc6` (source lines 31-48).
