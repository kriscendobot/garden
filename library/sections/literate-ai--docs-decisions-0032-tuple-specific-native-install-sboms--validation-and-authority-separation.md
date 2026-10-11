---
title: "ADR 0032: Validation and authority separation"
source: docs/decisions/0032-tuple-specific-native-install-sboms.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Schema, tuple, graph, consent, probe, lifecycle, and cross-platform tests prove host installation without conflating native prerequisites with Python or generated-product SBOMs.

Validation includes disposable-prefix installation, CI matrices, unsupported hosts, package-manager absence, managed-runtime completeness, and repeated install/uninstall cycles. Package-manager assets and sibling retained data must survive, while custody-changing symlinks fail closed.

Source: [docs/decisions/0032-tuple-specific-native-install-sboms.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md) at commit `fcc40bc6`.
