---
title: "ADR 0040: Retained-library binding authority"
source: docs/decisions/0040-retained-cargo-library-bridge.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, capability-security]
status: current
---

> Abstract: A reviewed project binding joins provider qualification, package bytes, ABI and toolchain requirements, artifact closure, Cargo edges, membership, lockfile, and trust decision.

Bindings reopen qualification evidence rather than accepting a boolean, producer claim, or passing build. Digests detect substitution but do not confer approval; the checked-in binding is the same-user trust boundary.

Source: [docs/decisions/0040-retained-cargo-library-bridge.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0040-retained-cargo-library-bridge.md) at commit fcc40bc6.
