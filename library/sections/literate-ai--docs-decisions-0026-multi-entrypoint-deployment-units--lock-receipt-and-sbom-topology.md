---
title: "ADR 0026: Lock, receipt, and SBOM topology"
source: docs/decisions/0026-multi-entrypoint-deployment-units.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Component locks and evidence receipts bind every entrypoint's export shape, phase-command identities, and deployment-unit membership, while CycloneDX evidence enumerates the resulting operational topology.

Changing one entrypoint's authority invalidates its affected generation, build, and test
evidence under the existing lifecycle rules. Recording deployment membership in the
locked identity lets reviewers audit both the build graph and which surfaces can be
operated independently.

Source: [docs/decisions/0026-multi-entrypoint-deployment-units.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md) at commit `fcc40bc6`.
