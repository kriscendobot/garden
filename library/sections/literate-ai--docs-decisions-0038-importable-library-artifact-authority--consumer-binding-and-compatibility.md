---
title: "ADR 0038: Consumer binding and lifecycle compatibility"
source: docs/decisions/0038-importable-library-artifact-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, capability-security]
status: current
---

> Abstract: In-process dependency edges bind an accepted provider revision, public interface, export bytes, import surface, target, and transitive closure, excluding ambient packages and retained source.

Any change to package bytes, import names, symbols, target or toolchain authority, or transitive artifacts invalidates stale build and acceptance evidence. The first scope covers exact dependency-free packages and library-to-library edges for Python, JavaScript, and Rust.

BUILD, TEST, and EXECUTE identities remain ordered and compatible. Library EXECUTE verifies in-process consumability without inventing a product entrypoint, while executable Component identities remain byte-identical.

Source: [docs/decisions/0038-importable-library-artifact-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0038-importable-library-artifact-authority.md) at commit `fcc40bc6`.
