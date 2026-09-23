---
title: "LangGraph interrupts: rules and static breakpoints"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/interrupts
source_content_sha256: 2b8b11d645f16c019d434392733a54d7be5d16fce0cdf70d4e2392e4383656b5
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: All four rules of interrupts follow from one mechanism: `interrupt()` suspends by **raising a special exception** that the runtime catches to save state, and on resume the runtime **restarts the entire node from the beginning** (not the exact line), so code before the interrupt re-executes. Therefore: (1) **do not wrap `interrupt` in a bare try/except** — it would swallow the suspend exception; catch only specific exception types and separate interrupts from error-prone code. (2) **Do not reorder or conditionally skip `interrupt` calls within a node** — resume matching is strictly index-based against the task's resume list, so a changed order or count (conditional skips, non-deterministic loops) mismatches answers to questions. (3) **Do not pass complex values to `interrupt`** — payloads must be JSON-serializable (no functions, class instances); use simple types and dicts of simple values. (4) **Side effects before `interrupt` must be idempotent** — because they re-run on resume; prefer upserts, place side effects after the interrupt, or isolate them in a separate node. Separately, **static interrupts** (`interrupt_before`/`interrupt_after` set at compile or run time) are breakpoints for debugging/stepping, explicitly **not** recommended for human-in-the-loop workflows.

## Rules of interrupts

Calling `interrupt` within a node suspends execution by raising a special exception that signals the runtime to pause; this propagates up and is caught by the runtime, which saves state and waits for input. On resume, the runtime **restarts the entire node from the beginning** — it does not resume from the exact line where `interrupt` was called. Any code that ran before the `interrupt` executes again. The four rules follow.

### Do not wrap `interrupt` calls in try/except

`interrupt` pauses by throwing a special exception; a bare `try/except` around the call catches it, so the interrupt is never passed back to the graph. Separate `interrupt` calls from error-prone code, and use specific exception types (which will not catch the interrupt exception) rather than a bare `except Exception`.

### Do not reorder `interrupt` calls within a node

When a node contains multiple interrupts, LangGraph keeps a per-task list of resume values. On every resume, execution starts at the node's beginning; for each interrupt encountered it checks for a matching value in the resume list. Matching is **strictly index-based**, so the order of interrupt calls matters. Keep the calls consistent across executions: do not conditionally skip interrupts (changing the order on resume causes an index mismatch), and do not loop interrupts on non-deterministic data, including `while True` validation loops (use a conditional edge instead — see *human-in-the-loop patterns*).

### Do not return complex values in `interrupt` calls

Depending on the checkpointer, complex values may not be serializable (you cannot serialize a function). Pass only simple, JSON-serializable types — strings, numbers, booleans, and dictionaries/objects of simple values. Do not pass functions, class instances, or other complex objects.

### Side effects called before `interrupt` must be idempotent

Because interrupts re-run the node they were called from, side effects before the `interrupt` should be idempotent (applying the operation multiple times has the same result as once). For example, an API call that creates a record before an `interrupt` will create duplicates on each resume. Use idempotent operations (upserts) before the interrupt, place side effects after the interrupt so they run once after the response, or separate side effects into their own node. Do not create new records (or append to lists) without checking existence before the interrupt.

## Debugging with static interrupts

To debug and test a graph, use **static interrupts** as breakpoints to step through execution one node at a time. They are triggered at defined points before or after a node, set via `interrupt_before` / `interrupt_after` at compile time (on `builder.compile(...)`) or run time (on `graph.invoke(...)`). A checkpointer is required. Run until a breakpoint with `graph.invoke(inputs, config)`, then resume with `graph.invoke(None, config)` until the next breakpoint. Static interrupts are **not** recommended for human-in-the-loop workflows — use the `interrupt()` function instead. LangSmith Studio can set static interrupts in the UI and inspect graph state at any point.

Source: [LangGraph interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts) retrieved 2026-06-30, content hash `2b8b11d6`.
