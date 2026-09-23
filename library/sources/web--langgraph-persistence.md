---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/persistence
source_content_sha256: 5b655d1b9a0a354aeac59b382f71f82a068a5edf48584be931967d5b59b7da06
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. Part of the LangChain/LangGraph focused-ingest batch (2026-06-30). The stores deep-dive deferred to follow-on scholar-ingest job."
---

LangGraph's persistence overview: the two complementary systems, checkpointers (short-term, thread-scoped graph-state snapshots) and stores (long-term, cross-thread application key-value data), and when to use each.

| Section | Topics | Status |
|---------|--------|--------|
| [checkpointers vs stores](../sections/web--langgraph-persistence--checkpointers-vs-stores.md) | llm-agent-frameworks, persistence | current |
