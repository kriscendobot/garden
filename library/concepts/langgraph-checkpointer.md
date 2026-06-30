---
id: langgraph-checkpointer
aliases: [checkpointer, checkpoint, BaseCheckpointSaver, PostgresSaver, SqliteSaver, InMemorySaver, MemorySaver, thread_id, StateSnapshot, pending writes, durability mode, DeltaChannel, store, long-term memory, interrupt]
topics: [llm-agent-frameworks, persistence]
---

# langgraph-checkpointer

A LangGraph **checkpointer** is the short-term persistence mechanism: it saves a thread's graph state as **checkpoints** (full `StateSnapshot` values) at each super-step boundary, keyed by a `thread_id`. Checkpoints enable human-in-the-loop (inspect/interrupt/resume), conversation memory, fault tolerance, and time travel (replay and forking). Within a super-step, node-level **pending writes** are persisted so a partial failure does not re-run already-completed nodes. Three **durability modes** (exit/async/sync) trade write latency for crash safety. Checkpointers implement `BaseCheckpointSaver` (memory, SQLite, Postgres, Cosmos DB backends). A complementary **store** holds long-term, cross-thread key-value memory outside the graph state. The checkpointer is precisely what makes `interrupt()` work: it writes the exact graph state at the pause so the run can wait indefinitely and resume on the same `thread_id`. This is the LangGraph feature most directly comparable to Endo daemon persistence and to the garden's git-journal durable ledger.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [threads, checkpoints, fault tolerance](../sections/web--langgraph-checkpointers--threads-checkpoints-and-fault-tolerance.md) | Threads, super-step checkpoints, pending writes, the saver interface and backends. |
| [durability modes and time travel](../sections/web--langgraph-checkpointers--durability-modes-and-time-travel.md) | exit/async/sync durability, replay, update_state, DeltaChannel. |
| [checkpointers vs stores](../sections/web--langgraph-persistence--checkpointers-vs-stores.md) | The short-term checkpointer vs long-term store split. |
| [interrupts: pause and resume mechanics](../sections/web--langgraph-interrupts--interrupt-and-resume-mechanics.md) | How interrupt() relies on the checkpointer + thread_id to pause and resume. |
| [tools: accessing context via ToolRuntime](../sections/web--langchain-tools--accessing-context-via-toolruntime.md) | runtime.store as the long-term cross-conversation memory facet. |

## See also

- [[langgraph]] — the orchestration runtime the checkpointer serves.
- [[human-in-the-loop]] — the interrupt mechanism the checkpointer underpins.
- [[crdt-in-formula-persistence]] — Endo-side durable-state design, for contrast.
