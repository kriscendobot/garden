---
id: langgraph-store
aliases: [LangGraph store, BaseStore, InMemoryStore, PostgresStore, long-term memory, cross-thread memory, store namespace, store.put, store.search, store.get, IndexConfig, semantic search (LangGraph), Item (LangGraph store), runtime.store]
topics: [llm-agent-frameworks, persistence]
---

# langgraph-store

A LangGraph **store** is the long-term, cross-thread persistence mechanism, complementing the per-thread [[langgraph-checkpointer]]. Where a checkpointer saves the full graph state scoped to one `thread_id`, a store holds arbitrary JSON key-value data reachable from **any** thread — user preferences, accumulated knowledge, facts that outlive a single conversation. Memories are organized under a **namespace** (a string `tuple`, like a folder — often a user or org ID) and addressed by a **key** (like a filename); `store.put(namespace, key, value)` saves, `store.get` reads one item, `store.search` lists or queries a namespace, and `store.list_namespaces` enumerates them. Each result is an `Item` carrying `value`, `key`, `namespace`, `created_at`, `updated_at`. Search matches the namespace **by prefix**, silently truncates past `limit` (paginate with `offset`), and orders results backend-dependently. Configuring an embedding **`index`** (`IndexConfig(embed, dims, fields)`) adds **semantic search**: natural-language queries ranked by vector similarity, with per-field control over what gets embedded. The abstract interface is `BaseStore`; built-ins are `InMemoryStore` (development) and database-backed `PostgresStore` / `MongoDBStore` / `RedisStore`; custom backends subclass `BaseStore` and implement five async methods (`aput`/`aget`/`adelete`/`asearch`/`alist_namespaces`). In a graph the store is injected into any node via the `Runtime` object and compiled alongside the checkpointer; LangChain's `create_agent(store=...)` exposes it to tools through `runtime.store`. This is the LangGraph counterpart to a cross-session memory store — distinct from the thread-scoped checkpointer and complementary to it.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [stores: the BaseStore, namespaces, Items, and semantic search](../sections/web--langgraph-stores--basestore-namespaces-and-semantic-search.md) | The store model: namespaces/keys/Items, put/get/search, prefix matching, pagination, semantic search, Runtime injection. |
| [stores: building a custom store](../sections/web--langgraph-stores--building-a-custom-store.md) | The BaseStore contract: five async methods, namespace design, JSON serialization, optional vector search, testing. |
| [long-term memory: the cross-thread store and tool access](../sections/web--langchain-long-term-memory--cross-thread-store-and-tool-access.md) | LangChain's long-term memory built on the store; reading/writing via runtime.store. |
| [persistence: checkpointers vs stores](../sections/web--langgraph-persistence--checkpointers-vs-stores.md) | The short-term checkpointer vs long-term store split. |

## See also

- [[langgraph-checkpointer]] — the complementary short-term, thread-scoped persistence mechanism.
- [[langgraph]] — the orchestration runtime the store serves.
- [[langchain]] — `create_agent(store=...)` exposes the store to tools as long-term memory.
