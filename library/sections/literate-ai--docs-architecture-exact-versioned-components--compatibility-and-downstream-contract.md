---
title: Explicit schema compatibility and the downstream OVA DTO contract
source: docs/architecture/exact-versioned-components.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Legacy schemas are admitted only through registered deterministic one-step migrations that demand caller-supplied missing identities and never invent 0.0.0, a namespace, approval, or the newest cached version, so unrecoverable caches fail closed; downstream OVA maps its schema to the neutral exact-ref DTOs once at the adapter boundary and may keep mutable aliases only for display.

Compatibility is explicit. `SchemaCompatibilityReader` admits only registered legacy schemas, applies deterministic one-step migrations, rejects future schemas, and exposes stable ambiguity errors. Legacy target profiles require a caller-supplied SemVer. Legacy bundle manifests require a caller-supplied exact Component ref; legacy bundle dependencies additionally require exact dependency refs. Legacy publication manifests require an explicit exact request and authorization migration context, because older records lack effective revision, source, provenance, target, and policy facts. The framework does not invent `0.0.0`, infer a namespace, manufacture publication approval, or select the newest cached version.

Old caches therefore remain readable only when their authoritative catalog or lock can supply the missing identity; otherwise migration fails closed and the object must be re-resolved from authoritative source.

**Downstream OVA DTO contract.** OVA maps its product schema to the neutral DTOs once, at the adapter boundary:

- `OvaComponentIdentity` → `ComponentRevisionRef` after revision construction;
- dependency/cache/package/publication records → the same exact Component ref;
- target profiles and Flavor locks → strict profile SemVer plus exact base/Flavor refs;
- model endpoints/groups/selectors → `VersionedContentRef` values;
- skills → strict `SkillRef` values, including dependency refs.

OVA may retain mutable display aliases such as "latest" for UI convenience, but generation, build, link, publication, and import APIs must consume exact refs. Provider-neutral SemVer parsing, coordinates, revision references, coexistence, resolution, and serialization are framework authority; downstream copies are not part of the post-cutover architecture.

Source: [docs/architecture/exact-versioned-components.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/exact-versioned-components.md) at commit `fcc40bc`.
