---
title: "LangGraph streaming: any-LLM custom streaming, disabling streaming, and v1→v2 migration"
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
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The advanced streaming section: non-LangChain LLMs, per-model streaming disable, the v1→v2 migration table, and the Python < 3.11 async caveats; filed under agent-streaming."
---

Abstract: Advanced streaming concerns. To stream **any LLM API** that does not implement the LangChain chat-model interface, drive its native streaming client inside a node and forward each chunk through `get_stream_writer()` under `stream_mode="custom"`. To **disable streaming** for a model that does not support it, set `streaming=False` at init (or `disable_streaming=True`, available on all chat models via the base class, for integrations that lack the `streaming` parameter). The **v1→v2 migration** turns option-dependent output shapes into one `StreamPart` dict and changes `invoke()`/`ainvoke()` to return a typed `GraphOutput` with `.value` and `.interrupts` (replacing the deprecated `__interrupt__`-key / dict-access pattern), and coerces Pydantic/dataclass state to its model type in `values` mode. On **Python < 3.11**, async streaming needs two manual steps because asyncio tasks lack the `context` parameter: pass `RunnableConfig` explicitly into async LLM calls, and use a `writer` parameter instead of `get_stream_writer`.

## Use with any LLM

`stream_mode="custom"` streams data from any LLM API even if it does not implement the LangChain chat-model interface — drive the raw client and forward each chunk via the stream writer:

```python
from langgraph.config import get_stream_writer

def call_arbitrary_model(state):
    """Example node that calls an arbitrary model and streams the output."""
    writer = get_stream_writer()
    for chunk in your_custom_streaming_client(state["topic"]):
        writer({"custom_llm_chunk": chunk})
    return {"result": "completed"}

for chunk in graph.stream({"topic": "cats"}, stream_mode="custom", version="v2"):
    if chunk["type"] == "custom":
        print(chunk["data"])
```

The same pattern works inside a tool that wraps a non-LangChain client (e.g. a raw `AsyncOpenAI` streaming call), forwarding each delta to the writer.

## Disable streaming for specific chat models

If your application mixes streaming and non-streaming models, disable streaming for those that do not support it. Set `streaming=False` when initializing the model:

```python
from langchain.chat_models import init_chat_model
model = init_chat_model("claude-sonnet-4-6", streaming=False)
```

```python
from langchain_openai import ChatOpenAI
model = ChatOpenAI(model="o1-preview", streaming=False)
```

> Not all chat model integrations support the `streaming` parameter. If yours doesn't, use `disable_streaming=True` instead — it is available on all chat models via the base class.

## Migrate to v2

The v2 format unifies output. Key differences:

| Scenario | v1 (default) | v2 (`version="v2"`) |
| --- | --- | --- |
| Single stream mode | Raw data (dict) | `StreamPart` dict with `type`, `ns`, `data` |
| Multiple stream modes | `(mode, data)` tuples | Same `StreamPart` dict, filter on `chunk["type"]` |
| Subgraph streaming | `(namespace, data)` tuples | Same `StreamPart` dict, check `chunk["ns"]` |
| Multiple modes + subgraphs | `(namespace, mode, data)` triples | Same `StreamPart` dict |
| `invoke()` return type | Plain dict (state) | `GraphOutput` with `.value` and `.interrupts` |
| Interrupt location (stream) | `__interrupt__` key in state dict | `interrupts` field on `values` stream parts |
| Interrupt location (invoke) | `__interrupt__` key in result dict | `.interrupts` attribute on `GraphOutput` |
| Pydantic/dataclass output | Returns plain dict | Coerces to model/dataclass instance |

### v2 invoke format

With `version="v2"`, `invoke()`/`ainvoke()` returns a `GraphOutput` with `.value` and `.interrupts`:

```python
from langgraph.types import GraphOutput

result = graph.invoke(inputs, version="v2")
assert isinstance(result, GraphOutput)
result.value       # your output — dict, Pydantic model, or dataclass
result.interrupts  # tuple[Interrupt, ...], empty if none occurred
```

With any stream mode other than the default `"values"`, `invoke(..., stream_mode="updates", version="v2")` returns `list[StreamPart]` instead of `list[tuple]`. Dict-style access on `GraphOutput` (`result["key"]`, `result["__interrupt__"]`) still works for backwards compatibility but is **deprecated**; migrate to `result.value` / `result.interrupts`. Interrupt handling becomes:

```python
result = graph.invoke(inputs, config=config, version="v2")
if result.interrupts:
    print(result.interrupts[0].value)
    graph.invoke(Command(resume=True), config=config, version="v2")
```

### Pydantic and dataclass state coercion

When graph state is a Pydantic model or dataclass, v2 `values` mode coerces output to the correct type:

```python
# With version="v2", chunk["data"] is a MyState instance
for chunk in graph.stream({"value": "x", "items": []}, stream_mode="values", version="v2"):
    print(type(chunk["data"]))  # <class 'MyState'>
```

## Async with Python < 3.11

Asyncio tasks do not support the `context` parameter before Python 3.11, which limits automatic context propagation and affects streaming in two ways:

1. You **must** explicitly pass `RunnableConfig` into async LLM calls (e.g. `ainvoke()`), as callbacks are not automatically propagated.
2. You **cannot** use `get_stream_writer` in async nodes or tools — pass a `writer` argument directly (e.g. `async def generate_joke(state, writer: StreamWriter)`).

Source: [Streaming](https://docs.langchain.com/oss/python/langgraph/streaming) at content SHA-256 `9f6b826e`.
