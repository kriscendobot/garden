---
title: "LangGraph stores: building a custom store (the BaseStore contract)"
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

Abstract: To back the store with a storage engine other than the built-ins (`InMemoryStore` for development; `PostgresStore` / `MongoDBStore` / `RedisStore` for production), subclass `BaseStore` and implement its contract — `BaseStore` is also the type annotation to use in node signatures. Five **async** methods are required (`aput`, `aget`, `adelete`, `asearch`, `alist_namespaces`); their sync counterparts are optional but recommended for sync graph execution. Namespaces are string tuples, and an implementation must support **prefix matching** on search and near-`O(1)` **exact key lookup** on get. Store values are plain JSON-serializable dicts (no custom serializer needed; do not store non-JSON Python objects). Semantic search is optional: accept a `query` argument, embed and rank by cosine similarity when given (adding a `score` to each `Item`), and raise `NotImplementedError` if the backend has no vector search. There is no conformance suite — test against `InMemoryStore` as the reference implementation.

## Base contract

All five async methods are required; sync counterparts (`put`, `get`, `delete`, `search`, `list_namespaces`) are optional but recommended.

| Method | Description |
| --- | --- |
| `aput(namespace, key, value, index=None)` | Store or overwrite a single item |
| `aget(namespace, key)` | Retrieve one item by key; `None` if missing |
| `adelete(namespace, key)` | Delete a single item |
| `asearch(namespace_prefix, *, query=None, filter=None, limit=10, offset=0)` | Search items under a prefix; optionally by semantic query |
| `alist_namespaces(*, prefix=None, suffix=None, max_depth=None, limit=100, offset=0)` | List namespaces matching a prefix/suffix pattern |

Inspect the exact signatures before implementing with `inspect.getsource(BaseStore)`.

## Namespace design

Namespaces are tuples of strings, e.g. `("user_id", "memories")`. An implementation must support **prefix matching** (`asearch(("alice",))` returns items under `("alice",)`, `("alice", "memories")`, and any sub-namespace) and **exact key lookup** (`aget(("alice", "memories"), key)` near O(1)). A common SQL schema:

```sql
CREATE TABLE store_items (
    namespace   TEXT[] NOT NULL,
    key         TEXT NOT NULL,
    value       JSONB NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT now(),
    updated_at  TIMESTAMPTZ DEFAULT now(),
    PRIMARY KEY (namespace, key)
);
CREATE INDEX ON store_items USING gin(namespace);
```

## Serialization

Store values are plain Python dicts — serialize with `json.dumps`/`json.loads` or a JSONB column directly. Do not store raw Python objects that are not JSON-serializable.

## Semantic search support

If the backend supports vector search, implement the `query` parameter on `asearch`: accept `query: str | None`, embed it when present, rank results by cosine similarity, and include a `score` field on each `Item`. If the backend lacks vector search, raise `NotImplementedError` when `query` is passed.

## Testing

There is no conformance suite for custom stores. Test against `InMemoryStore` as the reference — run the same operations against both your store and the reference and assert parity (`put`/`get`, `delete`, prefix `search`).

Source: [LangGraph stores](https://docs.langchain.com/oss/python/langgraph/stores) retrieved 2026-06-30, content hash `a582a187`.
