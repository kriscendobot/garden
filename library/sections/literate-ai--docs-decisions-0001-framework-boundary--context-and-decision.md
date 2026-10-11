---
title: "ADR 0001 (software-neutral lifecycle kernel): Context and decision"
source: docs/decisions/0001-framework-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: OVA's spec-led lifecycle concepts were entangled with OVA policy, CodeGraph, Python builds, storage, and fixed model stages, so Literate AI is built as a neutral hexagonal kernel with immutable versioned wire contracts, ports, and adapters, with OVA becoming a downstream adapter migrated in two phases.

- Status: Accepted for bootstrap
- Date: 2026-08-02
- Decision owners: literate-ai maintainers
- Supersedes: none

## Context

OVA implemented Components, source-grounded generation, model groups/selectors, local
caches, packaging/linking, publication, Settings integration, living samples, and a
source-security plan while building an Omniverse application generator. Most of those
concepts describe a general spec-led software lifecycle. Their current Python types and
services also encode OVA policy, CodeGraph CLI behavior, Python build behavior,
filesystem storage, and fixed model stages.

Copying or renaming the implementation would make literate-ai an OVA utility library.
Rewriting without compatibility fixtures would discard the strongest invariants and
make an eventual OVA rebase unsafe.

## Decision

Build literate-ai as a software-neutral, hexagonal lifecycle kernel with immutable,
versioned wire contracts. Domain and application packages depend only on ports. OpenSpec,
Git/local sources, CodeGraph, model providers, builders, storage, and publishers are
adapters. OVA becomes a downstream adapter and conformance consumer.

The public object model distinguishes logical Components, immutable revisions, exact
source snapshots, knowledge/evidence, durable workflow runs, security decisions,
immutable bundles, publication records, and scoped settings. Generated outputs return
to the system as ordinary Component revisions.

Migration uses the two phases in
[`ova-two-phase-rebase.md`](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/migration/ova-two-phase-rebase.md): framework extraction
and shadow proof first; OVA cutover and duplicate retirement second.

Source: [docs/decisions/0001-framework-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0001-framework-boundary.md) at commit `fcc40bc` (source lines 1–35).
