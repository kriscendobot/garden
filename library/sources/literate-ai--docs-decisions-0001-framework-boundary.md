---
source: docs/decisions/0001-framework-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 3
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed_with_caveat, injection 0.08 clean, slant neutral at low confidence 0.27 (slant classification uncertain); fetched raw content sha256 cb4f7ed6"
---

> Abstract: Literate AI's first architecture decision record (accepted for bootstrap, 2026-08-02) extracts a software-neutral, hexagonal lifecycle kernel from the OVA Omniverse application generator: versioned wire contracts and ports in the core, every product-, provider-, language-, and tool-specific concern pushed into adapters, OVA demoted to a downstream adapter and conformance consumer, and a two-phase shadow-then-cutover migration. The record's consequences and rejected alternatives are the maintainers' stated rationale.

| Section | Topics | Status |
|---------|--------|--------|
| [Context and decision](../sections/literate-ai--docs-decisions-0001-framework-boundary--context-and-decision.md) | agentic-sdlc | current |
| [Boundary rule](../sections/literate-ai--docs-decisions-0001-framework-boundary--boundary-rule.md) | agentic-sdlc | current |
| [Consequences, rejected alternatives, and validation](../sections/literate-ai--docs-decisions-0001-framework-boundary--consequences-alternatives-and-validation.md) | agentic-sdlc | current |
