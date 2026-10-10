---
source: docs/architecture/agent-ledger-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The agent-ledger boundary document splits ownership between Literate AI as a derivation engine and an agent ledger such as MAC as a control plane, separates the two prompt-translation paths, specifies a content-addressed derivation-run envelope whose correlation metadata never enters derivation identity, and scopes prompt journals versus customer explanations; the join protocol is specified, not yet implemented.

| Section | Topics | Status |
|---------|--------|--------|
| [derivation engine versus agent ledger ownership](../sections/literate-ai--docs-architecture-agent-ledger-boundary--ownership-split.md) | agentic-sdlc, agent-fleet-orchestration | current |
| [direct versus ledger-driven prompt translation](../sections/literate-ai--docs-architecture-agent-ledger-boundary--prompt-translation-paths.md) | agentic-sdlc, agent-fleet-orchestration | current |
| [the derivation-run envelope join protocol](../sections/literate-ai--docs-architecture-agent-ledger-boundary--join-protocol-run-envelope.md) | agentic-sdlc, agent-fleet-orchestration | current |
| [prompt journals, customer explanations, and implementation status](../sections/literate-ai--docs-architecture-agent-ledger-boundary--journals-explanations-and-status.md) | agentic-sdlc, agent-fleet-orchestration | current |
