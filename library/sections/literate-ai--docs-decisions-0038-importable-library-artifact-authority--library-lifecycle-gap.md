---
title: "ADR 0038: Importable library lifecycle gap"
source: docs/decisions/0038-importable-library-artifact-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A zero-entrypoint library could be sealed but not honestly tested, accepted, imported, or bound to consumers without fabricating process semantics or per-case test attribution.

Native test-runner aggregate output could not prove every selected generated case. Copying ambient generated source lost accepted artifact identity, while disguising a library as a CLI forced an inappropriate subprocess and JSON boundary.

The missing contract spans Python, JavaScript, and Rust because downstream consumption must bind exact package, capability, import surface, target, and toolchain authority.

Source: [docs/decisions/0038-importable-library-artifact-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0038-importable-library-artifact-authority.md) at commit `fcc40bc6`.
