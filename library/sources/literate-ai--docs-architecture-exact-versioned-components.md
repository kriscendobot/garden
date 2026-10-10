---
source: docs/architecture/exact-versioned-components.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The exact-versioned-components document requires a coordinate, a strict SemVer version, and a content identity on every domain object, propagates exact refs through composition, locks, routing, skills, bundles, and publication, and admits legacy schemas only through explicit fail-closed migrations, with downstream OVA mapping to neutral DTOs at one adapter boundary.

| Section | Topics | Status |
|---------|--------|--------|
| [the exact versioned identity triple](../sections/literate-ai--docs-architecture-exact-versioned-components--identity-triple.md) | agentic-sdlc | current |
| [propagating exact refs through composition, locks, routing, skills, and publication](../sections/literate-ai--docs-architecture-exact-versioned-components--exact-ref-propagation.md) | agentic-sdlc | current |
| [explicit schema compatibility and the downstream OVA DTO contract](../sections/literate-ai--docs-architecture-exact-versioned-components--compatibility-and-downstream-contract.md) | agentic-sdlc | current |
