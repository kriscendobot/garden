---
source: docs/architecture/provider-resolution.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 3
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.13 clean, slant neutral 1.0; fetched raw content sha256 3299da7d"
---

> Abstract: The provider-resolution document specifies Literate AI's capability-based selection of interchangeable implementation providers: projects declare provider IDs, capability sets, required capabilities, a preferred provider, and an ordered fallback list in `component.md` (with at most one Flavor override); a fixed, fail-closed policy picks the provider, the complete result lives in the Component lock and every generation key, and downstream products (the Physics Workbench Newton/PhysX example) keep their policy while deleting their own resolver code.

| Section | Topics | Status |
|---------|--------|--------|
| [Provider resolution: the capability-based selection contract](../sections/literate-ai--docs-architecture-provider-resolution--selection-contract.md) | agentic-sdlc, dynamic-composition | current |
| [Provider resolution: lock and plan authority](../sections/literate-ai--docs-architecture-provider-resolution--lock-and-plan-authority.md) | agentic-sdlc, tooling | current |
| [Provider resolution: migrating Physics Workbench's Newton/PhysX choice](../sections/literate-ai--docs-architecture-provider-resolution--physics-workbench-migration.md) | agentic-sdlc | current |
