---
source: README.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
section_count: 2
status: current
---

The kni README (kriskowal's own project): the front-door description of kni as an "interactive story language," which — read past the storytelling framing — is a language for expressing decision graphs plus a runtime engine that walks them. It gives the core model (text interleaved with options; the engine enters at the top, accumulates options, prompts, and traces the chosen branch), the canonical hello example and its interactive session, and the full command-line surface: interactive reader, transcript recording, transcript verification, JSON compilation and re-execution, standalone HTML generation, and the `-d` diagnostic view that prints the compiled instruction graph as inspectable rows. The command-line tooling is the concrete evidence for this ingest's lens of determinism, replayability, and auditability.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/kni--readme--overview.md) | decision-graph-authoring, automatic-agentic-loop | current |
| [command-line-tooling](../sections/kni--readme--command-line-tooling.md) | decision-graph-authoring, automatic-agentic-loop | current |
