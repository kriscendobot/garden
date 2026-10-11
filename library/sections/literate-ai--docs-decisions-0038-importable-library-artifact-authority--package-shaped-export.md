---
title: "ADR 0038: Package-shaped library export"
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

> Abstract: Reviewed `kind: library` Components produce immutable language-native package directories whose identity binds interfaces, import surfaces, toolchain, dependencies, source authority, and canonical tree bytes.

Lifecycle manifests, verifiers, acceptance answers, object files, and ambient source stay outside the export. Python exposes an isolated package root; JavaScript seals its manifest and exports map; Rust supplies a Cargo package compiled by consumers as an exact path dependency while build objects remain external.

Projection branches on reviewed Component kind, never merely on an empty entrypoint list.

Source: [docs/decisions/0038-importable-library-artifact-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0038-importable-library-artifact-authority.md) at commit `fcc40bc6`.
