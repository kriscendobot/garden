---
title: External source dependencies remain external
source: docs/architecture/source-promotion.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: An ordinary source-only open-source dependency is pinned, inspected, built in quarantine, and admitted to an immutable external source cache; it becomes a Component only when the project deliberately pays the stronger review and regenerative-qualification cost to make specification authority outrank original implementation.

The distinction prevents adoption from silently rewriting dependency provenance. External-source admission preserves exact source authority, while promotion is an explicit architectural choice to replace that authority with reviewed regenerative intent.

Source: [docs/architecture/source-promotion.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/source-promotion.md) at commit `fcc40bc`.
