---
title: "ADR 0038: Library consequences and validation"
source: docs/decisions/0038-importable-library-artifact-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Qualified libraries can replace retained in-process code while remaining reproducible, immutable, independently accepted, and consumable by exact identity across three language-specific implementations.

Generation skills must emit import surfaces and test adapters, verifier harnesses remain separate, and caches gain library dependency edges without changing directory-export storage.

Validation proves canonical bindings, every selected test, real consumers, verifier custody, executable compatibility, and fail-closed response to tampering, stale interfaces or oracles, ambient shadowing, case mismatch, dependency substitution, and target drift.

Source: [docs/decisions/0038-importable-library-artifact-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0038-importable-library-artifact-authority.md) at commit `fcc40bc6`.
