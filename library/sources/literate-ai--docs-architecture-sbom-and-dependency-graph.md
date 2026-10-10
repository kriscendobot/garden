---
source: docs/architecture/sbom-and-dependency-graph.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 5
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.13 clean, slant neutral 0.96; fetched raw content sha256 d284b2b4"
---

> Abstract: This architecture document defines Literate AI's two-stage CycloneDX 1.7 dependency evidence: an exact pre-build managed graph and a post-build observed closure joined by a preservation invariant, with fail-closed completeness, inert host inspection, bounded Bazel/npm/Python evidence, cache revalidation, and a strict separation between inventory provenance and present authorization or security verdicts.

| Section | Topics | Status |
|---------|--------|--------|
| [Source and resolved SBOM lifecycle](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--source-and-resolved-sbom-lifecycle.md) | software-supply-chain, agentic-sdlc | current |
| [Component and package inventory](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--component-and-package-inventory.md) | software-supply-chain, agentic-sdlc | current |
| [Completeness and build evidence](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--completeness-and-build-evidence.md) | software-supply-chain, agentic-sdlc | current |
| [Non-executing host observation](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--non-executing-host-observation.md) | software-supply-chain, agentic-sdlc | current |
| [Cache, receipt, and trust boundaries](../sections/literate-ai--docs-architecture-sbom-and-dependency-graph--cache-receipt-and-trust-boundaries.md) | software-supply-chain, agentic-sdlc | current |
