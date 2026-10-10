---
title: Package audit and decomposition
source: docs/architecture/repository-layout.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [repository-governance]
status: current
---

> Abstract: The package audit finds the top-level domain structure adequate and locates structural debt in a few oversized lifecycle, CLI, workflow, and coding-agent modules, recommending call-graph-guided splits along typed ports rather than directory churn or line-count-only decomposition.

Most Python modules already sit under named domains such as contracts, application, adapters, CLI, and source-to-specification. The remaining direct package modules cover cross-cutting facade and project concerns. Moving those directories would not clarify ownership.

The actionable debt is concentrated in modules several thousand lines long. Their decomposition is tracked separately and must preserve behavior through evidence gates; raw line counts are signals for investigation, not architectural boundaries.

Source: [docs/architecture/repository-layout.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/repository-layout.md) at commit `fcc40bc`.
