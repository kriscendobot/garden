---
title: "ADR 0032: Tuple-specific CycloneDX install SBOMs"
source: docs/decisions/0032-tuple-specific-native-install-sboms.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Each supported OS, architecture, and accelerator tuple has a CycloneDX host-realization SBOM mapping logical capabilities to packages, commands, probes, managed artifacts, and a complete dependency graph.

Initial tuples cover Debian-family Linux, macOS, and Windows x86-64 where stated; unsupported tuples fail explicitly until reviewed data is added. Managed archives bind digest, extraction, executable placement, PATH, and every companion needed for a reusable installation.

Source: [docs/decisions/0032-tuple-specific-native-install-sboms.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md) at commit `fcc40bc6`.
