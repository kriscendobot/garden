---
title: "ADR 0003: Disposition of the original hard constraints"
source: docs/decisions/0003-constraint-classification.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: The original hard-constraint list is reclassified property by property: neutral boundaries, authority checks, immutable content identity, signature limits, generated-source authority, and complete dependency accounting retain invariant cores, while tool choices, security-profile presentation, sample matrices, exhaustive provenance, and external receipt proof are policy or deferred claims.

| Original property | Classification and current boundary |
| --- | --- |
| The domain core has no OVA, provider, CodeGraph, filesystem, UI, or language dependency. | **Invariant, refined.** Neutral contracts and application decisions cannot depend on product/provider adapters. Pure path and data types are allowed; filesystem I/O belongs in adapters. The dependency-direction test enforces the implemented import boundary, and `compatibility/ova` is an explicit migration adapter. |
| Exact identities and provenance cross every lifecycle transition. | **Split.** Exact identity at specification, policy, generated-tree, authorization, artifact, and publication authority boundaries is an **invariant**. Exhaustive, uniformly serialized provenance for *every* internal transition is a **deferred claim** until one end-to-end audit proves it. |
| All side effects live behind explicit ports and policy gates. | **Over-broad wording retired.** Security-sensitive host effects—model egress, compilation, execution, workspace acceptance, and publication—must cross an explicit application/adapter boundary; compilation and execution also require exact authorization. Requiring a security-policy decision for ordinary reads, formatting, or CLI output is neither necessary nor implemented. |
| Cache contents are immutable; aliases and reverse indexes are separate. | **Invariant** for content-addressed blobs and immutable manifests. Mutable availability, alias, and reverse-dependency views are projections and cannot redefine blob identity. |
| A valid signature proves origin and integrity, not behavioral safety. | **Invariant.** Trust verification cannot itself authorize compilation, execution, or publication. |
| Unclassified source cannot be compiled; `yolo` is exact, expiring, warned exceptional privilege and never fallback. | **Split.** Guarded builders and runners requiring a live authorization for exact inputs is an **invariant**. The profile name `yolo`, its explicit privilege vocabulary, expiry limit, and warning presentation are **current security policy**. Grants are never expanded to a hidden wildcard. Exceptional policy can never be selected implicitly or bypass identity, provenance, or audit; those are invariants. |
| Specifications and samples are living conformance inputs. | **Split.** Accepted specifications are behavioral authority and generated source is disposable—an **invariant**. Maintaining this repository's sample matrix as a release gate is **repository policy**; a consuming project is not required to copy that exact matrix. |
| Bazel is the preferred build system. | **Project policy/default.** “Strong opinion” means pinned text supplied to the code-generation model, not runtime enforcement. Explicit Component specification text and selected Flavors are higher authority; an explicit alternative build Flavor replaces the default, and `-bazel` removes it before prompt assembly. |
| A committed project test receipt proves an external run. | **Deferred claim.** The current compact receipt and runner allowlist are a local, unauthenticated Git assertion. Cryptographic or remote proof requires an evidence resolver and authenticated attestations that are not implemented by the receipt service. |
| Every generated application has a complete dependency graph. | **Invariant plus standard policy, lifecycle-qualified.** Omitting known direct/transitive or Literate-AI-managed Component/repository-source dependencies while claiming completeness is an authority failure. A pre-build BOM may honestly declare only its third-party closure incomplete when a selected authorized resolver is bound to close it; the post-build BOM must be complete before tests. This framework standardizes every SBOM on CycloneDX 1.7 JSON, with separate pre-build and post-build lifecycle evidence; another wire standard would require an explicit superseding decision and migration, not an ambient adapter choice. |
| A previously accepted source-cache hit can skip current acceptance. | **Rejected.** Immutable exact lookup is a non-authoritative optimization. Every materialized candidate is explicitly current-acceptance-untrusted and must pass the present index, validation, classification, authorization, build, dependency, generated-test, and independent-acceptance gates. |

Source: [docs/decisions/0003-constraint-classification.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0003-constraint-classification.md) at commit `fcc40bc` (source lines 29–43).
