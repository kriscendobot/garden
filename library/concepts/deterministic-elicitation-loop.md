---
id: deterministic-elicitation-loop
aliases: ["deterministic elicitation loop", "deterministic elicitation", "elicitation loop", "bounded interview", "structured intake", "triage flow", "context-gathering interview", "render user feedback deterministically", "automatic agentic loop", "mutually reinforcing loop", "deterministic half of the loop"]
topics: [automatic-agentic-loop, decision-graph-authoring]
status: current
---

# deterministic-elicitation-loop

The **deterministic half** of a mutually-reinforcing automatic ↔ agentic loop: a graph that *deterministically routes and elicits* — asks the right next question, surfaces the right context, and records the answers as structured state — paired with an agent that supplies the open-ended reasoning the graph cannot encode. The thesis under evaluation (@kriskowal, 2026-07-21) is that a kni-style decision graph could *render user feedback to an agent deterministically*: drive a bounded interview / triage / context-gathering flow whose transcript becomes durable agent context. This page is the mechanism; its sibling [[decision-graph-as-agent-context-scaffold]] is the broader idea and fit assessment.

## How a graph "renders user feedback"

A kni graph drives a bounded interview out of three primitives already in the language:

1. **Route.** A prompt (`>`) presents a bounded, possibly-conditional menu; conditional options (`{gold >= 10}`, `{-arrow}`, `{!open}`) mean the menu shown is a deterministic function of current state — the graph asks only the questions that are legal right now ([options-and-questions](../sections/kni--manual--options-and-questions.md), [expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md)). Threads can begin with a condition that skips them entirely ([indentation-and-threads](../sections/kni--manual--indentation-and-threads.md)), so whole branches of the interview appear or vanish on state.
2. **Elicit.** A prompt with a variable name captures **free-form** interlocutor input into a variable, with an optional *cue* a custom dialog can use to validate or convert the text ([input-prompts](../sections/kni--manual--input-prompts.md)). This is the open-ended intake point.
3. **Record.** The captured value is an ordinary variable, echoed with `{(Name)}`, tested in conditions, and threaded through the rest of the graph ([input-prompts](../sections/kni--manual--input-prompts.md), [blocks-switch-conditions-and-modifiers](../sections/kni--manual--blocks-switch-conditions-and-modifiers.md)). The transcript of the walk *is* the structured record. kni's shipped `examples/read.kni` is a compact literal instance: it interviews for a name (free text), a "gender" (a three-way menu setting a variable), and some entropy, then renders a structured result sentence — a bot intake flow, not a story.

Because the walk is transcript-recordable and *verifiable* (`kni -t` / `kni -v`), reproducible under a seed, and snapshot-resumable via `waypoint`/`resume` ([command-line tooling](../sections/kni--readme--command-line-tooling.md), [runtime hooks](../sections/kni--hackni--runtime-hooks.md)), the "rendering of user feedback" is durable and replayable — re-running the loop on the same answers yields the same recorded context.

## Where the seam falls — what each side hands the other

kni's `handler` interface is the seam made concrete ([runtime hooks](../sections/kni--hackni--runtime-hooks.md)):

- **Graph → agent.** The graph hands the agent a *bounded request*: `ask()` fires when the flow wants an answer (optionally with a cue naming the expected kind), and `goto(label, instruction)` streams the exact position and instruction. The agent receives "here is the specific next thing to answer, and here is the state that led here."
- **Agent → graph.** The agent hands back an `answer(text)` (a free-form string the graph binds to the prompt's variable) or, for richer state, a `set(name, value)` on a variable the handler owns via `has`/`get`. The agent's open-ended judgment — reading a messy answer, deciding what it means — collapses into a typed value the graph can route on.

So the deterministic side owns **which question, which branch is legal, and the record**; the agentic side owns **interpreting the free-form answer and doing the work**. The division is clean because kni already externalizes both input (dialog: `ask`/`answer`) and variable ownership (handler: `has`/`get`/`set`) as pluggable roles ([dialogs-and-renderers](../sections/kni--hackni--dialogs-and-renderers.md)) — an agent is just an unusually smart dialog-plus-handler.

## The mutually-reinforcing shape

The loop reinforces in both directions: the graph makes the agent's context-gathering *deterministic and auditable* (no two runs drift; the transcript is a checkable artifact), and the agent makes the graph *capable* (it can pose free-form questions and absorb free-form answers a pure state machine could never parse). The deterministic spine keeps the agent from re-improvising intake every session; the agentic turn keeps the spine from needing to encode what it cannot. This is the same pause-elicit-resume shape LangGraph packages as [[human-in-the-loop]] (`interrupt` → `Command(resume=)`), but expressed at the decision-graph level rather than inside an LLM harness.

**Limits of the mechanism.** kni records *choices and short strings*, not rich structured payloads — 32-bit-integer variables with very limited strings ([kni-beyond-ink-and-limitations](../sections/kni--inkkni--kni-beyond-ink-and-limitations.md)) — so anything beyond a menu selection or a short captured field must live in agent memory or an external store bound through the handler. And the routing is only as good as the guards the author writes; the graph cannot *decide* what to ask next beyond what its conditions encode — that open-ended judgment is precisely the agentic half's job.

Provenance: mechanism and quotes trace to kriskowal's `github.com/kriskowal/kni` (MANUAL, HACKNI, README, INKKNI, and `examples/read.kni`) as ingested 2026-07-21; the loop framing is the maintainer's, recorded in this ingest's result entry.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [input-prompts](../sections/kni--manual--input-prompts.md) | The elicit-and-record primitive: capture free-form input into a variable, with an optional validation cue. |
| [options-and-questions](../sections/kni--manual--options-and-questions.md) | The route primitive: a prompt presents a bounded, conditional menu and records the chosen branch. |
| [expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md) | Guard-plus-consequence options make the menu a deterministic function of state. |
| [runtime-hooks](../sections/kni--hackni--runtime-hooks.md) | The `handler` seam (`ask`/`answer`, `has`/`get`/`set`, `waypoint`/`resume`) — where the graph hands off to and receives back from the agent. |
| [dialogs-and-renderers](../sections/kni--hackni--dialogs-and-renderers.md) | Dialog (`ask`/`answer`) and renderer are pluggable roles — an agent is a smart dialog-plus-handler. |
| [command-line-tooling](../sections/kni--readme--command-line-tooling.md) | Transcript/verify/waypoint — the durability and replayability of the recorded feedback. |
|[read bot interview](../sections/kni--examples-read--overview.md) | The literal route-elicit-record-render loop: text fields plus a bounded choice become a bot profile.

## See also

- [[decision-graph-as-agent-context-scaffold]] — the broader idea (encode tasks as graphs an agent walks to develop context) and the garden-fit assessment.
- [[human-in-the-loop]] — the same pause-elicit-resume shape at the LLM-framework level (LangGraph `interrupt`/`resume`).
- [[context-pruning]] — a deterministic intake that gathers exactly the needed context is a "fewer tokens" tactic.
- [[objectives-over-state-machine]] — the caution: don't over-encode the flow; leave the open-ended reasoning to the agent, or the loop stops reinforcing.
