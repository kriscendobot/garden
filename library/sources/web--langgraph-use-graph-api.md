---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-graph-api
source_content_sha256: e3c9d981ebadecf5d6203c251ac917c8d0b4b55f999ff9d533dd9248b463196e
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 6
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. The how-to companion to the reference page web--langgraph-graph-api: distinct from that overview, this ~96 KB page is the worked walkthrough of state, control flow, node configuration, and Command. Part of the LangChain/LangGraph focused-ingest batch (the LangGraph remainder, 2026-06-30)."
---

LangGraph's Graph API how-to guide: the worked walkthrough that complements the reference overview (`web--langgraph-graph-api`). Covers defining and updating State (reducers, the `Overwrite` escape hatch, distinct input/output schemas, private state, Pydantic models), per-node configuration (runtime context, retry policies, timeouts, error handlers, `Runtime` introspection, caching), composing control flow (sequences, parallel branches, deferral, conditional branching, map-reduce via `Send`), cyclic graphs (loops, the recursion limit, async execution), and the `Command` primitive (combined state-update-and-routing, `Command.PARENT` subgraph navigation, tool state updates) plus graph visualization.

| Section | Topics | Status |
|---------|--------|--------|
| [state: definition, updates, reducers, and Overwrite](../sections/web--langgraph-use-graph-api--state-definition-reducers-and-overwrite.md) | llm-agent-frameworks, change-propagation | current |
| [state schemas: distinct input/output, private state, and Pydantic models](../sections/web--langgraph-use-graph-api--state-schemas-private-state-and-pydantic.md) | llm-agent-frameworks, patterns | current |
| [node configuration: runtime context, retries, timeouts, error handlers, introspection, caching](../sections/web--langgraph-use-graph-api--node-configuration-retries-timeouts-errors-and-caching.md) | llm-agent-frameworks, patterns | current |
| [control flow: sequences, parallel branches, deferral, conditional branching, map-reduce (Send)](../sections/web--langgraph-use-graph-api--sequences-branches-and-map-reduce.md) | llm-agent-frameworks, change-propagation, patterns | current |
| [loops, the recursion limit, and async execution](../sections/web--langgraph-use-graph-api--loops-recursion-limit-and-async.md) | llm-agent-frameworks, change-propagation | current |
| [Command: combined state-update-and-routing, subgraph navigation, tool state updates, and visualization](../sections/web--langgraph-use-graph-api--command-routing-subgraphs-and-visualization.md) | llm-agent-frameworks, change-propagation, patterns | current |
