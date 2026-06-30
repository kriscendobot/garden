---
title: "Streaming: disabling per-model streaming and the v2 unified format"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/streaming
source_content_sha256: 7f967e5c4d677bc8e40fc1fac8d8e52adef8c7ac08a56897c7edb56f5bc3e02b
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30). The page's intro recommends the newer typed-projection event-streaming API (`stream_events`, v1.3) over branching on `stream_mode` chunks; that page is a separate deferred ingest (`langchain/event-streaming`)."
---

Abstract: Two operational details. **Disabling streaming for a specific model** is useful in multi-agent systems (control which agents stream), when mixing streaming and non-streaming models, or on LangSmith deployments where some model output should not reach the client: set `streaming=False` when initializing the model, or, if that chat-model integration does not support `streaming`, set `disable_streaming=True` (available on all chat models via the base class). **The v2 streaming format** (requires LangGraph ≥ 1.1) is requested by passing `version="v2"` to `stream()` / `astream()`: every chunk becomes a uniform `StreamPart` dict with `type`, `ns`, and `data` keys regardless of mode or number of modes — no more `(mode, data)` tuple unpacking. v2 also improves `invoke()`, which returns a `GraphOutput` object with `.value` (state) and `.interrupts` (a tuple of `Interrupt` objects, empty if none) cleanly separated. The page's own top-of-page tip points new applications at the newer **event streaming** API (`stream_events`, introduced in LangChain v1.3), which gives separate typed iterators per projection (messages, values, tool calls, subgraphs) instead of branching on `stream_mode` chunks.

## Disable streaming for a specific model

```python
from langchain_openai import ChatOpenAI
model = ChatOpenAI(model="gpt-5.5", streaming=False)
```

Reasons to disable: controlling which agents stream in a multi-agent system, mixing streaming-capable and non-streaming models, or preventing certain outputs from streaming to the client on a LangSmith deployment. If a chat-model integration does not support the `streaming` parameter, use `disable_streaming=True` instead (available on all chat models via the base class).

## v2 streaming format

Pass `version="v2"` to get the unified `StreamPart` shape (requires LangGraph ≥ 1.1):

```python
# Unified format — no more tuple unpacking
for chunk in agent.stream({"messages": [...]}, stream_mode=["updates", "custom"], version="v2"):
    print(chunk["type"])  # "updates" or "custom"
    print(chunk["data"])  # payload
```

Compared with v1, which unpacks `(mode, chunk)` tuples. v2 also changes `invoke()` to return a `GraphOutput`:

```python
result = agent.invoke({"messages": [...]}, version="v2")
print(result.value)       # state (dict, Pydantic model, or dataclass)
print(result.interrupts)  # tuple of Interrupt objects (empty if none)
```

The deeper LangGraph streaming docs cover type narrowing, Pydantic/dataclass coercion, and subgraph streaming under this v2 format.

Source: [LangChain streaming](https://docs.langchain.com/oss/python/langchain/streaming) retrieved 2026-06-30, content hash `7f967e5c`.
