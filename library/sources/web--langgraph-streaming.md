---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/streaming
source_content_sha256: 9f6b826e6bf833ba01d39b329ca0a2d3c2b02fb5192d1b30285f571589cac698
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 4
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. The LangGraph-runtime stream-mode API; its sections file under the existing agent-streaming concept (shared with the LangChain-agent streaming page web--langchain-streaming) because both share the same symbols (stream_mode, get_stream_writer, v2 StreamPart). The newer typed-projection event-streaming API (v3, stream_events), recommended for new apps, lives on a separate page (deferred). Part of the LangChain/LangGraph focused-ingest batch (the LangGraph remainder, 2026-06-30)."
---

LangGraph's streaming how-to guide: the `stream` / `astream` stream-mode API for surfacing real-time graph-execution events. Covers basic usage and the unified **v2 `StreamPart` format** (`{type, ns, data}`, per-mode TypedDicts, type narrowing, the v1-vs-v2 shape difference), the seven stream modes (`values`, `updates`, `messages`, `custom`, `checkpoints`, `tasks`, `debug`) including graph-state streaming, token-by-token LLM streaming with tag/node/`nostream` filtering, custom `get_stream_writer` data from nodes and tools, subgraph streaming via `subgraphs=True` and the `ns` namespace, the checkpointer-requiring runtime-event modes, and advanced topics (streaming any non-LangChain LLM through custom mode, disabling per-model streaming, the v1→v2 migration with `GraphOutput`, and the Python < 3.11 async caveats).

| Section | Topics | Status |
|---------|--------|--------|
| [stream modes and the v2 StreamPart format](../sections/web--langgraph-streaming--stream-modes-and-v2-streampart-format.md) | llm-agent-frameworks, agent-conventions, patterns | current |
| [graph state (values/updates) and LLM token (messages) modes](../sections/web--langgraph-streaming--graph-state-and-llm-token-streaming.md) | llm-agent-frameworks, change-propagation | current |
| [custom, subgraph, checkpoint, task, and debug modes](../sections/web--langgraph-streaming--custom-subgraph-checkpoint-task-and-debug.md) | llm-agent-frameworks, patterns | current |
| [any-LLM custom streaming, disabling streaming, and v1→v2 migration](../sections/web--langgraph-streaming--advanced-any-llm-disable-and-v2-migration.md) | llm-agent-frameworks, patterns | current |
