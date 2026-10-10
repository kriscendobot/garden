---
source: docs/architecture/repository-inheritance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 6
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.11 clean, slant neutral 1.0; fetched raw content sha256 e3178a02"
---

> Abstract: The repository-inheritance document defines how Literate AI projects inherit Components, Flavors, skills, workflows, and routing from a DAG of parent repositories: side-effect-free resolution of every parent to an exact commit under a bounded fetch policy, ancestor-first catalog composition with per-file provenance, three-way `update`/retirement/`reparent` with atomic rollback, the `litai graph` effective-authority projection and exact-duplicate rebalance advisor, and a trust boundary resting on content identities rather than caches, with parent contributions going through separate checkouts and review requests.

| Section | Topics | Status |
|---------|--------|--------|
| [Repository inheritance: the parent DAG and side-effect-free initialization](../sections/literate-ai--docs-architecture-repository-inheritance--parent-dag-and-initialization.md) | agentic-sdlc, tooling | current |
| [Repository inheritance: bounded fetch policy](../sections/literate-ai--docs-architecture-repository-inheritance--bounded-fetch-policy.md) | tooling | current |
| [Repository inheritance: ancestor-first catalog composition](../sections/literate-ai--docs-architecture-repository-inheritance--ancestor-first-catalog-composition.md) | agentic-sdlc, dynamic-composition | current |
| [Repository inheritance: three-way update, retirement, and reparenting](../sections/literate-ai--docs-architecture-repository-inheritance--update-retirement-and-reparenting.md) | agentic-sdlc, tooling | current |
| [Repository inheritance: the effective-authority graph](../sections/literate-ai--docs-architecture-repository-inheritance--effective-authority-graph.md) | agentic-sdlc, tooling | current |
| [Repository inheritance: precedence, trust boundary, and parent contribution checkouts](../sections/literate-ai--docs-architecture-repository-inheritance--trust-boundary-and-parent-checkouts.md) | agentic-sdlc, capability-security | current |
