---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/stores
source_content_sha256: a582a18793f81002d8cd587b82693b1c1801c22dbda24635c59ef6615bbf84a9
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

LangGraph's stores page: the cross-thread long-term-memory store (`BaseStore`), complementing the per-thread checkpointer. The store model (namespaces, keys, `Item`s, put/get/search, prefix matching, pagination, semantic search via an embedding index, and injection into nodes through the `Runtime`); and the contract for building a custom store (the five required async methods, namespace-design requirements, JSON serialization, optional vector-search support, and testing against `InMemoryStore`).

| Section | Topics | Status |
|---------|--------|--------|
| [the BaseStore, namespaces, Items, and semantic search](../sections/web--langgraph-stores--basestore-namespaces-and-semantic-search.md) | llm-agent-frameworks, persistence | current |
| [building a custom store (the BaseStore contract)](../sections/web--langgraph-stores--building-a-custom-store.md) | llm-agent-frameworks, persistence | current |
