---
title: "ADR 0017: One-invocation override precedence"
source: docs/decisions/0017-explicit-live-test-coding-cli.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: One-shot CLI flags outrank environment selection, which outranks durable user configuration; PATH search and first-available fallback never participate in live-test precedence, and overrides do not rewrite durable defaults.

A maintainer can experiment with any supported provider and model for one process tree
through `--coding-cli` and `--model`. If omitted, the existing CLI/model environment is
consulted before user configuration. This escape hatch remains invocation authority,
not repository authority or a mutation of operator-owned state.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
