---
title: OVA evaluation: domain coupling, resolver policy, and eager vocabulary
source: docs/architecture/ova-model-evaluation.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Three structural problems to fix during extraction: OVA-specific names and conflated lifecycle roles (`ApplicationIntentSpec = OvaComponentSpec`, inconsistent `kind`, one 923-line schema module); a non-neutral resolver (hard-coded Omniverse foundation components, implicit physics, lexicographic provider choice, unresolved compatibility, timestamped lock digests); and a "complete vocabulary" that eagerly clones and indexes every repository instead of a full descriptor vocabulary plus lazily grounded selected closure.

**Domain and naming coupling.**

- `OvaComponentSpec`, `OvaComponentIdentity`, `CachedOvaComponent`, `ova.yaml`, `OVA_HOME`, and `ova-generated` make a general concept application-specific.
- `ApplicationIntentSpec = OvaComponentSpec` aliases two lifecycle roles that should be distinct: a durable Component definition and a request to produce a revision.
- `kind` is restricted differently in generated manifests, catalog records, and cached records. Application, library, framework, sample, and tool are roles or profiles, not mutually exclusive identities.
- One 923-line schema module combines every bounded context and encourages cross-layer imports.

**Resolver policy is not neutral or sufficiently expressive.**

- `_FOUNDATION_COMPONENTS = ("ovstage", "ovrtx", "ovstream")` is injected into every composition.
- Physics requirements implicitly add `ovphysx`.
- With multiple providers, the lexicographically first Component ID wins unless a preferred ID is supplied.
- Compatibility is asserted with the reason "source and CodeGraph index identities validated"; platform, version range, ABI, license, policy, feature, and toolchain compatibility are not resolved.
- The dependency lock's digest includes timestamps, so logically identical resolution runs receive different identities.

Provider selection must become an explicit policy port with a deterministic explanation object; OVA foundation and physics behavior belongs in an OVA policy adapter.

**Complete vocabulary currently means eager global materialization.** `ComponentCompositionService.prepare_all_components()` calls `fault_all()`, so forming the vocabulary can clone and index every enabled repository. This works for a small catalog and fails as the ecosystem grows; the live OVA self-hosting verification exposed it through large Git LFS payloads and source-empty meta repositories. The framework needs two levels:

1. a complete descriptor vocabulary containing every discoverable Component and its availability/identity metadata; and
2. exact source evidence faulted only for the selected closure and explicitly requested comparison candidates.

Unavailable entries must remain visible without being presented as usable API evidence.

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
