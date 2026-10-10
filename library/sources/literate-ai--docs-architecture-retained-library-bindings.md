---
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 16
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.19 clean, slant neutral 1.0; fetched raw content sha256 60195fbe"
---

> Abstract: The retained-library-bindings document details the integrity machinery behind ADR 0040's retained Cargo library bridge in Literate AI: a provider-neutral export set and importer binding with no trusted flags, a pinned Cargo workspace plan, guarded readers that derive *current* authority independently of the candidate, bounded producer capture into an immutable CAS evidence store, exhaustive run-product reopening (source, generator, build, parity, lifecycle, tests, SBOM, library oracle), canonical ZIP transport and explicit HTTPS-CAS delivery, the `project retained-cargo check|materialize|admit` commands, and consumer test execution under captured Cargo inputs, runtime libraries, native-dependency graphs, and explicit macOS/Linux loader-path projections. The recurring theme: parsing and historical integrity never grant admission; every gate re-derives current authority and keeps custody across the operation. The source has no internal headings; the 16 sections follow its paragraph clusters in order.

| Section | Topics | Status |
|---------|--------|--------|
| [Retained library bindings: the provider-neutral export set](../sections/literate-ai--docs-architecture-retained-library-bindings--export-set.md) | agentic-sdlc, tooling | current |
| [Retained library bindings: the importer binding record](../sections/literate-ai--docs-architecture-retained-library-bindings--importer-binding.md) | agentic-sdlc, capability-security | current |
| [Retained library bindings: the Cargo workspace plan](../sections/literate-ai--docs-architecture-retained-library-bindings--cargo-workspace-plan.md) | tooling, agentic-sdlc | current |
| [Retained library bindings: input preflight and archive verification](../sections/literate-ai--docs-architecture-retained-library-bindings--preflight-and-archive-verification.md) | agentic-sdlc, capability-security | current |
| [Retained library bindings: current-authority readers](../sections/literate-ai--docs-architecture-retained-library-bindings--current-authority-readers.md) | agentic-sdlc, capability-security | current |
| [Retained library bindings: producer capture and evidence publication](../sections/literate-ai--docs-architecture-retained-library-bindings--producer-capture-and-publication.md) | agentic-sdlc, content-addressed-storage | current |
| [Retained library bindings: run-product reopening of source, generator, and build records](../sections/literate-ai--docs-architecture-retained-library-bindings--run-product-record-reopening.md) | agentic-sdlc, testing | current |
| [Retained library bindings: parity observations, driver binding, and the library oracle](../sections/literate-ai--docs-architecture-retained-library-bindings--run-product-parity-and-oracle.md) | testing, agentic-sdlc | current |
| [Retained library bindings: lifecycle, build, generated-test, and SBOM reopening](../sections/literate-ai--docs-architecture-retained-library-bindings--lifecycle-build-test-sbom-reopening.md) | testing, agentic-sdlc | current |
| [Retained library bindings: canonical ZIP archives and immutable storage](../sections/literate-ai--docs-architecture-retained-library-bindings--archive-transport-and-storage.md) | content-addressed-storage, tooling | current |
| [Retained library bindings: the Cargo workspace graph verifier](../sections/literate-ai--docs-architecture-retained-library-bindings--cargo-workspace-graph-verifier.md) | tooling, testing | current |
| [Retained library bindings: bundle delivery, public commands, and gate policy](../sections/literate-ai--docs-architecture-retained-library-bindings--delivery-commands-and-gate-policy.md) | tooling, capability-security | current |
| [Retained library bindings: consumer execution inputs and the reviewed test inventory](../sections/literate-ai--docs-architecture-retained-library-bindings--consumer-execution-and-test-inventory.md) | testing, tooling | current |
| [Retained library bindings: test runtime environment capture](../sections/literate-ai--docs-architecture-retained-library-bindings--test-runtime-environment.md) | testing, tooling | current |
| [Retained library bindings: native dependency observation and file custody](../sections/literate-ai--docs-architecture-retained-library-bindings--native-dependency-custody.md) | capability-security, testing | current |
| [Retained library bindings: macOS and Linux loader-path projections](../sections/literate-ai--docs-architecture-retained-library-bindings--loader-path-projections.md) | capability-security, testing | current |
