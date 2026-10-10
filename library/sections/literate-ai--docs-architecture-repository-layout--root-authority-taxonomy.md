---
title: Root authority taxonomy
source: docs/architecture/repository-layout.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Literate AI keeps authored Components, Flavors, skills, workflows, routing, and OpenSpec inputs visible at the repository root while placing importable Python below `src/`, making authority-bearing design inputs distinct from implementation packages.

The root taxonomy separates orientation and policy, packaging metadata, contributor entrypoints, Literate AI authority, product and verification code, supporting tools and documentation, provider adapters, and local-only configuration. Durable deliverables live beside their owning package rather than in a generic output directory.

Host dependencies follow the same ownership rule. Universal capabilities live in the base toolchain Flavor, selected Flavors add logical requirements, and an OS/architecture/accelerator leaf maps those requirements to concrete packages. The installer composes and de-duplicates these declarations rather than reproducing package policy in platform conditionals.

Source: [docs/architecture/repository-layout.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/repository-layout.md) at commit `fcc40bc`.
