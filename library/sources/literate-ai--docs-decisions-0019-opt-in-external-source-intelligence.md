---
source: docs/decisions/0019-opt-in-external-source-intelligence.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 5
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.07 clean, slant neutral at confidence 0.89; fetched raw content sha256 95cca419"
---

> Abstract: Literate AI ADR 0019 partially reverses ADR 0016 by allowing projects to opt into an externally managed source-intelligence command while preserving `none` as the dependency-free default, binding observations to lifecycle gates, and refusing to provision the provider itself.

| Section | Topics | Status |
|---------|--------|--------|
| [Context and partial reversal](../sections/literate-ai--docs-decisions-0019-opt-in-external-source-intelligence--context-and-partial-reversal.md) | agentic-sdlc, software-supply-chain | current |
| [Opt-in policy and fail-closed observation](../sections/literate-ai--docs-decisions-0019-opt-in-external-source-intelligence--opt-in-policy-and-fail-closed-observation.md) | agentic-sdlc, software-supply-chain, testing | current |
| [Provider custody and lifecycle](../sections/literate-ai--docs-decisions-0019-opt-in-external-source-intelligence--provider-custody-and-lifecycle.md) | agentic-sdlc, repository-governance, software-supply-chain | current |
| [Rejected policy alternatives](../sections/literate-ai--docs-decisions-0019-opt-in-external-source-intelligence--rejected-policy-alternatives.md) | agentic-sdlc, repository-governance | current |
| [Consequences and acceptance](../sections/literate-ai--docs-decisions-0019-opt-in-external-source-intelligence--consequences-and-acceptance.md) | agentic-sdlc, testing | current |
