---
title: "ADR 0019: Context and partial reversal"
source: docs/decisions/0019-opt-in-external-source-intelligence.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: ADR 0019 restores an opt-in external source-graph provider because complete removal made a canonical derived project impossible to maintain, but leaves the framework free of an ambient or installed provider dependency.

ADR 0016 removed the adapter, CLI, worker capability, documentation, tests, and every
accepted provider except `none`. That achieved framework independence but caused the
Physics Workbench sample's authored `codegraph-cli` policy to fail before it could
review a bounded Component-lock update. The maintainer therefore selected a partial
reversal on both the main and maintenance release lines: explicit projects may use an
external provider, while ordinary framework operation remains independent of it.

Source: [docs/decisions/0019-opt-in-external-source-intelligence.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0019-opt-in-external-source-intelligence.md) at commit `fcc40bc6` (source lines 1-23).
