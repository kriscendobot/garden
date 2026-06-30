---
title: "LangChain tools: accessing context via ToolRuntime"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/tools
source_content_sha256: a40a0dad0d7db34773b41d18074eec8e6f33c66305ab16b346e6df3679c10174
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions, persistence]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Tools are most powerful when they can read and update runtime information, which they reach through a single `ToolRuntime` parameter exposing seven facets. **State** (`runtime.state`) is short-term memory for the current conversation — message history plus custom fields; tools update it by returning a `Command`. **Context** (`runtime.context`) is immutable per-invocation configuration (user IDs, session info). **Store** (`runtime.store`) is long-term memory that survives across conversations, organized by a namespace/key pattern (the same `BaseStore` LangGraph exposes). **Stream Writer** (`runtime.stream_writer`) emits real-time progress updates during long-running tool execution. **Execution Info** (`runtime.execution_info`) gives thread ID, run ID, and retry/attempt state. **Server Info** (`runtime.server_info`) gives assistant ID, graph ID, and authenticated user when running on LangGraph Server. Plus the run's `RunnableConfig` and the current tool-call ID. This is the in-tool counterpart to LangGraph's short-term-checkpointer / long-term-store persistence split.

## Access context

Tools access runtime information through the `ToolRuntime` parameter, which provides:

| Facet | What it is | Use |
|---|---|---|
| **State** | Short-term memory — mutable data for the current conversation (messages, counters, custom fields) | Access conversation history, track tool-call counts |
| **Context** | Immutable configuration passed at invocation time (user IDs, session info) | Personalize responses based on user identity |
| **Store** | Long-term memory — persistent data that survives across conversations | Save user preferences, maintain a knowledge base |
| **Stream Writer** | Emit real-time updates during tool execution | Show progress for long-running operations |
| **Execution Info** | Identity and retry info for the current execution (thread ID, run ID, attempt number) | Adjust behavior based on retry state |
| **Server Info** | Server-specific metadata on LangGraph Server (assistant ID, graph ID, authenticated user) | Access assistant/graph IDs or authenticated user |
| **Config** | The execution's `RunnableConfig` | Access callbacks, tags, metadata |
| **Tool Call ID** | Unique identifier for the current tool invocation | Correlate tool calls for logs and model invocations |

### Short-term memory (State)

State is short-term memory existing for the duration of a conversation — message history plus any custom fields defined in the graph state. Tools read it with `runtime.state` and update it by returning a `Command` (include a `ToolMessage` in the update so the model sees the tool result).

### Context

Context provides immutable configuration passed at invocation time — user IDs, session details, application settings that should not change during a conversation. Access it through `runtime.context`; pass it alongside a `thread_id` so the conversation is persisted across turns.

### Long-term memory (Store)

The `BaseStore` provides persistent storage that survives across conversations; unlike state, data saved to the store remains available in future sessions. Access it through `runtime.store`, which uses a namespace/key pattern to organize data.

### Stream writer, execution info, server info

- **Stream writer** — `runtime.stream_writer` emits custom real-time updates for progress feedback during long-running operations.
- **Execution info** — `runtime.execution_info` exposes thread ID, run ID, and retry state.
- **Server info** — `runtime.server_info` exposes assistant ID, graph ID, and authenticated user when running on LangGraph Server.

Source: [LangChain tools](https://docs.langchain.com/oss/python/langchain/tools) retrieved 2026-06-30, content hash `a40a0dad`.
