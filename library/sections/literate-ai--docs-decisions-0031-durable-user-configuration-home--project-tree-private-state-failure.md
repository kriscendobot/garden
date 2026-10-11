---
title: "ADR 0031: Project-tree private-state failure"
source: docs/decisions/0031-durable-user-configuration-home.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Gitignored worker, test, and observation files were still wrongly coupled to one checkout, vulnerable to cleanup, duplication, and accidental inspection.

The operator catalog used a separate legacy application name, while changing channel journals lived beside authored configuration. Ignoring private files prevented commits but did not give those assets durable user custody or a coherent lifecycle.

Source: [docs/decisions/0031-durable-user-configuration-home.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0031-durable-user-configuration-home.md) at commit `fcc40bc6`.
