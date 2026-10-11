---
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 8
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.07 clean, slant neutral at confidence 0.75; fetched raw content sha256 9a09f0aa"
---

> Abstract: Literate AI ADR 0005 gives each immutable Component revision independent executable semantics, limits generation context to public interface contracts, assigns phase-specific meanings to dependency edges, resolves targets and Flavors per node, separates authored assets from model output, distinguishes driver trust, and specifies exact invalidation through a diamond graph.

| Section | Topics | Status |
|---------|--------|--------|
| [Context and Component revision unit](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--context-and-component-revision.md) | agentic-sdlc, software-supply-chain | current |
| [Public-interface boundary](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--public-interface-boundary.md) | agentic-sdlc | current |
| [Phase-specific edge semantics](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--phase-specific-edge-semantics.md) | agentic-sdlc, software-supply-chain | current |
| [Per-node target and Flavor resolution](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--per-node-target-and-flavor-resolution.md) | agentic-sdlc | current |
| [Authored assets and repair](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--authored-assets-and-repair.md) | agentic-sdlc, software-supply-chain | current |
| [Driver trust provenance](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--driver-trust-provenance.md) | agentic-sdlc | current |
| [Diamond invalidation example](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--diamond-invalidation-example.md) | agentic-sdlc, software-supply-chain | current |
| [Compatibility and consequences](../sections/literate-ai--docs-decisions-0005-executable-component-semantics--compatibility-and-consequences.md) | agentic-sdlc | current |
