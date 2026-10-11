---
title: "ADR 0046: Qualification and rollout"
source: docs/decisions/0046-project-scoped-worktree-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [testing, repository-governance]
status: current
---

> Abstract: Qualification spans cross-platform placement, ambiguous layouts, every meaningful worktree state, retained changes, independent clones, failures, races, interruption, and proof for every removal.

Implementation proceeds under the explicit maintainer acceptance recorded on
2026-09-25. Qualification must cover:

- location derivation from canonical and linked checkouts on supported platforms,
  including path length, case folding, symlink or reparse ancestors and collisions;
- provider-neutral parity across framework commands, authored skills and initialized
  project templates;
- two repositories sharing a parent without cross-project candidate admission;
- dirty, staged, untracked, ignored, detached, locked, prunable, missing, active and
  submodule-bearing worktrees;
- useful commits, already-merged ancestry, patch-equivalent changes and explicitly
  rejected superseded work;
- independent clones, ordinary peer directories and ambiguous or changing Git custody;
- failed review/landing, failed retention, failed removal, concurrent mutation and
  interrupted/resumed migration; and
- a reviewed journal proving that every removed worktree was freshly revalidated and
  every useful byte or commit has a durable destination.

Roll out in three reviewable slices: canonical placement and guidance parity; read-only
discovery, audit and journal resumption; then explicitly authorized migration and
Git-aware removal. The first two slices must not remove legacy directories.

Source: [docs/decisions/0046-project-scoped-worktree-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0046-project-scoped-worktree-lifecycle.md) at commit `fcc40bc6`.
