---
title: "LangGraph durability modes, replay, update_state and time travel"
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

Abstract: LangGraph exposes three **durability modes** that trade write latency against crash safety: `"exit"` (persist only when execution exits; best performance, no mid-run crash recovery), `"async"` (persist asynchronously while the next step runs; good performance, small crash-loss risk), and `"sync"` (persist synchronously before each step; highest durability, some overhead). On top of the checkpoint history, **time travel** lets an application replay (re-execute steps from a prior checkpoint, skipping earlier nodes whose results are saved but re-running later nodes including LLM calls and interrupts) and **update_state** (write a new checkpoint with edited values, treated like a node update and passed through reducers). `DeltaChannel` (beta) stores incremental deltas instead of full channel values to bound checkpoint storage growth.

## Durability modes

Specify the durability mode on any execution method, e.g. `graph.stream(input, durability="sync")`. From least to most durable:

- `"exit"`: persists changes only when graph execution exits (successfully, with an error, or at a human-in-the-loop interrupt). Best performance for long-running graphs, but intermediate state is not saved, so you cannot recover from a process crash mid-execution.
- `"async"`: persists changes asynchronously while the next step executes. Good performance and durability, with a small risk that a checkpoint is not written if the process crashes during execution.
- `"sync"`: persists changes synchronously before the next step starts. Every checkpoint is written before continuing, providing high durability at some performance cost.

## Replay and update_state

- **Replay** re-executes steps from a prior checkpoint: invoke the graph with a prior `checkpoint_id` and nodes before that checkpoint are skipped (results already saved) while nodes after it re-execute, including any LLM calls, API requests, or interrupts (which are always re-triggered during replay).
- **update_state** edits the graph state via `graph.update_state(...)`, creating a *new* checkpoint with the updated values rather than modifying the original. The update is treated like a node update: values pass through reducers, so channels with reducers accumulate rather than overwrite. An optional `as_node` controls which node the update is attributed to (and so which node runs next).

These together are "time travel": replay past executions to review or debug, and fork the state at arbitrary checkpoints to explore alternative trajectories.

## Storage optimization

By default checkpoints write the full value of every state channel at each super-step, so long-running threads with large accumulations (multi-turn conversations) grow storage over time. `DeltaChannel` (requires `langgraph>=1.2`, beta) stores only incremental deltas instead of the full accumulated value, substantially reducing checkpoint size for append-heavy channels, with a storage-vs-latency tradeoff. Other mitigations named: prune old checkpoints or set a retention policy; keep `thread_id` values bounded (under 255 chars for `PostgresSaver`).

Source: [Checkpointers](https://docs.langchain.com/oss/python/langgraph/checkpointers) retrieved 2026-06-30, content hash `8bd02682`.
