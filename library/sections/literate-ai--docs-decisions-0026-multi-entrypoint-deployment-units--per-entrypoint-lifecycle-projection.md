---
title: "ADR 0026: Per-entrypoint lifecycle projection"
source: docs/decisions/0026-multi-entrypoint-deployment-units.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Build remains revision-wide, but test, execute, acceptance, and export-shape contracts fan out by entrypoint identity instead of assuming `entrypoints[0]`.

One build produces the complete artifact set for a Component revision. Each entrypoint
then carries phase-specific commands and an export shape in a keyed command-contract
map. This lets the verifier test and accept one surface without launching unrelated
ones, while retaining the shared build boundary.

Source: [docs/decisions/0026-multi-entrypoint-deployment-units.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md) at commit `fcc40bc6`.
