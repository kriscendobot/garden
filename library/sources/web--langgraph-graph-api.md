---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/graph-api
source_content_sha256: 6d76668987a81930350d4f31e53d2b44bde9e26c94897b0107c8dc7dff4ed783
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. Part of the LangChain/LangGraph focused-ingest batch (2026-06-30). Remainder (subgraphs, runtime context, recursion limit, node caching, graph migrations) deferred to follow-on scholar-ingest job."
---

LangGraph's Graph API: the StateGraph programming model. Covers the shared State (schema + per-channel reducers, the messages channel) and the execution model (nodes, edges, Pregel super-steps, the `Send` fan-out and `Command` routing primitives).

| Section | Topics | Status |
|---------|--------|--------|
| [state schema and reducers](../sections/web--langgraph-graph-api--state-schema-and-reducers.md) | llm-agent-frameworks, change-propagation | current |
| [nodes, edges, super-steps, Send and Command routing](../sections/web--langgraph-graph-api--nodes-edges-super-steps-and-command-routing.md) | llm-agent-frameworks, change-propagation | current |
