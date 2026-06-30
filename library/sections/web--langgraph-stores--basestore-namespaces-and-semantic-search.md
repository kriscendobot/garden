---
title: "LangGraph stores: the BaseStore, namespaces, Items, and semantic search"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/stores
source_content_sha256: a582a18793f81002d8cd587b82693b1c1801c22dbda24635c59ef6615bbf84a9
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: A LangGraph **store** provides cross-thread long-term memory, complementing the per-thread checkpointer. Where a checkpointer saves the full graph state scoped to one thread, a store holds arbitrary key-value data reachable from any thread — user preferences, accumulated knowledge, facts that outlive one conversation. Memories are namespaced by a `tuple` of strings (any length, e.g. `(user_id, "memories")`) and addressed by a `key`; `store.put(namespace, key, value)` saves, `store.get` reads one item, and `store.search` lists or queries a namespace. Each result is an `Item` carrying `value`, `key`, `namespace`, `created_at`, `updated_at`. Search matches the namespace **by prefix**, truncates silently past `limit`, and orders results backend-dependently (Postgres by `updated_at` desc, InMemoryStore by insertion order) — so paginate with `offset` and sort client-side if order matters. Configuring an embedding `index` adds **semantic search**: natural-language queries ranked by vector similarity, with per-field control over what gets embedded. In a graph, the store is injected into any node through the `Runtime` object and works hand-in-hand with the checkpointer.

## Basic usage

```python
from langgraph.store.memory import InMemoryStore
store = InMemoryStore()

namespace = ("1", "memories")          # (user_id, label); namespace need not be user-specific
store.put(namespace, memory_id, {"food_preference": "I like pizza"})
memories = store.search(namespace)     # list of Items, up to `limit` (default 10)
memories[-1].dict()
# {'value': {'food_preference': 'I like pizza'}, 'key': '07e0...', 'namespace': ['1', 'memories'],
#  'created_at': '2024-10-02T17:22:31...', 'updated_at': '2024-10-02T17:22:31...'}
```

An `Item` has: `value` (a dict), `key` (unique within the namespace), `namespace` (a string tuple — may serialize to a JSON list), and `created_at` / `updated_at` timestamps.

## Listing items in a namespace

`store.search(prefix)` (or async `asearch`) with no `query`/`filter` returns items under `prefix`, up to `limit`. Three behaviors to keep in mind:

- **Prefix, not exact, match.** `("alice",)` also returns items under `("alice", "memories")`, `("alice", "preferences")`, etc. Pass the full namespace or filter client-side on `item.namespace` to restrict to one level.
- **Silent truncation past `limit`.** No overflow signal — set `limit` above the expected maximum, or paginate with `offset`.
- **Backend-dependent ordering.** Postgres returns `updated_at` desc; InMemoryStore returns insertion order. Sort client-side on `item.updated_at` if order matters.

`store.list_namespaces(prefix=..., max_depth=...)` discovers which namespaces exist (e.g. to iterate every user).

## Semantic search

Configure the store with an embedding model to find memories by meaning rather than exact match:

```python
store = InMemoryStore(index={
    "embed": init_embeddings("openai:text-embedding-3-small"),
    "dims": 1536,
    "fields": ["food_preference", "$"],   # which fields to embed; "$" = whole document
})
memories = store.search(namespace, query="What does the user like to eat?", limit=3)
```

Per-memory embedding control: pass `index=["food_preference"]` on `put` to embed only that field, or `index=False` to store without embedding (still retrievable, not semantically searchable).

## Using in LangGraph

Compile the graph with both a checkpointer (threads) and a store (cross-thread memory): `builder.compile(checkpointer=checkpointer, store=store)`. Invoke with a `thread_id` and a context carrying the `user_id`. Any node reaches the store through the auto-injected `Runtime`:

```python
async def update_memory(state: MessagesState, runtime: Runtime[Context]):
    namespace = (runtime.context.user_id, "memories")
    await runtime.store.aput(namespace, memory_id, {"memory": memory})

async def call_model(state: MessagesState, runtime: Runtime[Context]):
    namespace = (runtime.context.user_id, "memories")
    memories = await runtime.store.asearch(namespace, query=state["messages"][-1].content, limit=3)
    # ... use memories in the model call
```

A new thread with the same `user_id` still reaches the same memories. In LangSmith Studio / hosted deployments the base store is available by default; semantic search there requires configuring the `index` in `langgraph.json`.

Source: [LangGraph stores](https://docs.langchain.com/oss/python/langgraph/stores) retrieved 2026-06-30, content hash `a582a187`.
