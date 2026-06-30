---
title: "LangGraph checkpointers: threads, checkpoints, super-step snapshots, fault tolerance"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/checkpointers
source_content_sha256: 8bd026823683f5a976fd7b1e9cbd52f96dac555ff5dac77526426f08d576c36d
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: A **checkpointer** persists a thread's graph state as a sequence of **checkpoints**: snapshots of the full state taken at each super-step boundary, keyed by a `thread_id`. Checkpointers are what make four features possible: human-in-the-loop (inspect/interrupt/approve and resume), memory (follow-up messages on a thread retain prior context), time travel (replay or fork from any past checkpoint), and fault tolerance (restart from the last successful super-step). Within a super-step LangGraph also persists **pending writes** at the node/task level, so when one node fails the already-completed nodes' writes are durable and not re-run on resume. Checkpointers implement the `BaseCheckpointSaver` interface (`.put`/`.put_writes`/`.get_tuple`/`.list`) with in-memory, SQLite, and Postgres backends.

## Why checkpointers

Checkpointers are required for:

- **Human-in-the-loop**: a person can view graph state at any point, and the graph can resume after the person updates the state.
- **Memory** between interactions: follow-up messages on a thread retain memory of previous ones.
- **Time travel**: replay prior executions to review/debug specific steps, and **fork** graph state at arbitrary checkpoints to explore alternative trajectories.
- **Fault tolerance**: if one or more nodes fail at a super-step, restart the graph from the last successful step.
- **Pending writes**: when a node fails mid-super-step, LangGraph stores the pending checkpoint writes from the *other* nodes that completed at that super-step, so on resume the successful nodes are not re-run.

## Threads

A **thread** is a unique ID assigned to each checkpoint a checkpointer saves; it holds the accumulated state of a sequence of runs. When invoking a graph with a checkpointer you **must** supply a `thread_id` in the config:

```python
{"configurable": {"thread_id": "1"}}
```

The checkpointer uses `thread_id` as the primary key for storing and retrieving checkpoints; without it, it cannot save state or resume after an interrupt.

## Checkpoints and super-steps

The state of a thread at a point in time is a **checkpoint**: a snapshot saved at each super-step boundary, represented by a `StateSnapshot`. A super-step is one "tick" where all nodes scheduled for that step execute (possibly in parallel). For `START -> A -> B -> END` there are separate super-steps for the input, node A, and node B, producing a checkpoint after each.

In addition to super-step checkpoints, LangGraph persists writes at the **node (task) level**: as each node finishes, its outputs are written to a `checkpoint_writes` table as task entries linked to the in-progress checkpoint. These per-task writes are what enable pending-writes recovery; the full state snapshot is committed once the super-step completes. Time travel resumes only from full checkpoints at super-step boundaries (not from individual task writes).

Each checkpoint carries a `checkpoint_ns` (namespace): `""` for the root graph, `"node_name:uuid"` for a subgraph (nested namespaces joined with `|`). State is read with `graph.get_state(config)` (latest, or a specific `checkpoint_id`) and the full history with `graph.get_state_history(config)`.

## Interface and backends

Checkpointers conform to `BaseCheckpointSaver`: `.put` (store a checkpoint with config + metadata), `.put_writes` (store intermediate/pending writes), `.get_tuple` (fetch a checkpoint for a config, used by `get_state`), and `.list` (used by `get_state_history`); async variants exist (`.aput`, etc.). Provided implementations: `langgraph-checkpoint` (base + `InMemorySaver`), `langgraph-checkpoint-sqlite` (`SqliteSaver`, local file, dev), `langgraph-checkpoint-postgres` (`PostgresSaver`, production, used by LangSmith), and Azure Cosmos DB. Serialization defaults to `JsonPlusSerializer` (ormsgpack + JSON) with an optional `pickle_fallback`.

Source: [Checkpointers](https://docs.langchain.com/oss/python/langgraph/checkpointers) retrieved 2026-06-30, content hash `8bd02682`.
