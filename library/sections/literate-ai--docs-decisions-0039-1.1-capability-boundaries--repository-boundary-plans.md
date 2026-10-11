---
title: "ADR 0039: Repository boundary plans"
source: docs/decisions/0039-1.1-capability-boundaries.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Monorepo selection, submodule orchestration, and retained-source refresh remain three explicit reviewed plans rather than one inferred or flattening conversion.

Monorepo adoption acknowledges nonoverlapping ownership and shared sources. Submodule orchestration preserves Gitlinks and child histories. Scope refresh binds inventories, invalidates receipts, and requires requalification; ambiguity and dirty or unpublished children fail closed.

Source: [docs/decisions/0039-1.1-capability-boundaries.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0039-1.1-capability-boundaries.md) at commit fcc40bc6.
