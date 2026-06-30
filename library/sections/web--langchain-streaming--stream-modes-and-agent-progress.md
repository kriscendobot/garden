---
title: "Streaming: stream modes, agent progress, LLM tokens, and custom updates"
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
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30, LangChain streaming + middleware focus)."
---

Abstract: LangChain's streaming surfaces live updates from agent runs by passing one or more **stream modes** as a list to `agent.stream(...)` / `astream(...)`. Three modes are the building blocks: `updates` streams state updates after each agent step (a separate event per node that ran in a super-step), `messages` streams `(token, metadata)` tuples from every node where an LLM is invoked (token-level), and `custom` streams arbitrary data emitted from inside a node via the stream writer. **Agent progress** uses `stream_mode="updates"` to get one event after each step (the LLM-node `AIMessage` with tool-call requests, the tool-node `ToolMessage` result, then the final `AIMessage`); pass a `thread_id` via `config` (requires a checkpointer) so the conversation is persisted and follow-up turns resume. **LLM tokens** use `stream_mode="messages"`, yielding incremental `AIMessageChunk`s (including `tool_call_chunk`s as partial-JSON tool args build up). **Custom updates** come from `get_stream_writer()` called inside a tool. You can request several modes at once (`stream_mode=["updates", "custom"]`); each chunk is then a `StreamPart` dict with `type`, `ns`, and `data` keys — branch on `chunk["type"]` to pick the mode and read `chunk["data"]` for the payload.

## Supported stream modes

Pass one or more as a list to `stream` / `astream`:

| Mode       | Description                                                                                                                   |
| ---------- | --------------------------------------------------------------------------------------------------------------------------- |
| `updates`  | State updates after each agent step. If multiple updates happen in one step (multiple nodes run), each is streamed separately. |
| `messages` | Tuples of `(token, metadata)` from any graph node where an LLM is invoked.                                                    |
| `custom`   | Custom data emitted from inside graph nodes via the stream writer.                                                            |

## Agent progress (`updates`)

`stream_mode="updates"` emits an event after every agent step. For an agent that calls one tool, you see: the model node emitting an `AIMessage` with tool-call requests, the tool node emitting a `ToolMessage` with the result, then the model node emitting the final AI response. `thread_id` (passed via `config={"configurable": {"thread_id": ...}}`) is independent of `stream_mode` and checkpoints the conversation so follow-up turns resume the same history. Persisting with `thread_id` requires a checkpointer; on LangSmith deployments one is provisioned automatically, locally you pass `create_agent(..., checkpointer=InMemorySaver())`.

## LLM tokens (`messages`)

`stream_mode="messages"` streams tokens as the LLM produces them. Each chunk is `(token, metadata)`; `metadata["langgraph_node"]` names the emitting node, and `token.content_blocks` carries the standard content. While a tool call is being generated the chunks are `tool_call_chunk`s whose `args` field accumulates partial JSON; text responses arrive as incremental `text` blocks.

## Custom updates (`custom`)

To stream arbitrary signals (e.g. `"Fetched 10/100 records"`) from inside a tool, call `get_stream_writer()` (from `langgraph.config`) and invoke the returned writer with any data, then consume with `stream_mode="custom"`. Note: adding `get_stream_writer` inside a tool means the tool can no longer be invoked outside a LangGraph execution context.

```python
from langgraph.config import get_stream_writer

def get_weather(city: str) -> str:
    writer = get_stream_writer()
    writer(f"Looking up data for city: {city}")
    return f"It's always sunny in {city}!"
```

## Stream multiple modes

Pass a list of modes: `stream_mode=["updates", "custom"]`. Each streamed chunk is a `StreamPart` dict with `type`, `ns`, and `data` keys; use `chunk["type"]` to determine the mode and `chunk["data"]` for the payload. (This unified per-chunk dict is the `version="v2"` shape; see the v2-format section.)

Source: [LangChain streaming](https://docs.langchain.com/oss/python/langchain/streaming) retrieved 2026-06-30, content hash `7f967e5c`.
