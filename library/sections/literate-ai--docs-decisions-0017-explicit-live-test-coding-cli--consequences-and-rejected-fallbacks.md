---
title: "ADR 0017: Consequences and rejected fallbacks"
source: docs/decisions/0017-explicit-live-test-coding-cli.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Explicit selection makes equal-revision live runs comparable and remote qualification feasible at the intentional cost of requiring a durable operator choice, while rejecting PATH defaults, authentication probing, committed vendor pins, and copied credential stores.

The accepted design preserves a command-line experiment escape hatch without making
the project spend-bearing or vendor-specific. The rejected alternatives either produce
variable results, probe providers expensively and nondeterministically, commit operator
policy into project authority, or distribute credential caches whose sessions still
expire and whose copying violates installation guidance.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
