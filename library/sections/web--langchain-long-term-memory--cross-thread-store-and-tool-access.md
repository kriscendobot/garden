---
title: "LangChain long-term memory: the cross-thread store and tool access"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/long-term-memory
source_content_sha256: 94efe4034321c20b52e9bd9ef2d07e85c6e509c2a92d09daea1f5970d5e628db
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: Long-term memory lets an agent store and recall information **across** conversations and sessions, unlike thread-scoped short-term memory. It is built on [LangGraph stores] (see `langgraph-store`), which save data as JSON documents organized by a `namespace` (like a folder — often a user or org ID) and a `key` (like a filename). You enable it by creating a store and passing it to `create_agent(store=...)`; tools then read and write it through the `runtime.store` handle. The namespace/key structure supports hierarchical organization, and cross-namespace search is available through content filters and — when an embedding index is configured — semantic (vector-similarity) queries.

## Usage

Create a store and pass it to the agent. `InMemoryStore` is for development; use a database-backed store (`PostgresStore`, etc.) in production:

```python
from langgraph.store.memory import InMemoryStore
store = InMemoryStore()
agent = create_agent("claude-sonnet-4-6", tools=[], store=store)
```

## Memory storage

Each memory is a JSON document organized under a `namespace` tuple and a distinct `key`. Configure an embedding `index` to enable semantic search:

```python
store = InMemoryStore(index=IndexConfig(embed=embed, dims=2))
namespace = ("my-user", "chitchat")            # (user_id, application_context)
store.put(namespace, "a-memory", {"rules": ["User likes short, direct language"], "my-key": "my-value"})
item = store.get(namespace, "a-memory")
# search within a namespace, filter on content, rank by vector similarity to the query
items = store.search(namespace, filter={"my-key": "my-value"}, query="language preferences")
```

## Read long-term memory in tools

Tools reach the store through `runtime.store` (the same store passed to `create_agent`). The agent must be given the store and a `context_schema` carrying the identifying key (e.g. `user_id`):

```python
@tool
def get_user_info(runtime: ToolRuntime[Context]) -> str:
    """Look up user info."""
    assert runtime.store is not None
    user_info = runtime.store.get(("users",), runtime.context.user_id)
    return str(user_info.value) if user_info else "Unknown user"

agent = create_agent(model="gpt-5.5", tools=[get_user_info], store=store, context_schema=Context)
agent.invoke({"messages": [{"role": "user", "content": "look up user information"}]},
             context=Context(user_id="user_123"))
```

`store.get` returns a value object whose `.value` is the stored dict.

## Write long-term memory from tools

A tool writes durable memory with `runtime.store.put(namespace, key, data)`. This is the pattern for chat applications that persist user-supplied facts:

```python
class UserInfo(TypedDict):
    name: str

@tool
def save_user_info(user_info: UserInfo, runtime: ToolRuntime[Context]) -> str:
    """Save user info."""
    assert runtime.store is not None
    runtime.store.put(("users",), runtime.context.user_id, dict(user_info))
    return "Successfully saved user info."
```

For deeper memory-type theory (semantic, episodic, procedural) and strategies for writing memories, the LangChain docs point to a separate Memory conceptual guide; the storage substrate itself is the LangGraph store.

Source: [LangChain long-term memory](https://docs.langchain.com/oss/python/langchain/long-term-memory) retrieved 2026-06-30, content hash `94efe403`.
