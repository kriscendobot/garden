# Topic: decision-graph-authoring

> Abstract: Authoring, compiling, and walking **decision graphs** — the language-and-runtime discipline of encoding a branching, stateful flow as a graph that an engine traces. Seeded 2026-07-21 from **kriskowal/kni**, a whitespace-significant language that presents as interactive-fiction tooling but is, read past the storytelling framing, a decision-graph language: an author writes text interleaved with options, conditions, variable mutations, labels, loops, and procedures; a four-stage parser flattens the authored nesting into a JSON instruction graph; and a small pluggable engine walks that graph with a program counter and a call stack, accumulating narrative and options, prompting, and tracing the chosen branch. This topic collects kni's grammar, its compiled state-machine model, its runtime/engine and handler hooks, and its input/elicitation model. Distinct from `automatic-agentic-loop` (which evaluates decision graphs specifically as the deterministic half of an agent-context loop) and from `llm-agent-frameworks` (LLM orchestration runtimes like LangGraph, whose node/edge/checkpointer model is a sibling graph-execution shape).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [overview](../sections/kni--readme--overview.md) | kni README | kni is a decision-graph language plus a graph-walking runtime; a script is text interleaved with options, and the engine enters at the top, accumulates options, prompts, and traces the chosen branch. |
| [command-line-tooling](../sections/kni--readme--command-line-tooling.md) | kni README | The `kni` CLI records transcripts, verifies a script still reproduces a transcript, compiles to/runs from JSON, restores a waypoint, and prints the compiled graph as a diagnostic listing. |
| [manual overview](../sections/kni--manual--overview.md) | kni MANUAL | kni is parser, compiler, and runtime in one command; `-j` dumps the compiled JSON state machine, `--html` emits a standalone page. |
| [text-space-and-symbols](../sections/kni--manual--text-space-and-symbols.md) | kni MANUAL | Text (narrative) versus significant symbols; the collapsed-space whitespace model and brace concatenation across lines. |
| [indentation-and-threads](../sections/kni--manual--indentation-and-threads.md) | kni MANUAL | Significant whitespace defines threads; `*`/`+`/`-` bullets; deeper columns start branches; loose ends gather after the next prompt. |
| [options-and-questions](../sections/kni--manual--options-and-questions.md) | kni MANUAL | The option is the branch-and-elicit primitive: accumulate until `>`, present, resume; question/answer bracket notation, non-options, and keyword-addressable options. |
| [input-prompts](../sections/kni--manual--input-prompts.md) | kni MANUAL | A prompt with a variable name captures free-form interlocutor input into a variable, with an optional validation/conversion cue — the elicitation primitive. |
| [flow-directives](../sections/kni--manual--flow-directives.md) | kni MANUAL | Line/paragraph breaks, `->label` goto, `<-` return/exit, `@label` transitions, and the `@...` loop label — the edge-forming vocabulary. |
| [procedures](../sections/kni--manual--procedures.md) | kni MANUAL | Callable, returning labels with local scope and arguments — the graph's subroutine mechanism. |
| [blocks-sequences-and-alternation](../sections/kni--manual--blocks-sequences-and-alternation.md) | kni MANUAL | Brace-block selection families: stateful sequences, alternation, and the random families (shuffle, weighted, hypergeometric sampling). |
| [blocks-switch-conditions-and-modifiers](../sections/kni--manual--blocks-switch-conditions-and-modifiers.md) | kni MANUAL | Echo, variable switch, ternary conditions, variable loops, hash-based arbitrary switch, and in-place variable modifiers — the read/branch/write surface. |
| [expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md) | kni MANUAL | 32-bit integer algebra and functions; interpolated variable names; the condition-and-consequence option operators that fuse a guard with a state transition. |
| [tutorial-getting-started](../sections/kni--howto--tutorial-getting-started.md) | kni HOWTO | Beginner walkthrough: install/run, first choice, indentation-binds-body, show-once options, labels/jumps, and endings. |
| [tutorial-state-and-flow](../sections/kni--howto--tutorial-state-and-flow.md) | kni HOWTO | Beginner walkthrough: variables, conditional and consequence options, the locked-door example, random events, sequences, loops, and procedures. |
| [parser-pipeline](../sections/kni--hackni--parser-pipeline.md) | kni HACKNI | The four-stage recursive-descent parser (scanner → outline-lexer → inline-lexer → grammar) that compiles nested script into a flat, VM-like instruction graph. |
| [runtime-engine](../sections/kni--hackni--runtime-engine.md) | kni HACKNI | The engine walks the JSON graph with a program counter and a call stack, with pluggable storage/RNG and a seeded xorshift128 PRNG for reproducible transcripts. |
| [runtime-hooks](../sections/kni--hackni--runtime-hooks.md) | kni HACKNI | The Engine `handler` interface: `has`/`get`/`set`/`changed`, `waypoint`/`resume`, `goto`, and `ask`/`answer`/`end` — the seam binding the graph walk to external state and notifications. |
| [dialogs-and-renderers](../sections/kni--hackni--dialogs-and-renderers.md) | kni HACKNI | The pluggable input (dialog: `ask`/`answer`) and output (renderer: `write`/`option`/`display`) boundary; web and command-line implementations. |
| [shared-ideas-and-differences](../sections/kni--inkkni--shared-ideas-and-differences.md) | kni INKKNI | What kni shares with Inkle's Ink and how it diverges (pure JS, significant whitespace, explicit prompt, fully-qualified labels). |
| [kni-beyond-ink-and-limitations](../sections/kni--inkkni--kni-beyond-ink-and-limitations.md) | kni INKKNI | What kni adds over Ink (subroutines, second-person options, procedural-generation operators, `<hook>` hooks) and what it still lacks (types, label-values, modules, user functions). |
|[read bot interview](../sections/kni--examples-read--overview.md) | kni examples/read.kni | A literal bot intake: collect free text plus a bounded choice, then render the recorded fields.
|[calc state-machine loop](../sections/kni--examples-calc--overview.md) | kni examples/calc.kni | Render `n`, offer named mutations, and loop: the smallest explicit state-machine controller.
|[door-lock state machine](../sections/kni--examples-door-lock--overview.md) | kni examples/door-lock.kni | Guards filter legal door actions and local mutations update the shared two-room state.
|[forest procedural walk](../sections/kni--examples-forest--overview.md) | kni examples/forest.kni | Render a hash-derived local feature from `x`, mutate position, and return to the loop.
|[maze navigation](../sections/kni--examples-maze--overview.md) | kni examples/maze.kni | Compute state-derived directional guards, render only open moves, update coordinates, and repeat.

## See also

- [automatic-agentic-loop](automatic-agentic-loop.md) — evaluates kni-style decision graphs specifically as the deterministic half of a mutually-reinforcing automatic ↔ agentic loop for developing agent context.
- [llm-agent-frameworks](llm-agent-frameworks.md) — LangGraph's node/edge/State/checkpointer runtime is a sibling graph-execution model with its own human-in-the-loop and persistence machinery.
- [change-propagation](change-propagation.md) — the cross-cutting theory of how a change in one place is reflected elsewhere; a decision graph's variable state and conditional threads are one such propagation shape.
