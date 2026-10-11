---
title: "ADR 0042: Conan and wheel boundaries"
source: docs/decisions/0042-cpp-library-products.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [software-supply-chain, capability-mediated-integrations]
status: current
---

> Abstract: Conan projects the sealed native layout into an exact revisioned package and proves it through a fresh Bazel consumer, while wheel authority remains separate.

Fresh-cache verification compares recipe, package, and payload closure, then invokes a native symbol without the producer checkout. A C++ library does not automatically become a Python extension or portable wheel.

Source: [docs/decisions/0042-cpp-library-products.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0042-cpp-library-products.md) at commit fcc40bc6.
