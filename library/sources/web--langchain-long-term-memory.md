---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/long-term-memory
source_content_sha256: 94efe4034321c20b52e9bd9ef2d07e85c6e509c2a92d09daea1f5970d5e628db
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Page is largely one topic repeated per provider; ingested as one section. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

LangChain's long-term-memory page: cross-conversation memory built on LangGraph stores. JSON documents organized by `namespace` and `key`, enabling it via `create_agent(store=...)`, the put/get/search storage model with an optional embedding index for semantic search, and reading and writing the store from tools through the `runtime.store` handle.

| Section | Topics | Status |
|---------|--------|--------|
| [the cross-thread store and tool access](../sections/web--langchain-long-term-memory--cross-thread-store-and-tool-access.md) | llm-agent-frameworks, persistence, agent-conventions | current |
