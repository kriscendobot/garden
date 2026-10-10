---
title: Generated state and session boundaries
source: docs/architecture/repository-layout.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, sandbox-platforms]
status: current
---

> Abstract: Accepted generated source, disposable build objects, per-session tool environments, user-owned environments, and persistent coordination locks occupy separate paths with different cleanup rules, preventing cache cleanup from erasing authority or another agent's active interpreter and locks.

`generated/` is an advisory cache of fungible application source. `_build/` owns disposable objects, tools, package staging, binaries, and reports; forbidden build trees must be absent from both the working tree and reachable Git history. Load-bearing Components, Flavors, skills, and repository entrypoints never move into either generated-state bucket.

Framework Python environments are scoped by validated session ID below `_build/python-envs/`. Ordinary clean preserves that subtree, while an explicit exclusive reset may remove it. Persistent cache locks stay outside `_build`, so cleaning cannot unlink coordination state held by another process. A root `.venv` remains user-owned.

Source: [docs/architecture/repository-layout.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/repository-layout.md) at commit `fcc40bc`.
