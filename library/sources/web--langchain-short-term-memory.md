---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/short-term-memory
source_content_sha256: a874692dcd9ad3be3705bb19a22e0a13a3ec816fb23ae61930a2cbf3aded5529
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

LangChain's short-term-memory page: thread-scoped conversation memory. Enabling it by passing a `checkpointer` to `create_agent` and resuming by `thread_id`, customizing the `AgentState` schema, production database backends; and the context-window management patterns (trim, delete, summarize) plus the four places agent state is read and written (tools via `ToolRuntime`, dynamic prompt, `@before_model` / `@after_model` middleware).

| Section | Topics | Status |
|---------|--------|--------|
| [thread persistence via the checkpointer](../sections/web--langchain-short-term-memory--checkpointer-thread-persistence.md) | llm-agent-frameworks, persistence, agent-conventions | current |
| [context-window management and state access](../sections/web--langchain-short-term-memory--context-management-and-state-access.md) | llm-agent-frameworks, patterns, agent-conventions | current |
