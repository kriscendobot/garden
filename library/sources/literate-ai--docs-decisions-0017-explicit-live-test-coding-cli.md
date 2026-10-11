---
source: docs/decisions/0017-explicit-live-test-coding-cli.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 8
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.14 clean, slant neutral at confidence 0.43; fetched raw content sha256 e21cf3e2"
---

> Abstract: Literate AI ADR 0017 makes live release qualification fail closed unless one coding CLI and model are explicitly selected, stores the default in operator-owned configuration, defines one-invocation overrides, and gives remote fan-out stricter noninteractive prerequisites than attended local use.

| Section | Topics | Status |
|---------|--------|--------|
| [Nondeterministic live qualification](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--nondeterministic-live-qualification.md) | agentic-sdlc, testing | current |
| [Explicit launcher and model pin](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--explicit-launcher-and-model-pin.md) | agentic-sdlc, testing | current |
| [Operator-owned durable default](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--operator-owned-durable-default.md) | agentic-sdlc, repository-governance | current |
| [One-invocation override precedence](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--one-invocation-override-precedence.md) | agentic-sdlc, repository-governance | current |
| [Remote fan-out prerequisites](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--remote-fan-out-prerequisites.md) | agentic-sdlc, testing | current |
| [Attended local-use boundary](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--attended-local-use-boundary.md) | agentic-sdlc, repository-governance | current |
| [Session-selection observability](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--session-selection-observability.md) | agentic-sdlc, testing | current |
| [Consequences and rejected fallbacks](../sections/literate-ai--docs-decisions-0017-explicit-live-test-coding-cli--consequences-and-rejected-fallbacks.md) | agentic-sdlc, testing | current |
