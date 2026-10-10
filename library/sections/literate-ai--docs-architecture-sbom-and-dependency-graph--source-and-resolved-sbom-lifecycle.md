---
title: "CycloneDX SBOM and dependency graph: source and resolved SBOM lifecycle"
source: docs/architecture/sbom-and-dependency-graph.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [software-supply-chain, agentic-sdlc]
status: current
---

> Abstract: Literate AI uses a CycloneDX 1.7 pre-build source SBOM for the exact managed Component graph and a post-build resolved SBOM for the observed package, toolchain, runtime, and binary closure; both are mandatory lifecycle gates, and the latter must preserve the former's graph and identity.

Every Literate AI-generated application carries one standards-based dependency story.
The framework uses CycloneDX 1.7 JSON for every SBOM; it does not define a competing
inventory format. The official JSON schema is the wire authority, and Literate AI adds
only namespaced properties that bind framework identities.

| Evidence | Lifecycle | Location | Required precision |
| --- | --- | --- | --- |
| Source SBOM | CycloneDX `pre-build` | `source/.literate/sbom.cdx.json` inside the disposable generated tree | Exact managed Component/repository graph and every known direct relationship; an explicitly deferred third-party closure uses `incomplete_third_party_only` plus honest version ranges |
| Resolved SBOM | CycloneDX `post-build` | External build evidence | The preserved source graph plus the complete observed package, toolchain, runtime, and binary closure at exact versions |

The source SBOM is generated from the same specifications, selected Flavors, exact
skills, and complete Literate-AI-managed dependency graph as the implementation and
current tests. The post-build SBOM is produced and verified after the native build has
resolved the actual toolchains, packages, runtimes, and binary closure, but before any
generated or independent test executes. A missing, partial, or invalid document stops
that lifecycle boundary.

The lifecycle orders managed-graph construction, source generation, strict source-SBOM
validation, manifest/lock/import reconciliation, exact-source indexing, build-request
classification and authorization, external resolution and build, non-executing host
inspection, resolved-SBOM completeness checking, and only then generated and independent
tests. Receipt evidence binds both SBOMs.

Source: [docs/architecture/sbom-and-dependency-graph.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sbom-and-dependency-graph.md) at commit `fcc40bc` (source lines 1–47).
