---
title: "LangGraph streaming: stream modes and the v2 StreamPart format"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/streaming
source_content_sha256: 9f6b826e6bf833ba01d39b329ca0a2d3c2b02fb5192d1b30285f571589cac698
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The LangGraph-runtime stream-mode API; companion to the LangChain-agent streaming sections (web--langchain-streaming-*), filed under the same agent-streaming concept. The newer typed-projection event-streaming API (v3, stream_events) is recommended for new apps but lives on a separate page."
---

Abstract: A compiled LangGraph graph exposes `stream` (sync) and `astream` (async), which yield streamed outputs as iterators; you pass one or more **stream modes** as a list to control what you receive. The seven modes are `values` (full state after each step), `updates` (only the changed keys per step), `messages` (`(token, metadata)` tuples from LLM calls), `custom` (data emitted via `get_stream_writer`), `checkpoints` (checkpoint events, requires a checkpointer), `tasks` (task start/finish events, requires a checkpointer), and `debug` (everything — `checkpoints` + `tasks` + extra metadata). Passing `version="v2"` (requires LangGraph ≥ 1.1) gives a **unified `StreamPart` format**: every chunk, regardless of mode count or subgraph settings, is a dict `{"type": <mode>, "ns": <namespace-tuple>, "data": <payload>}`, with a per-mode `TypedDict` (`ValuesStreamPart`, `UpdatesStreamPart`, …) and a `StreamPart` union that narrows on `part["type"]`. Under the v1 default, the output shape instead varies by options (single mode → raw data, multiple modes → `(mode, data)` tuples, subgraphs → `(namespace, data)` tuples).

## Basic usage

Graphs expose `stream` / `astream` as iterators. Pass a `stream_mode` list and `version="v2"`:

```python
for chunk in graph.stream(
    {"topic": "ice cream"},
    stream_mode=["updates", "custom"],
    version="v2",
):
    if chunk["type"] == "updates":
        for node_name, state in chunk["data"].items():
            print(f"Node {node_name} updated: {state}")
    elif chunk["type"] == "custom":
        print(f"Status: {chunk['data']['status']}")
```

## Stream modes

Pass one or more of these modes as a list to `stream` / `astream`:

| Mode | Type | Description |
| :--- | :--- | :--- |
| `values` | `ValuesStreamPart` | Full state after each step. |
| `updates` | `UpdatesStreamPart` | State updates after each step. Multiple updates in the same step are streamed separately. |
| `messages` | `MessagesStreamPart` | 2-tuples of (LLM token, metadata) from LLM calls. |
| `custom` | `CustomStreamPart` | Custom data emitted from nodes via `get_stream_writer`. |
| `checkpoints` | `CheckpointStreamPart` | Checkpoint events (same format as `get_state()`). Requires a checkpointer. |
| `tasks` | `TasksStreamPart` | Task start/finish events with results and errors. Requires a checkpointer. |
| `debug` | `DebugStreamPart` | All available info — combines `checkpoints` and `tasks` with extra metadata. |

## Stream output format (v2)

Requires LangGraph ≥ 1.1; all examples on the page use `version="v2"`. Pass it to `stream()` / `astream()` for a unified output format. Every chunk is a `StreamPart` dict with a consistent shape regardless of stream mode, number of modes, or subgraph settings:

```python
{
    "type": "values" | "updates" | "messages" | "custom" | "checkpoints" | "tasks" | "debug",
    "ns": (),           # namespace tuple, populated for subgraph events
    "data": ...,        # the actual payload (type varies by stream mode)
}
```

Each mode has a corresponding `TypedDict` (`ValuesStreamPart`, `UpdatesStreamPart`, `MessagesStreamPart`, `CustomStreamPart`, `CheckpointStreamPart`, `TasksStreamPart`, `DebugStreamPart`), importable from `langgraph.types`. The union `StreamPart` is a disjoint union on `part["type"]`, enabling full type narrowing in editors and type checkers. Under v1 (default), the format changes with your options (single mode → raw data; multiple modes → `(mode, data)` tuples; subgraphs → `(namespace, data)` tuples); under v2 it is always the same dict, and you filter by `chunk["type"]` to narrow `part["data"]` to the per-mode payload type:

```python
for part in graph.stream(
    {"topic": "ice cream"},
    stream_mode=["values", "updates", "messages", "custom"],
    version="v2",
):
    if part["type"] == "values":
        print(f"State: topic={part['data']['topic']}")
    elif part["type"] == "updates":
        for node_name, state in part["data"].items():
            print(f"Node `{node_name}` updated: {state}")
    elif part["type"] == "messages":
        msg, metadata = part["data"]
        print(msg.content, end="", flush=True)
    elif part["type"] == "custom":
        print(f"Progress: {part['data']['progress']}%")
```

## Multiple modes at once

Pass a list as `stream_mode` to stream several modes; with `version="v2"` every chunk is a `StreamPart` dict and you distinguish modes via `chunk["type"]`:

```python
for chunk in graph.stream(inputs, stream_mode=["updates", "custom"], version="v2"):
    if chunk["type"] == "updates":
        for node_name, state in chunk["data"].items():
            print(f"Node `{node_name}` updated: {state}")
    elif chunk["type"] == "custom":
        print(f"Custom event: {chunk['data']}")
```

Source: [Streaming](https://docs.langchain.com/oss/python/langgraph/streaming) at content SHA-256 `9f6b826e`.
