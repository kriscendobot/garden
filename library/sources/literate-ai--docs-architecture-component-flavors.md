---
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 6
status: current
---

> Abstract: The component-flavors document defines Flavors as first-class versioned variation objects that let one target-neutral Component realize many OS, accelerator, language, build, toolchain, and packaging targets: semantic axes and role slots, target profiles resolved into a digest-identified Flavor-set lock, an immutable effective revision whose Flavor spec fragments may add but never weaken base requirements, typed per-field merge operators, and content-pinned toolchain constraints.

| Section | Topics | Status |
|---------|--------|--------|
| [Flavor purpose and the FlavorDefinition object model](../sections/literate-ai--docs-architecture-component-flavors--purpose-and-flavor-object-model.md) | agentic-sdlc | current |
| [Selected-Flavor capability requirements](../sections/literate-ai--docs-architecture-component-flavors--selected-flavor-requirements.md) | agentic-sdlc | current |
| [Flavor axes, role slots, and project default selectors](../sections/literate-ai--docs-architecture-component-flavors--axes-slots-and-default-selectors.md) | agentic-sdlc, tooling | current |
| [Target profiles, Flavor-set locks, and the effective revision](../sections/literate-ai--docs-architecture-component-flavors--target-profile-and-effective-revision.md) | agentic-sdlc, testing | current |
| [Typed Flavor contributions and toolchain-constraint artifacts](../sections/literate-ai--docs-architecture-component-flavors--typed-contributions-and-toolchain-constraints.md) | agentic-sdlc, tooling | current |
| [Flavor examples, lifecycle integration, product boundary, and conformance matrix](../sections/literate-ai--docs-architecture-component-flavors--examples-lifecycle-and-conformance.md) | agentic-sdlc, testing | current |
