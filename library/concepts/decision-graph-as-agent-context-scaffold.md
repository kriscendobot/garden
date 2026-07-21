---
id: decision-graph-as-agent-context-scaffold
aliases: ["decision graph as agent context scaffold", "decision-graph scaffold", "kni as agent context", "decision graph for agents", "context-gathering graph", "task graph for agents", "scaffold agent context", "decision-graph agent scaffold", "kni agent context scaffold"]
topics: [automatic-agentic-loop, decision-graph-authoring]
status: current
---

# decision-graph-as-agent-context-scaffold

The idea, under evaluation by @kriskowal (2026-07-21): encode common tasks as **decision graphs** that an agent walks to **dig deep and develop context** before or while acting, rather than re-deriving the same context ad hoc through open prompting each time. The candidate substrate is **kni** (`github.com/kriskowal/kni`), kriskowal's own decision-graph language. Read past its interactive-fiction framing, kni is a language for authoring a branching, stateful flow plus a small engine that walks it: the parser compiles authored nesting into a flat JSON instruction graph ([parser pipeline](../sections/kni--hackni--parser-pipeline.md)), and the runtime traces it with a program counter and a call stack, accumulating options, prompting, and following the chosen branch ([runtime engine](../sections/kni--hackni--runtime-engine.md)). This page is the *idea and its fit assessment*; its sibling [[deterministic-elicitation-loop]] is the narrower mechanism (route + elicit + record) that a scaffold graph runs on.

## What the graph model gives that ad-hoc prompting does not

Grounded in the ingested kni sources:

- **Determinism and replayability.** A kni walk is reproducible: the engine threads a seedable RNG through every evaluation and uses a xorshift128 PRNG when generating or verifying transcripts, so the same script, seed, and answer sequence reproduce the same trace ([runtime engine](../sections/kni--hackni--runtime-engine.md)). The CLI can record a transcript and later *verify* a script still reproduces it — a regression check on the flow ([command-line tooling](../sections/kni--readme--command-line-tooling.md)). Ad-hoc prompting has no such fixed, checkable trace.
- **Resumability.** The `waypoint(state)` hook snapshots the *entire* narrative state — variables, the whole stack, the RNG's internal state, the current instruction, and the answer labels — and the engine can `resume(state)` from any waypoint, replaying since the last answer ([runtime hooks](../sections/kni--hackni--runtime-hooks.md)); the CLI exposes this as `-r <waypoint>`. A context-gathering flow can therefore be paused and resumed durably.
- **Auditable branch state.** Because options fuse a guard with a mutation (`{-arrow}` shows only with an arrow and consumes one; `{!open}`, `{?open}`, `{=m n}`), each branch taken is a legible precondition-plus-effect over named variables ([expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md)), and the `-d` diagnostic view prints the compiled graph as inspectable rows ([command-line tooling](../sections/kni--readme--command-line-tooling.md)). The state that routed the flow is inspectable, not buried in a model's hidden reasoning.
- **A durable, structured transcript.** The captured answers are ordinary variables read back by later text and conditions ([input-prompts](../sections/kni--manual--input-prompts.md)); the transcript of a walk is exactly the structured context the flow gathered.

## Where the deterministic graph ends and agentic reasoning begins

kni already has the seam built in. The Engine constructor takes a `handler` whose `has`/`get`/`set` methods let an **external owner** back arbitrary graph variables — "a live binding to a database or simulation," per the docs, or equally an agent's own memory — so the graph reads and writes live external state rather than only its own scope ([runtime hooks](../sections/kni--hackni--runtime-hooks.md)). `ask()`/`answer(text)` are the elicitation notifications, and `goto(label, instruction)` streams every executed instruction so a label can trigger external behavior. The natural division: **the graph owns routing, guards, and the record** (which question next, which branch is legal, what got answered); **the agent owns the open-ended turn** (reading a free-form answer, deciding what a captured value means, doing the actual work once context is gathered). Each hands the other a well-typed artifact — the graph hands the agent a bounded prompt and the accumulated state; the agent hands the graph an `answer` string (or a `set` on an external variable).

## Fit and gaps as a garden tool

The scaffold maps recognizably onto how the garden already gathers context: the liaison's **ask-before-acting** posture, the **maintainer inbox**, and the orchestration/press loops are all bounded elicit-and-record flows that today live in prose role instructions rather than an executable graph. A kni-style graph would make such a flow *deterministic, replayable, and resumable* — a triage or intake interview whose transcript becomes durable context — where today it is re-improvised per session.

The gaps are real and worth stating plainly (from [kni-beyond-ink-and-limitations](../sections/kni--inkkni--kni-beyond-ink-and-limitations.md)): kni variables are **32-bit integers with very limited string support**, so it captures *choices and counts* cleanly but not rich structured payloads (a captured `Name` is about the extent of free-form state); **labels are not first-class values**, so a graph cannot compute a divert target at runtime; there are **no user-defined functions** in expressions and **no modules yet**; and the language is **explicitly evolving across major versions**. The `<hook>` game-hook and the `handler` escape hatch are where anything kni cannot express would have to live — which is also, encouragingly, exactly where the agentic half plugs in. Net: kni is a strong fit for the *routing/eliciting/recording skeleton* of a context-gathering task and a poor fit for holding rich structured context itself; a garden adoption would keep the heavy state in the agent (or an external store bound through `has`/`get`/`set`) and use the graph for the deterministic spine.

Provenance: all claims trace to kriskowal's `github.com/kriskowal/kni` docs (README, MANUAL, HACKNI, INKKNI) as ingested 2026-07-21; the evaluation framing is the maintainer's ask, recorded in this ingest's result entry.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview](../sections/kni--readme--overview.md) | kni is a decision-graph language plus a graph-walking engine — the walkable skeleton a scaffold would use. |
| [command-line-tooling](../sections/kni--readme--command-line-tooling.md) | Transcript/verify/JSON/waypoint/`-d` — the determinism, replayability, and auditability evidence. |
| [input-prompts](../sections/kni--manual--input-prompts.md) | Capturing free-form input into a variable — how the graph records what it elicits. |
| [expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md) | Guard-plus-mutation options make branch state auditable; also the 32-bit-integer state limit. |
| [runtime-engine](../sections/kni--hackni--runtime-engine.md) | Program counter + call stack + pluggable storage/RNG; reproducible transcripts. |
| [runtime-hooks](../sections/kni--hackni--runtime-hooks.md) | The `handler` seam (`get`/`set`, `waypoint`/`resume`, `ask`/`answer`) where the graph meets external/agentic behavior. |
| [kni-beyond-ink-and-limitations](../sections/kni--inkkni--kni-beyond-ink-and-limitations.md) | The capability boundary — the gaps half of the fit assessment. |

## See also

- [[deterministic-elicitation-loop]] — the narrower route-elicit-record mechanism a scaffold graph runs on.
- [[human-in-the-loop]] — LangGraph's `interrupt`/`Command(resume=)` is the same pause-elicit-resume shape at the LLM-framework level.
- [[multi-agent-handoff]] — state-driven control transfer between agents; a decision graph is the intra-agent analogue (control transfer between graph nodes).
- [[context-pruning]] — the "fewer tokens" lever; a deterministic scaffold that gathers exactly the needed context is one way to send less context per turn.
- [[objectives-over-state-machine]] — the countervailing caution from agent-fleet practice: give agents objectives, not rigid state machines; a scaffold graph must route/elicit without over-constraining the agentic turn.
