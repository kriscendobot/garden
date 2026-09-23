---
source: HACKNI.md
source_repo: kriskowal/kni
source_commit: 0d6e2949daf0701df3ed7c173899e2a04b0dcca2
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
section_count: 4
status: current
---

"Hackni": a hacker's tour of the kni implementation, and the most architecturally load-bearing document for this ingest's lens. It explains the four-stage recursive-descent parser (scanner → outline-lexer → inline-lexer → grammar) that compiles nested script into a completely flat, VM-like instruction graph; the runtime engine (a program counter plus a call stack walking the JSON graph, with pluggable storage, pluggable RNG, and a seeded xorshift128 PRNG for reproducible transcripts); the **runtime hooks** — the `handler` interface (`has`/`get`/`set`/`changed`, `waypoint`/`resume`, `goto`, `ask`/`answer`/`end`) that binds the graph walk to external state, snapshots, and notifications; and the pluggable dialog/renderer boundary (web `document.js`, command-line `readline.js`/`console.js`/`excerpt.js`). The runtime-engine and runtime-hooks sections are where the deterministic graph meets external, potentially-agentic behavior.

| Section | Topics | Status |
|---------|--------|--------|
| [parser-pipeline](../sections/kni--hackni--parser-pipeline.md) | decision-graph-authoring | current |
| [runtime-engine](../sections/kni--hackni--runtime-engine.md) | decision-graph-authoring, automatic-agentic-loop | current |
| [runtime-hooks](../sections/kni--hackni--runtime-hooks.md) | decision-graph-authoring, automatic-agentic-loop | current |
| [dialogs-and-renderers](../sections/kni--hackni--dialogs-and-renderers.md) | decision-graph-authoring | current |
