# Topic: automatic-agentic-loop

> Abstract: The line of thinking that pairs a **deterministic, automatic half** with an **open-ended, agentic half** into a mutually-reinforcing loop — the deterministic side routes, elicits, and records structured state; the agentic side supplies the reasoning the deterministic side cannot encode; each hands the other a well-typed artifact. Seeded 2026-07-21 from the maintainer's (@kriskowal) evaluation of **kni** decision graphs as a candidate substrate for the deterministic half: a graph that walks an agent through digging deep and developing context (a bounded interview / triage / context-gathering flow) whose transcript becomes durable agent context. This topic collects the *evaluation* — the concept pages that test the thesis and the specific kni sections that supply the mechanism (input capture, the handler/`get`/`set`/`ask`/`answer` seam, waypoint/resume, transcript/verify). Distinct from `decision-graph-authoring` (the language itself, framing-neutral) and from `agent-fleet-orchestration` (orchestrating many agents against a work queue, a coarser control plane than a single context-gathering graph).

## Concepts

- [[decision-graph-as-agent-context-scaffold]] — the idea of encoding common tasks as decision graphs an agent walks to dig deep and develop context before/while acting; kni evaluated as a candidate substrate.
- [[deterministic-elicitation-loop]] — the deterministic half proper: a graph that routes and elicits (asks the next question, surfaces context, records answers as structured state) while the agent supplies open-ended reasoning; where the seam falls and what each side hands the other.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [overview](../sections/kni--readme--overview.md) | kni README | The graph/engine model: text interleaved with options, an engine that enters, accumulates, prompts, and traces the chosen branch — the walkable graph an agent could drive. |
| [command-line-tooling](../sections/kni--readme--command-line-tooling.md) | kni README | Transcript, verify, JSON compile, and waypoint restore — the determinism / replayability / resumability / auditability evidence for the deterministic half. |
| [options-and-questions](../sections/kni--manual--options-and-questions.md) | kni MANUAL | The prompt as a decision point presenting a bounded, possibly-conditional menu and recording which branch was taken — the routing surface. |
| [input-prompts](../sections/kni--manual--input-prompts.md) | kni MANUAL | Capturing free-form input into a variable that later text and conditions read back — how a graph elicits an open-ended answer and records it as durable state. |
| [expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md) | kni MANUAL | Condition-and-consequence option operators fuse a precondition check with a state transition — auditable branch state. |
| [runtime-engine](../sections/kni--hackni--runtime-engine.md) | kni HACKNI | Pluggable storage and a seeded PRNG make the walk reproducible — the same script, seed, and answers reproduce the same trace. |
| [runtime-hooks](../sections/kni--hackni--runtime-hooks.md) | kni HACKNI | The handler `has`/`get`/`set`, `waypoint`/`resume`, and `ask`/`answer` hooks — the concrete seam where the deterministic graph hands off to and receives back from external/agentic behavior. |
| [kni-beyond-ink-and-limitations](../sections/kni--inkkni--kni-beyond-ink-and-limitations.md) | kni INKKNI | The capability boundary (no types beyond 32-bit ints, no label-values, no user functions, `<hook>` escape) — the "gaps" half of the fit assessment. |
|[read bot interview](../sections/kni--examples-read--overview.md) | kni examples/read.kni | A literal deterministic intake: free-text capture plus a bounded choice, rendered as a bot profile.

## See also

- [decision-graph-authoring](decision-graph-authoring.md) — the kni language itself, framing-neutral: grammar, compiled state machine, engine, and hooks.
- [agent-fleet-orchestration](agent-fleet-orchestration.md) — the coarser control plane of orchestrating many agents against a shared work queue; a context-gathering decision graph would sit *inside* one such agent's turn.
- [llm-agent-frameworks](llm-agent-frameworks.md) — LangGraph's human-in-the-loop `interrupt`/`resume` is the same pause-elicit-resume shape kni's `ask`/`answer` + waypoint/resume implements at the graph level.
