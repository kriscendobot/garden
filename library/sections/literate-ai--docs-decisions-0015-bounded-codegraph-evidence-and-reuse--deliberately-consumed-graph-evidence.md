---
title: "ADR 0015: Deliberately consumed graph evidence"
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

> Abstract: Every mandatory CodeGraph gate must name the graph fact it consumes, so duplicate invocations that prove no additional fact are removed without weakening project-index currency, capability evidence, relationship bounds, or retained frozen-index identity.

The retained facts are canonical project-index currency and database evidence;
generated-tree declaration, reference, call-graph, and capability evidence; exact
relationship counts and unresolved bounds where required; and the frozen index identity
held by admission and release evidence.

A gate that proves only that CodeGraph ran is folded into the nearest consumer or
removed. This deduplicates work rather than downgrading policy. Replacing CodeGraph or
redesigning the source-intelligence contract remains outside this release decision.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
