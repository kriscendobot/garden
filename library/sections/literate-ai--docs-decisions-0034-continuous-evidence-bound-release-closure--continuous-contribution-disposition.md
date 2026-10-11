---
title: "ADR 0034: Continuous contribution disposition"
source: docs/decisions/0034-continuous-evidence-bound-release-closure.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: A repeated content-identified sweep inventories tracker work, branches, and worktrees, while durable exact-state dispositions decide whether each contribution is included, deferred, merged, or otherwise resolved.

Python gathers and validates facts; the model decides relevance. Tracker items require agreeing milestones and machine-readable dispositions. Branches require a classified review, exact inclusion in the default branch, or a durable lifecycle disposition bound to their exact fetchable head.

Dirty or detached worktrees remain visible and block closure. Tracker changes invalidate old snapshots, unsupported tracker evidence fails explicitly, and issue closure cannot erase branch disposition authority.

Source: [docs/decisions/0034-continuous-evidence-bound-release-closure.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0034-continuous-evidence-bound-release-closure.md) at commit `fcc40bc6`.
