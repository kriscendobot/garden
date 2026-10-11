---
title: "ADR 0042: Native build and generated tests"
source: docs/decisions/0042-cpp-library-products.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Bound Bazel inputs build a real static or shared library and separate test adapter, while sealing verifies target products and preserves per-case observations.

Inputs come from the plan rather than ambient discovery. Only declared outputs enter the export; suffixes do not prove type, aggregate exit status cannot invent case results, and tests stay separate.

Source: [docs/decisions/0042-cpp-library-products.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0042-cpp-library-products.md) at commit fcc40bc6.
