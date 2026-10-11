---
title: "ADR 0036: npm lifecycle consequences and validation"
source: docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Selecting npm now adds an explicit host and network build phase whose exact closure is tested across tool versions, lock shapes, authority failures, tampering, execution, and cross-platform release matrices.

The narrow package shape keeps replay and inventory comparison deterministic. Supported distributions are properties of observed bytes, not nominal version ranges, and unsupported shapes fail closed.

Validation includes a pure-JavaScript dependency, npm 11's `pg` graph, npm 9 through 11, rejected npm 12 evidence, ESM authority escapes, source immutability, packaged local resolution, and failure-before-publication cases.

Source: [docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md) at commit `fcc40bc6`.
