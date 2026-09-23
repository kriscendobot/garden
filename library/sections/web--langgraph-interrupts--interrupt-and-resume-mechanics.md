---
title: "LangGraph interrupts: pause and resume mechanics"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/interrupts
source_content_sha256: 2b8b11d645f16c019d434392733a54d7be5d16fce0cdf70d4e2392e4383656b5
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Interrupts pause graph execution at a specific point and wait for external input — the foundation of human-in-the-loop. Calling `interrupt(payload)` inside a node suspends execution, saves the graph state via the persistence (checkpointer) layer, surfaces the JSON-serializable payload to the caller, and waits indefinitely. To use it you need a **checkpointer** (durable in production), a **`thread_id`** in config (the persistent cursor that selects which state to resume — reuse resumes the same checkpoint, a new value starts an empty thread), and an `interrupt()` call where the pause should happen. You resume by re-invoking the graph with `Command(resume=value)`; that value becomes the return of the `interrupt()` call. Unlike static breakpoints, interrupts are **dynamic** (placeable anywhere, conditional). The recommended driver is event streaming (`graph.stream_events(..., version="v3")`), which surfaces payloads on `stream.interrupts` and sets `stream.interrupted`; the default `invoke()` surfaces them under `result["__interrupt__"]`. Critically, on resume the **entire node restarts from the beginning** — code before the `interrupt()` runs again — and `Command(resume=...)` is the only `Command` form valid as graph *input* (`update`/`goto`/`graph` are for returning from nodes).

## Pause using `interrupt`

The `interrupt` function pauses graph execution and returns a value to the caller. When called within a node, LangGraph saves the current graph state and waits for you to resume with input. To use it you need: (1) a **checkpointer** to persist the graph state (durable in production); (2) a **thread ID** in your config so the runtime knows which state to resume from; (3) to call `interrupt()` where you want to pause (the payload must be JSON-serializable).

```python
from langgraph.types import interrupt

def approval_node(state):
    approved = interrupt("Do you approve this action?")
    # When you resume, Command(resume=...) returns that value here
    return {"approved": approved}
```

When `interrupt` is called: graph execution suspends at the exact call point; state is saved via the checkpointer; the value is returned to the caller (on `stream.interrupts` with event streaming, or under `__interrupt__` with `invoke()`); the graph waits indefinitely; and the resume response is passed back into the node, becoming the return value of the `interrupt()` call.

The `thread_id` is effectively a persistent cursor: reusing it resumes the same checkpoint; a new value starts a brand-new thread with empty state. Interrupts are **dynamic** — unlike static breakpoints (which pause before/after specific nodes), they can be placed anywhere and made conditional on application logic.

## Resuming interrupts

After an interrupt pauses execution, resume the graph by invoking it again with a `Command` containing the resume value, which is passed back to the `interrupt` call so the node continues with the external input. The recommended driver is event streaming, which surfaces interrupts via `stream.interrupts` / `stream.interrupted` and exposes the final state through `stream.output`:

```python
from langgraph.types import Command

config = {"configurable": {"thread_id": "thread-1"}}
stream = graph.stream_events({"input": "data"}, config=config, version="v3")
final = stream.output                      # drive the run
if stream.interrupted:
    print(stream.interrupts)               # (Interrupt(value='Do you approve this action?'),)
resumed = graph.stream_events(Command(resume=True), config=config, version="v3")
final = resumed.output
```

Key points: use the **same thread ID** when resuming; the value passed to `Command(resume=...)` becomes the return value of the `interrupt` call; the node **restarts from the beginning** when resumed, so any code before the `interrupt` runs again; any JSON-serializable value may be passed.

`Command(resume=...)` is the **only** `Command` pattern intended as input to `invoke()`/`stream()`/`stream_events()`. The other `Command` parameters (`update`, `goto`, `graph`) are for returning from node functions — do not pass `Command(update=...)` as input to continue a conversation; pass a plain input dict instead.

## Using with subgraphs called as functions

When invoking a subgraph within a node, both the parent graph and the subgraph resume from the **beginning of the node** where the subgraph was invoked and the interrupt was triggered. Any code before the subgraph call (in the parent) and before the `interrupt` (in the subgraph) re-executes on resume.

Source: [LangGraph interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts) retrieved 2026-06-30, content hash `2b8b11d6`.
