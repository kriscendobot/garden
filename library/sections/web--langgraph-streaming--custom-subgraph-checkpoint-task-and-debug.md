---
title: "LangGraph streaming: custom, subgraph, checkpoint, task, and debug modes"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/streaming
source_content_sha256: 9f6b826e6bf833ba01d39b329ca0a2d3c2b02fb5192d1b30285f571589cac698
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The remaining stream modes (custom data, subgraph namespacing, and the checkpointer-requiring runtime-event modes); filed under agent-streaming."
---

Abstract: The stream modes beyond state and tokens. `custom` mode emits arbitrary user-defined data from inside a node or tool: call `get_stream_writer()` (from `langgraph.config`), invoke the writer with any value, and set `stream_mode="custom"` (at least one mode must be `custom`). **Subgraph** outputs are included by passing `subgraphs=True` to the parent's `.stream()`; under v2 each chunk keeps the `StreamPart` shape and the `ns` namespace tuple identifies the source (`()` for root, `("node_name:<task_id>",)` for a subgraph). Three modes require a checkpointer and expose runtime events: `checkpoints` (one event per checkpoint, same format as `get_state()`), `tasks` (task start/finish events with node name, results, and errors), and `debug` (the superset — `checkpoints` + `tasks` plus extra metadata).

## Custom data

To send custom user-defined data from inside a node or tool: use `get_stream_writer` to access the writer and emit data, and set `stream_mode="custom"` when calling `.stream()` / `.astream()`. You can combine modes (e.g. `["updates", "custom"]`), but at least one must be `custom`.

From a node:

```python
from langgraph.config import get_stream_writer

def node(state: State):
    writer = get_stream_writer()
    writer({"custom_key": "Generating custom data inside node"})
    return {"answer": "some data"}

for chunk in graph.stream(inputs, stream_mode="custom", version="v2"):
    if chunk["type"] == "custom":
        print(f"Custom event: {chunk['data']['custom_key']}")
```

From a tool (e.g. progress updates):

```python
@tool
def query_database(query: str) -> str:
    """Query the database."""
    writer = get_stream_writer()
    writer({"data": "Retrieved 0/100 records", "type": "progress"})
    # perform query
    writer({"data": "Retrieved 100/100 records", "type": "progress"})
    return "some-answer"
```

> On Python < 3.11 in async code, `get_stream_writer` does not work; add a `writer` parameter to your node or tool and pass it manually.

## Subgraph outputs

To include outputs from [subgraphs](web--langgraph-use-graph-api--command-routing-subgraphs-and-visualization.md), set `subgraphs=True` in the parent graph's `.stream()`. Outputs come as `(namespace, data)`, where `namespace` is the path to the node where a subgraph is invoked, e.g. `("parent_node:<task_id>", "child_node:<task_id>")`. With `version="v2"`, subgraph events use the same `StreamPart` format and the `ns` field identifies the source:

```python
for chunk in graph.stream(
    {"foo": "foo"},
    subgraphs=True,
    stream_mode="updates",
    version="v2",
):
    print(chunk["type"])  # "updates"
    print(chunk["ns"])    # () for root, ("node_name:<task_id>",) for subgraph
    print(chunk["data"])  # {"node_name": {"key": "value"}}
```

In a parent graph with a compiled subgraph as a node, the stream interleaves root and subgraph updates, each carrying its namespace:

```
Root: {'node_1': {'foo': 'hi! foo'}}
Subgraph ('node_2:dfddc4ba-...',): {'subgraph_node_1': {'bar': 'bar'}}
Subgraph ('node_2:dfddc4ba-...',): {'subgraph_node_2': {'foo': 'hi! foobar'}}
Root: {'node_2': {'foo': 'hi! foobar'}}
```

## Checkpoints, tasks, and debug

These three modes require a [checkpointer](web--langgraph-persistence--checkpointers-vs-stores.md).

`checkpoints` receives a checkpoint event as the graph executes; each event has the same format as the output of `get_state()`:

```python
for chunk in graph.stream(
    {"topic": "ice cream"}, config=config, stream_mode="checkpoints", version="v2"
):
    if chunk["type"] == "checkpoints":
        print(chunk["data"])
```

`tasks` receives task start and finish events — which node is running, its results, and any errors:

```python
for chunk in graph.stream(
    {"topic": "ice cream"}, config=config, stream_mode="tasks", version="v2"
):
    if chunk["type"] == "tasks":
        print(chunk["data"])
```

`debug` streams as much information as possible throughout execution (node name plus full state). It combines `checkpoints` and `tasks` events with additional metadata; use `checkpoints` or `tasks` directly if you only need a subset:

```python
for chunk in graph.stream({"topic": "ice cream"}, stream_mode="debug", version="v2"):
    if chunk["type"] == "debug":
        print(chunk["data"])
```

Source: [Streaming](https://docs.langchain.com/oss/python/langgraph/streaming) at content SHA-256 `9f6b826e`.
