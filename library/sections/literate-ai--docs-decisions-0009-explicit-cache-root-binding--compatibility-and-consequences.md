---
title: "ADR 0009: Compatibility and consequences"
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

> Abstract: Default roots, Make overrides, and the separate runtime-root rule remain unchanged; cache paths stay host bindings rather than portable workflow authority, and older receipts may omit the new custody identity.

The decision does not change default roots, Make's `?=` overrides, or the already
explicit `--runtime-root`. Cache roots do not enter workflow authority because host
paths would make a workflow non-portable.

Lifecycle custody becomes reviewable in the command and visible in evidence. The cost
is a wider receipt and CLI surface. Readers must tolerate pre-change receipts without
the field, while all commands share the existing binding seam to prevent resolution
logic from drifting.

Source: [docs/decisions/0009-explicit-cache-root-binding.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0009-explicit-cache-root-binding.md) at commit `fcc40bc6` (source lines 78-100).
