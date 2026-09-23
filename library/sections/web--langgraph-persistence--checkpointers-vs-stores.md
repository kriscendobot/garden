---
title: "LangGraph persistence: checkpointers (short-term) vs stores (long-term)"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/persistence
source_content_sha256: 5b655d1b9a0a354aeac59b382f71f82a068a5edf48584be931967d5b59b7da06
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: LangGraph's persistence layer has two complementary systems. **Checkpointers** persist a thread's graph state as checkpoints (short-term, thread-scoped memory: conversation continuity, human-in-the-loop, time travel, fault tolerance), accessed by passing a `thread_id`. **Stores** persist application-defined key-value data outside the graph state (long-term, cross-thread memory: user preferences, facts, shared knowledge), read and written from nodes or application code. Most applications use both. When LangGraph runs under the managed Agent Server, persistence infrastructure is handled automatically.

## The two systems

Persistence lets a LangGraph application keep useful information beyond a single graph run: continuing a conversation, resuming after an interruption, recovering from a failure, or remembering information across interactions. The two complementary systems:

- **Checkpointers** persist a thread's graph state as checkpoints. Use them for short-term, thread-scoped memory, including conversation continuity, human-in-the-loop workflows, time travel, and fault tolerance.
- **Stores** persist application-defined data outside the graph state. Use them for long-term, cross-thread memory, including user preferences, facts, and shared knowledge.

Most applications use both: a checkpointer tracks the current thread, and a store tracks durable information across threads. Compile a graph with either or both:

```python
graph = builder.compile(checkpointer=checkpointer, store=store)
```

## Checkpointer vs. store

|  | Checkpointer | Store |
|---|---|---|
| Persists | Graph state snapshots | Application-defined key-value data |
| Scope | A single thread | Across threads |
| Memory type | Short-term, thread-scoped | Long-term, cross-thread |
| Use for | Conversation continuity, human-in-the-loop, time travel, fault tolerance | User preferences, facts, shared knowledge |
| Access pattern | Pass a `thread_id` in graph config | Read/write items from nodes or application code |

A subgraph manages its own checkpoint namespace, so data that must cross graph boundaries should use a shared store (or be configured to write to the parent checkpoint). In-memory savers (`MemorySaver`/`InMemorySaver`) lose all checkpoints on process restart; production uses a persistent checkpointer (`PostgresSaver`, `SqliteSaver`).

Source: [Persistence](https://docs.langchain.com/oss/python/langgraph/persistence) retrieved 2026-06-30, content hash `5b655d1b`.
