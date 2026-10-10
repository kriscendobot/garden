---
source: docs/architecture/monorepo-adoption.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 3
status: current
content_caveat: "foreign-content classifier unavailable on the ingesting host (TYPESAFE_API_KEY absent; disposition proceed_unclassified); fetched raw content sha256 af68a130 was read under untrusted-data discipline and no agent-directed text was observed"
---

> Abstract: The monorepo-adoption document (governed by ADR 0039) defines explicit, operator-reviewed monorepo root selection with declared shared-source custody, descriptor-bound read-only custody checks, explicit consent before executing any declared harness, and source-free per-Component staging whose retained receipts requalify only the Components whose owned or shared inputs changed.

| Section | Topics | Status |
|---------|--------|--------|
| [Monorepo adoption: explicit root selection and shared-source custody](../sections/literate-ai--docs-architecture-monorepo-adoption--root-selection-and-shared-custody.md) | agentic-sdlc, tooling | current |
| [Monorepo adoption: descriptor custody, consent to execute, and acceptance](../sections/literate-ai--docs-architecture-monorepo-adoption--descriptor-custody-consent-and-acceptance.md) | agentic-sdlc, tooling | current |
| [Monorepo adoption: staging and per-Component retained qualification](../sections/literate-ai--docs-architecture-monorepo-adoption--staging-and-per-component-qualification.md) | agentic-sdlc, tooling, testing | current |
