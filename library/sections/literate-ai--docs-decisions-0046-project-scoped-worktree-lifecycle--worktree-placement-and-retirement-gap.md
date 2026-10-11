---
title: "ADR 0046: Worktree placement and retirement gap"
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

> Abstract: Guidance prefers a repository-owned `.worktrees/` root, but the framework lacks one typed placement contract and its clean-worktree garbage collector cannot prove that legacy peer data is safe to delete.

Literate AI guidance now tells agents to create linked Git worktrees below an ignored
`.worktrees/` directory in the owning repository. The framework does not yet expose a
single typed placement contract that every command and generated skill can follow, and
older worktrees may still exist as top-level peers of their canonical checkout.

The current peer-work adapter lists registered worktrees and classifies their ordinary
status as clean or dirty. Its branch garbage collector can remove a registered clean
worktree after lifecycle-marker and review checks. That is not a migration proof. It
does not inventory ignored files, submodule worktrees, locks, active sessions, detached
useful commits, patch-equivalent history, independent clones, missing registrations or
retained qualification evidence. It also does not retain a per-worktree journal that
can resume after interruption and prove why removal was allowed.

Repository refresh already contains bounded common-directory, registered-worktree,
physical-file and concurrent-change custody primitives. Worktree migration should
reuse those boundaries where their contracts fit, but it must not treat a refresh
observation or a clean `git status` as authority to delete operator data.

Source: [docs/decisions/0046-project-scoped-worktree-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0046-project-scoped-worktree-lifecycle.md) at commit `fcc40bc6`.
