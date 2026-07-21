---
title: Runtime hooks — the handler interface, waypoints, and resume
source: HACKNI.md
source_repo: kriskowal/kni
source_commit: 0d6e2949daf0701df3ed7c173899e2a04b0dcca2
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: The Engine constructor accepts a `handler` object that binds the graph walk to external scene graphs, data sources, and sinks — the single most lens-relevant surface in kni for using a decision graph as agent-context scaffolding. This section catalogs the handler methods: `has`/`get`/`set`/`changed` (delegate named variables to an external owner — a live database, a simulation, an agent), `waypoint(state)` + `resume(state)` (snapshot the entire narrative state — variables, stack, RNG state, current instruction, answer labels — and replay from it), `goto(label, instruction)` (per-instruction notifications that can trigger external side effects), and `ask()`/`answer(text)`/`end(engine)` (the elicitation and completion notifications). These hooks are where the deterministic graph hands off to, and receives back from, whatever supplies open-ended behavior.

The Engine constructor accepts a `handler` object that can drive bindings with external scene graphs and data sources and targets. The handler may implement any of:

- **`has(name)`** — determines whether the engine's global scope should defer to the handler for reading and writing a variable by name. Can match patterns (e.g. names beginning with `external.`) or specific names like `time`.
- **`get(name)`** — the engine calls this to get names owned by the handler. Must currently return synchronously. Handy for external continuous variables like time as well as live bindings to a database or simulation.
- **`set(name, value)`** — the engine calls this to set names owned by the handler.
- **`changed(name, value)`** — receives notifications for any global variable change.
- **`waypoint(state)`** — receives a snapshot of the narrative state, including all global variables, the entire stack, the internal state of the random number generator, the current instruction label, and an array of answer labels (or null for the initial waypoint). The engine can **`resume(state)`** on any waypoint, replaying all of the narrative since the dialog's last answer.
- **`goto(label, instruction)`** — receives notifications for every instruction the engine executes, with its label. A `@label` within a story can trigger external scene changes, like showing and hiding supplementary assets or components.
- **`ask()`** — receives a notification whenever the story asks for an answer.
- **`answer(text)`** — receives a notification when the story receives an answer.
- **`end(engine)`** — receives a notification when a story runs to its conclusion.

Read for the agent-context lens, this handler is the whole seam: `has`/`get`/`set` let an external owner (a database, a simulation, an agent's own memory) back arbitrary graph variables so the graph reads and writes live state rather than only its own scope; `waypoint`/`resume` make a run fully snapshottable and replayable (durable, resumable context); `goto` and `ask`/`answer` are the notification stream by which the deterministic walk requests open-ended input and announces every step it takes. See the CLI's `-r <waypoint>` restore flag in [command-line tooling](kni--readme--command-line-tooling.md).

Source: [HACKNI.md](https://github.com/kriskowal/kni/blob/0d6e2949daf0701df3ed7c173899e2a04b0dcca2/HACKNI.md) at commit `0d6e2949`.
