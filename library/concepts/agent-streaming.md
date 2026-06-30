---
id: agent-streaming
aliases: [streaming, stream mode, stream_mode, agent.stream, astream, stream_events, updates mode, messages mode, custom mode, StreamPart, get_stream_writer, stream writer, AIMessageChunk, tool_call_chunk, chunk_position, v2 streaming format, version v2, GraphOutput, lc_agent_name, subgraphs streaming, disable_streaming, streaming reasoning tokens, event streaming]
topics: [llm-agent-frameworks, agent-conventions, patterns]
---

# agent-streaming

In LangChain / [[langgraph]], **streaming** surfaces real-time updates from an agent run by passing one or more **stream modes** as a list to `agent.stream(...)` / `astream(...)`. The three base modes are `updates` (state updates after each agent step — agent progress), `messages` (`(token, metadata)` tuples from every node where an LLM is invoked — token-level, including partial-JSON `tool_call_chunk`s), and `custom` (arbitrary data emitted inside a node via `get_stream_writer()`). Requesting several modes returns each chunk as a `StreamPart` dict with `type` / `ns` / `data` keys; this uniform shape is the `version="v2"` format (requires LangGraph ≥ 1.1), which also makes `invoke()` return a `GraphOutput` with `.value` and `.interrupts`. Common patterns build on the modes: stream **reasoning** tokens by filtering `content_blocks` for `type == "reasoning"`; get both partial and completed **tool calls** via `stream_mode=["messages", "updates"]` or by summing `AIMessageChunk`s until `chunk_position == "last"`; handle **human-in-the-loop** by collecting `__interrupt__` entries from the `updates` stream and resuming with `Command(resume=...)`; disambiguate **sub-agents** by setting a `name` and reading `lc_agent_name` with `subgraphs=True`. Per-model streaming is disabled with `streaming=False` / `disable_streaming=True`. The newer typed-projection **event-streaming** API (`stream_events`, LangChain v1.3) gives separate iterators per projection instead of branching on `stream_mode` chunks.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [stream modes and agent progress](../sections/web--langchain-streaming--stream-modes-and-agent-progress.md) | The three modes (updates/messages/custom), agent progress, LLM tokens, custom updates, multiple modes. |
| [common patterns: reasoning, tool calls, HITL, sub-agents](../sections/web--langchain-streaming--common-patterns-reasoning-tool-calls-hitl-subagents.md) | Reasoning tokens, partial+completed tool calls, HITL streaming, sub-agent disambiguation. |
| [disable streaming and the v2 format](../sections/web--langchain-streaming--disable-streaming-and-v2-format.md) | Per-model streaming off; the `version="v2"` unified StreamPart shape and GraphOutput. |
| [agent invocation, runtime context, and streaming](../sections/web--langchain-agents--invocation-streaming-and-state.md) | Streaming as part of invoking an agent against the LangGraph State. |

## See also

- [[langchain]] — the agent framework whose `stream`/`astream` this describes.
- [[langgraph]] — streaming is a LangGraph runtime feature surfaced through LangChain agents; the LangGraph `langgraph/streaming` page (deferred) adds `values`/`debug` modes and subgraph streaming.
- [[human-in-the-loop]] — interrupts are surfaced and resumed inside the streaming loop.
- [[middleware]] — middleware can register stream transformers that project onto typed channels (e.g. PII redaction of wire output).
