---
title: "ADR 0015: Operational consequences"
source: docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, software-supply-chain]
status: current
---

> Abstract: Exact reuse preserves CodeGraph as a trust dependency while reducing unnecessary availability dependence, making failures diagnosable and qualification faster at the cost of stricter cache custody, invalidation, and fail-closed testing.

The expected outcome is fewer path-sensitive repeated operations and CI evidence that
can diagnose a provider failure without reproducing it on the same host. The framework
must correspondingly treat cache verification and invalidation as security-relevant
boundaries. Any later reduction in mandatory graph evidence requires measurements of
which relationships lifecycle decisions actually consume.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
