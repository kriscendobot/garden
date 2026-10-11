---
title: "ADR 0009: Explicit binding and receipt identity"
source: docs/decisions/0009-explicit-cache-root-binding.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Lifecycle-bearing commands gain `--build-dir` and `--obj-dir`, resolve explicit values through the existing safe binding path, prefer flags over environment over defaults, and bind the actual `CacheDirectories.identity` into candidate test receipts.

Explicit flags use `bind_cache_directories()` and therefore retain safe-root,
distinctness, and no-nesting checks. When a flag is absent, the matching environment
variable remains supported; otherwise the portable project-local default applies. A
flag wins over a disagreeing environment value because it is the recorded statement
of intent.

The candidate test receipt records the identity of the resolved roots actually used.
Warm and cold executions of one revision consequently produce distinguishable evidence
instead of relying on later inference about process environment.

Source: [docs/decisions/0009-explicit-cache-root-binding.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0009-explicit-cache-root-binding.md) at commit `fcc40bc6` (source lines 54-76).
