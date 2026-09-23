---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/multi-agent/handoffs
source_content_sha256: e54b80f70a2b1deb30727009e450eaa41bcda7d16065786ca7fe3672370a5a4e
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch (2026-06-30)."
---

LangChain's multi-agent handoffs page: the state-driven control-transfer architecture (a tool updates a `current_step` / `active_agent` state variable that persists across turns, and behavior or routing reads it), its key characteristics and when-to-use, and the two implementation approaches — single agent with `@wrap_model_call` middleware (recommended) versus multiple agent subgraphs handing off via `Command.PARENT`, with the context-engineering discipline (pair the `AIMessage` tool call with an artificial `ToolMessage`) that subgraph handoffs require.

| Section | Topics | Status |
|---------|--------|--------|
| [state-driven control transfer](../sections/web--langchain-handoffs--state-driven-control-transfer.md) | llm-agent-frameworks, patterns, agent-conventions | current |
| [single-agent vs. subgraph approaches](../sections/web--langchain-handoffs--single-agent-vs-subgraph-approaches.md) | llm-agent-frameworks, patterns, agent-conventions | current |
