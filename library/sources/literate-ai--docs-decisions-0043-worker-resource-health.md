---
source: docs/decisions/0043-worker-resource-health.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 6
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.17 clean, slant neutral at confidence 0.92; fetched raw content sha256 106bf48f"
---

> Abstract: Literate AI ADR 0043 makes resource health a private expiring scheduling input with conservative classification, bounded investigation, exact cleanup authority, and portable qualification.

| Section | Topics | Status |
|---------|--------|--------|
| [Worker health boundary and private observations](../sections/literate-ai--docs-decisions-0043-worker-resource-health--health-boundary-and-private-observations.md) | agentic-sdlc, worker-observability | current |
| [Health classification and dispatch](../sections/literate-ai--docs-decisions-0043-worker-resource-health--classification-and-dispatch.md) | agentic-sdlc, worker-observability | current |
| [Bounded read-only investigation](../sections/literate-ai--docs-decisions-0043-worker-resource-health--bounded-read-only-investigation.md) | worker-observability, capability-security | current |
| [Authorized cleanup and retry](../sections/literate-ai--docs-decisions-0043-worker-resource-health--authorized-cleanup-and-retry.md) | worker-observability, capability-security | current |
| [CLI, alert, and skill surface](../sections/literate-ai--docs-decisions-0043-worker-resource-health--cli-alert-and-skill-surface.md) | agentic-sdlc, worker-observability | current |
| [Health qualification and consequences](../sections/literate-ai--docs-decisions-0043-worker-resource-health--qualification-and-consequences.md) | agentic-sdlc, worker-observability, testing | current |
