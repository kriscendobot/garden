---
title: "ADR 0042: Compiled C++ library product gap"
source: docs/decisions/0042-cpp-library-products.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: C++ consumers require qualified public headers, linkable binaries, runtime files, and compatible ABI settings rather than a language flag or archived CLI.

The prior lifecycle covered interpreted packages and Cargo source packages but not generated C++ producers. Static is the built-in default, a reviewed profile selects shared production, and SDK or retained-source migration remain separate.

Source: [docs/decisions/0042-cpp-library-products.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0042-cpp-library-products.md) at commit fcc40bc6.
