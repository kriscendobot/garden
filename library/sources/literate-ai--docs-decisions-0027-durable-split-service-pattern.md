---
source: docs/decisions/0027-durable-split-service-pattern.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 5
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed_with_caveat, injection 0.09 clean, slant neutral at confidence 0.28; slant classification uncertain; fetched raw content sha256 f09a8e85"
---

> Abstract: Literate AI ADR 0027 catalogs a reusable four-boundary frontend/API/collector/cache composition, publishes only coherent durable snapshots, and places restart-safe schedule and lease state beside the single-writer cache rather than in framework daemon authority.

| Section | Topics | Status |
|---------|--------|--------|
| [Monolith and request-time collection failure](../sections/literate-ai--docs-decisions-0027-durable-split-service-pattern--monolith-and-request-time-collection-failure.md) | agentic-sdlc, capability-security | current |
| [Four public-capability boundaries](../sections/literate-ai--docs-decisions-0027-durable-split-service-pattern--four-public-capability-boundaries.md) | agentic-sdlc, capability-security | current |
| [Coherent snapshot publication](../sections/literate-ai--docs-decisions-0027-durable-split-service-pattern--coherent-snapshot-publication.md) | agentic-sdlc, testing | current |
| [Scheduler and lease authority](../sections/literate-ai--docs-decisions-0027-durable-split-service-pattern--scheduler-and-lease-authority.md) | agentic-sdlc, repository-governance, testing | current |
| [Conformance and operational consequences](../sections/literate-ai--docs-decisions-0027-durable-split-service-pattern--conformance-and-operational-consequences.md) | agentic-sdlc, software-supply-chain, testing | current |
