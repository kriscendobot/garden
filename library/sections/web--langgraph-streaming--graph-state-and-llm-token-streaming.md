---
title: "LangGraph streaming: graph state (values/updates) and LLM token (messages) modes"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/streaming
source_content_sha256: 9f6b826e6bf833ba01d39b329ca0a2d3c2b02fb5192d1b30285f571589cac698
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, change-propagation]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The two most-used stream modes in detail; filed under agent-streaming alongside the LangChain-agent messages-mode section (web--langchain-streaming--stream-modes-and-agent-progress)."
---

Abstract: The two stream modes that surface the graph's own progress. `updates` streams the **state updates** returned by each node after each step, tagged with the node name; `values` streams the **full state** after each step. The `messages` mode streams Large Language Model output **token by token** from anywhere in the graph (nodes, tools, subgraphs, tasks) as `(message_chunk, metadata)` tuples — `message_chunk` is the token, `metadata` carries graph-node and LLM-invocation details. Message events are emitted even when the LLM is run with `.invoke` rather than `.stream`. Three filters refine the token stream: attach `tags` to a model at init and filter on `metadata["tags"]`; filter on `metadata["langgraph_node"]` to take tokens from one node; and tag a model with the special `nostream` tag to **omit** its tokens from `messages` mode entirely (it still runs and produces output) — useful for internal/structured-output calls or to avoid duplicating output you stream through a different channel.

## Graph state: updates vs values

```python
class State(TypedDict):
    topic: str
    joke: str

def refine_topic(state: State):
    return {"topic": state["topic"] + " and cats"}

def generate_joke(state: State):
    return {"joke": f"This is a joke about {state['topic']}"}
```

`updates` streams only the state updates returned by the nodes after each step, including the node name:

```python
for chunk in graph.stream({"topic": "ice cream"}, stream_mode="updates", version="v2"):
    if chunk["type"] == "updates":
        for node_name, state in chunk["data"].items():
            print(f"Node `{node_name}` updated: {state}")
# Node `refine_topic` updated: {'topic': 'ice cream and cats'}
# Node `generate_joke` updated: {'joke': 'This is a joke about ice cream and cats'}
```

`values` streams the full state after each step:

```python
for chunk in graph.stream({"topic": "ice cream"}, stream_mode="values", version="v2"):
    if chunk["type"] == "values":
        print(f"topic: {chunk['data']['topic']}, joke: {chunk['data']['joke']}")
# topic: ice cream, joke:
# topic: ice cream and cats, joke:
# topic: ice cream and cats, joke: This is a joke about ice cream and cats
```

## LLM tokens (messages mode)

Use `messages` to stream LLM output token by token from any part of the graph. The output is a tuple `(message_chunk, metadata)`: `message_chunk` is the token/segment, `metadata` is a dict with graph-node and LLM-invocation details. **Message events are emitted even when the LLM is run using `.invoke` rather than `.stream`.** (If your LLM is not a LangChain integration, use `custom` mode instead.)

```python
for chunk in graph.stream({"topic": "ice cream"}, stream_mode="messages", version="v2"):
    if chunk["type"] == "messages":
        message_chunk, metadata = chunk["data"]
        if message_chunk.content:
            print(message_chunk.content, end="|", flush=True)
```

### Filter by LLM invocation (tags)

Associate `tags` with LLM invocations at init time, then filter the streamed tokens on `metadata["tags"]`:

```python
model_1 = init_chat_model(model="gpt-5.4-mini", tags=['joke'])
model_2 = init_chat_model(model="gpt-5.4-mini", tags=['poem'])
...
async for chunk in graph.astream({"topic": "cats"}, stream_mode="messages", version="v2"):
    if chunk["type"] == "messages":
        msg, metadata = chunk["data"]
        if metadata["tags"] == ["joke"]:
            print(msg.content, end="|", flush=True)
```

### Omit messages from the stream (nostream)

Use the `nostream` tag to exclude a model's output from `messages` mode entirely. Invocations tagged `nostream` still run and produce output; their tokens are simply not emitted. Useful when you need LLM output for internal processing (e.g. structured output) but do not want to stream it, or you stream the same content through a different channel and want to avoid duplicates:

```python
internal_model = ChatAnthropic(model_name="claude-haiku-4-5-20251001").with_config(
    {"tags": ["nostream"]}
)
```

### Filter by node

To stream tokens only from specific nodes, filter on `metadata["langgraph_node"]`:

```python
for chunk in graph.stream(inputs, stream_mode="messages", version="v2"):
    if chunk["type"] == "messages":
        msg, metadata = chunk["data"]
        if msg.content and metadata["langgraph_node"] == "some_node_name":
            ...
```

Source: [Streaming](https://docs.langchain.com/oss/python/langgraph/streaming) at content SHA-256 `9f6b826e`.
