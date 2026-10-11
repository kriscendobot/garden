---
title: "ADR 0042: Cross-platform native qualification"
source: docs/decisions/0042-cpp-library-products.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Qualification combines static and shared consumers, reproducible incremental Bazel behavior, exact Conan references, substitution failures, source deletion, installed checks, and exact-head CI.

Linux, macOS, and Windows cover native formats. Action counts distinguish clean, no-op, header, and implementation changes; restored identities reproduce and exact revisions reject same-name substitution.

Source: [docs/decisions/0042-cpp-library-products.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0042-cpp-library-products.md) at commit fcc40bc6.
