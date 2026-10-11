---
title: "ADR 0015: Bounded provider diagnostics and scope"
source: docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Failed CodeGraph operations retain separate bounded stdout and stderr with operation, exit or timeout, UTF-8-safe head-and-tail excerpts, and truncation state, while excluding credentials, environment values, arbitrary arguments, and unbounded output.

The release scope is limited to preserving actionable diagnostics, reusing verified
generated-tree custody for an exact key, removing invocations that consume no new graph
fact, and adding cross-platform reuse, invalidation, tamper, and diagnostic regressions.
The motivating two-pass Windows self-host snapshot case is an explicit regression.

The release does not add another provider, make required indexing optional, alter
authored project policy, or migrate persisted evidence formats unless implementation
demonstrates that a versioned field is unavoidable.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
