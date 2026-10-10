---
title: OVA evaluation: scope, evidence, and executive verdict
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

> Abstract: Literate AI's evaluation of OVA's source-grounded component subsystem (OVA commit `811c71c9`, ~5,943 lines across eleven Python modules, 366 passing non-native tests) concludes that OVA invented the outline of a valuable general system, a digest-bound continuity chain from intent to reusable Component, but as a first vertical slice entangled with OVA/Omniverse specifics; its recommendation is to extract the invariants, redesign the boundaries, and port behavior through compatibility fixtures rather than rename `ova` to `literate_ai`.

**Scope and evidence.** The evaluation uses OVA commit `811c71c9472ec07a5bae2dba32f6d8f21b0802bb` (`feat: add source-grounded component system`) as its extraction baseline; the receiving literate-ai baseline is commit `1caa902` (`Initial commit`). It covers the complete source-grounded implementation, not only design documents: `src/ova/models/source_grounding.py` and its strict Pydantic schemas; the source, CodeGraph, composition, cache/linker, model, generation, publication, and prompt-journal services under `src/ova/services/`; the `ova.source_grounding` CLI and Settings routes; root and sample `ova.yaml` manifests; the active `adopt-source-grounded-components` OpenSpec change; the simple-to-self-hosting sample ladder; and the source-security classification plan.

At the baseline the subsystem comprises roughly 5,943 implementation lines across eleven central Python modules plus focused unit and integration tests. OVA's full gate reported 366 passing non-native tests, strict OpenSpec validation, a clean macOS launch, and a real deterministic OVA-in-OVA source-grounded generation transaction; an independent extraction reviewer re-ran 82 architecture-focused tests, all passing. Those results validate the current vertical slice; they do not satisfy the redesign and migration gates.

**Executive verdict (the document's).** OVA has invented the outline of a valuable general system, not merely an Omniverse code generator. Its best idea is the continuity chain:

```text
intent -> specs -> exact dependency closure -> exact source -> knowledge index
       -> evidence -> API contracts -> file plan -> generated source -> validation
       -> source package -> artifact package -> publication -> reusable Component
```

Each arrow is intended to produce an explicit, digest-bound object, and generated output returns to the beginning as another composable Component. Model selection, skills, caches, and publications are part of the lifecycle rather than ambient process state; the document calls this the correct foundation for a modern form of literate programming.

The implementation is still a first vertical slice. Its reusable domain model is interleaved with OVA names, Omniverse policy, CodeGraph CLI details, Python compilation, filesystem layouts, Litestar routes, and four hard-coded LLM stages. Several objects called immutable are updated through mutable projections, security is plan-only, and the self-hosting sample proves recursive composition rather than a byte-for-byte OVA rebuild. Copying the subsystem wholesale would preserve these accidental constraints. The recommendation: **extract the invariants, redesign the boundaries, and port behavior through compatibility fixtures**. Do not begin by renaming `ova` to `literate_ai`.

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
