---
title: "ADR 0042: Authored C++ interface and sealed layout"
source: docs/decisions/0042-cpp-library-products.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, capability-mediated-integrations]
status: current
---

> Abstract: A C++ import declaration and native Flavor bind names, headers, compiled layout, dependency closure, and an exact ABI profile into one sealed export.

Portable paths and qualified names point into the authored interface. Exports contain public headers, declared binaries, runtime files, and metadata; private sources, tests, objects, and caches stay outside while linkage choices join identity.

Source: [docs/decisions/0042-cpp-library-products.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0042-cpp-library-products.md) at commit fcc40bc6.
