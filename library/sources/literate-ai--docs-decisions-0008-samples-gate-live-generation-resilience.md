---
source: docs/decisions/0008-samples-gate-live-generation-resilience.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 5
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.11 clean, slant neutral at confidence 0.88; fetched raw content sha256 0814e859"
---

> Abstract: Literate AI ADR 0008 makes the live-generated sample matrix resilient without weakening it: retry only classified transient failures, checkpoint only identity-matched successes, preserve complete diagnostics for deterministic failures, and keep hard-denial provider fallback separate.

| Section | Topics | Status |
|---------|--------|--------|
| [Context and corrected diagnosis](../sections/literate-ai--docs-decisions-0008-samples-gate-live-generation-resilience--context-and-corrected-diagnosis.md) | agentic-sdlc, testing | current |
| [Failure evidence and existing patterns](../sections/literate-ai--docs-decisions-0008-samples-gate-live-generation-resilience--failure-evidence-and-existing-patterns.md) | agentic-sdlc, testing | current |
| [Bounded transient retry](../sections/literate-ai--docs-decisions-0008-samples-gate-live-generation-resilience--bounded-transient-retry.md) | agentic-sdlc, testing | current |
| [Identity-bound sample checkpointing](../sections/literate-ai--docs-decisions-0008-samples-gate-live-generation-resilience--identity-bound-sample-checkpointing.md) | agentic-sdlc, testing, software-supply-chain | current |
| [Consequences and unchanged boundaries](../sections/literate-ai--docs-decisions-0008-samples-gate-live-generation-resilience--consequences-and-unchanged-boundaries.md) | agentic-sdlc, testing | current |
