---
source: docs/decisions/0026-multi-entrypoint-deployment-units.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 6
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.09 clean, slant neutral at confidence 0.41; fetched raw content sha256 08cf2d39"
---

> Abstract: Literate AI ADR 0026 replaces the single-entrypoint wall with independently addressable deployment units while keeping immutable Component revisions as the generation and build unit, projecting commands and evidence per entrypoint, and preserving separate Components where authority must not be shared.

| Section | Topics | Status |
|---------|--------|--------|
| [Build units versus deployment units](../sections/literate-ai--docs-decisions-0026-multi-entrypoint-deployment-units--build-units-versus-deployment-units.md) | agentic-sdlc, software-supply-chain | current |
| [Entrypoint cardinality and authority](../sections/literate-ai--docs-decisions-0026-multi-entrypoint-deployment-units--entrypoint-cardinality-and-authority.md) | agentic-sdlc, capability-security | current |
| [Per-entrypoint lifecycle projection](../sections/literate-ai--docs-decisions-0026-multi-entrypoint-deployment-units--per-entrypoint-lifecycle-projection.md) | agentic-sdlc, testing | current |
| [Dispatcher and artifact binding](../sections/literate-ai--docs-decisions-0026-multi-entrypoint-deployment-units--dispatcher-and-artifact-binding.md) | agentic-sdlc, software-supply-chain | current |
| [Lock, receipt, and SBOM topology](../sections/literate-ai--docs-decisions-0026-multi-entrypoint-deployment-units--lock-receipt-and-sbom-topology.md) | agentic-sdlc, software-supply-chain, testing | current |
| [Compatibility and implementation consequences](../sections/literate-ai--docs-decisions-0026-multi-entrypoint-deployment-units--compatibility-and-implementation-consequences.md) | agentic-sdlc, repository-governance | current |
