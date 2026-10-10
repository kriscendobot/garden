# Topic: agentic-sdlc

> Abstract: Specification-led software-development lifecycles in which coding agents produce candidates inside a larger deterministic harness: authored intent is distinct from derived locks and evidence, exact inputs determine generation identity, build and execution require separate authority, independent acceptance gates admission, and releases retain traceability from specification to artifact. Literate AI is the canonical source; this topic differs from `agent-fleet-orchestration`, which concerns scheduling many autonomous workers rather than governing one artifact's engineering lifecycle.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [literate-ai--readme--overview-and-premise](../sections/literate-ai--readme--overview-and-premise.md) | literate-ai README.md | Literate AI is a release-engineering and SDLC harness for specification-led software whose durable product is the validity harness. |
| [literate-ai--readme--lifecycle](../sections/literate-ai--readme--lifecycle.md) | literate-ai README.md | Exact inputs become bounded per-Component plans; generation is separated from build, acceptance, packaging, and release evidence. |
| [literate-ai--readme--authority-and-evidence](../sections/literate-ai--readme--authority-and-evidence.md) | literate-ai README.md | Components, assets, Flavors, skills, provenance, SBOMs, and tests are explicit authority or evidence artifacts. |
| [literate-ai--readme--scope-and-containment](../sections/literate-ai--readme--scope-and-containment.md) | literate-ai README.md | The cross-platform harness guards execution but does not claim hardened containment for hostile generated code. |
| [literate-ai--docs-architecture-domain-model--hexagonal-authority-boundary](../sections/literate-ai--docs-architecture-domain-model--hexagonal-authority-boundary.md) | literate-ai domain model | Immutable domain contracts are separated from orchestration, effectful ports, adapters, and presentation. |
| [literate-ai--docs-architecture-domain-model--components-flavors-and-locks](../sections/literate-ai--docs-architecture-domain-model--components-flavors-and-locks.md) | literate-ai domain model | Component revisions and typed Flavor locks bind exact intent without silent merge precedence. |
| [literate-ai--docs-architecture-domain-model--bidirectional-authoring](../sections/literate-ai--docs-architecture-domain-model--bidirectional-authoring.md) | literate-ai domain model | Reverse engineering yields evidence-linked drafts; forward skills guide implementation but cannot create behavior authority. |
| [literate-ai--docs-architecture-domain-model--workflow-acceptance-and-receipts](../sections/literate-ai--docs-architecture-domain-model--workflow-acceptance-and-receipts.md) | literate-ai domain model | Source-only candidates pass authorization, build, generated tests, independent acceptance, admission, and compact receipt boundaries. |
| [literate-ai--docs-architecture-authoring-and-record-formats--intent-and-evidence-boundary](../sections/literate-ai--docs-architecture-authoring-and-record-formats--intent-and-evidence-boundary.md) | literate-ai authoring formats | Reviewable Markdown carries intent; canonical JSON and CycloneDX carry derived locks and evidence. |
| [literate-ai--docs-architecture-authoring-and-record-formats--skills-and-flavors](../sections/literate-ai--docs-architecture-authoring-and-record-formats--skills-and-flavors.md) | literate-ai authoring formats | Complete Markdown bytes identify skills and Flavors, and dual legacy/current authorities fail closed. |
| [literate-ai--docs-architecture-authoring-and-record-formats--workflow-catalogs-and-round-trips](../sections/literate-ai--docs-architecture-authoring-and-record-formats--workflow-catalogs-and-round-trips.md) | literate-ai authoring formats | Typed workflow DAGs, per-stage instructions, nesting, and canonical round trips constrain model egress. |
| [literate-ai--docs-architecture-component-execution-plans--per-component-planning](../sections/literate-ai--docs-architecture-component-execution-plans--per-component-planning.md) | literate-ai execution plans | Exact Component locks compile to independently cacheable per-node work with content-bound generation keys. |
| [literate-ai--docs-architecture-component-execution-plans--bounded-incremental-generation](../sections/literate-ai--docs-architecture-component-execution-plans--bounded-incremental-generation.md) | literate-ai execution plans | Interface-aware invalidation bounds regeneration without making cache state authoritative. |
| [literate-ai--docs-architecture-component-execution-plans--lifecycle-and-build-boundary](../sections/literate-ai--docs-architecture-component-execution-plans--lifecycle-and-build-boundary.md) | literate-ai execution plans | A typed build boundary keeps coding-agent narrative separate from accepted artifacts and evidence. |
| [literate-ai--docs-architecture-design-traceability--authority-evidence-matrix](../sections/literate-ai--docs-architecture-design-traceability--authority-evidence-matrix.md) | literate-ai design traceability | Each lifecycle concern maps authority, exact inputs, enforcement boundaries, and proof obligations. |

## See also

- [agent-fleet-orchestration](agent-fleet-orchestration.md) — work-queue and multi-agent coordination above an individual artifact lifecycle.
- [testing](testing.md) — test commands and testing conventions across ingested repositories.
- [tooling](tooling.md) — developer-facing tools and build-system details.
