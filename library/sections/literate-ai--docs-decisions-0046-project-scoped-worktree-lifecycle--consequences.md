---
title: "ADR 0046: Consequences"
source: docs/decisions/0046-project-scoped-worktree-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [repository-governance, agentic-sdlc]
status: current
---

> Abstract: Agents gain one discoverable worktree root, while cleanup becomes slower but preserves the distinction between appearing clean and being proven safe to retire.

Agents and commands gain one discoverable worktree root, and legacy cleanup becomes an
evidence-bearing project operation rather than an ad hoc sibling-directory sweep. The
extra observations and operator dispositions make migration slower, but preserve the
important distinction between a worktree that looks clean and one proven safe to
retire.

Repositories with bare, ambiguous or unsafe layouts receive a typed refusal instead of
an external temporary-directory fallback. Supporting independent-clone retirement or a
different persistent placement root requires a later explicit contract.

Source: [docs/decisions/0046-project-scoped-worktree-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0046-project-scoped-worktree-lifecycle.md) at commit `fcc40bc6`.
