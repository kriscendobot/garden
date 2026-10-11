---
title: "ADR 0033: OS realization and deterministic composition"
source: docs/decisions/0033-os-base-universal-toolchain.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Concrete OS tuple leaves map logical IDs to native packages or integrity-pinned artifacts, and stage zero composes base, OS, and selected Flavor documents before choosing one realization.

Identical duplicate contracts are deterministically deduplicated with contributor warnings; conflicting contracts fail. Composition also rejects missing realizations, target mismatch, malformed graphs, unsafe command templates, symlinks, traversal, and digest mismatch.

Source: [docs/decisions/0033-os-base-universal-toolchain.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0033-os-base-universal-toolchain.md) at commit `fcc40bc6`.
