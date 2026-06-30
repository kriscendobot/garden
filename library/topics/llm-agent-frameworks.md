# Topic: llm-agent-frameworks

> Abstract: External, general-purpose frameworks for building LLM applications and agents, ingested as cross-cutting reference so the garden and Endo harness designs can be compared against the dominant industry approach. The canonical examples are **LangChain** (the agent framework: a `create_agent` harness, a standard cross-provider model interface, tool calling, retrieval/RAG, memory) and **LangGraph** (the low-level orchestration runtime: an explicit graph of nodes/edges over a shared reducer-merged State, executed in Pregel super-steps, with checkpointer-based persistence, durability modes, time travel, and human-in-the-loop). Distinct from `agent-conventions` (per-repository agent operating notes) and from the garden's own `roles`/job-board model: this topic captures the *external* framework vocabulary the garden borrows from or contrasts with.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [web--langchain-overview--create-agent-harness-and-standard-interfaces](../sections/web--langchain-overview--create-agent-harness-and-standard-interfaces.md) | LangChain overview | LangChain frames an agent as model + harness; `create_agent` is a minimal configurable harness with a standard cross-provider model interface and a composable middleware layer. |
| [web--langchain-retrieval--retrieval-rag-pipeline-and-architectures](../sections/web--langchain-retrieval--retrieval-rag-pipeline-and-architectures.md) | LangChain retrieval | Retrieval/RAG as a modular pipeline (loaders, splitters, embeddings, vector stores, retrievers) and three architectures (2-Step, Agentic, Hybrid) on a control-vs-flexibility axis. |
| [web--langgraph-overview--orchestration-runtime-and-product-split](../sections/web--langgraph-overview--orchestration-runtime-and-product-split.md) | LangGraph overview | LangGraph is a low-level orchestration runtime for long-running stateful agents (persistence, human-in-the-loop, memory); Pregel/Beam/NetworkX lineage; sits below Deep Agents and LangChain. |
| [web--langgraph-graph-api--state-schema-and-reducers](../sections/web--langgraph-graph-api--state-schema-and-reducers.md) | LangGraph Graph API | A graph's State is a schema plus per-channel reducers that merge node updates; the default reducer overwrites, annotated reducers accumulate; `add_messages`/`MessagesState` reconcile by message ID. |
| [web--langgraph-graph-api--nodes-edges-super-steps-and-command-routing](../sections/web--langgraph-graph-api--nodes-edges-super-steps-and-command-routing.md) | LangGraph Graph API | Nodes do the work, edges route; execution is Pregel message-passing in discrete super-steps; `Send` fans out dynamic parallel branches, `Command` combines a state update with control flow. |
| [web--langgraph-checkpointers--threads-checkpoints-and-fault-tolerance](../sections/web--langgraph-checkpointers--threads-checkpoints-and-fault-tolerance.md) | LangGraph checkpointers | A checkpointer persists per-thread state snapshots at super-step boundaries; pending node-level writes give mid-super-step fault tolerance; the `BaseCheckpointSaver` interface has memory/SQLite/Postgres backends. |
| [web--langgraph-checkpointers--durability-modes-and-time-travel](../sections/web--langgraph-checkpointers--durability-modes-and-time-travel.md) | LangGraph checkpointers | Three durability modes (exit/async/sync) trade latency for crash safety; replay re-runs from a prior checkpoint, update_state forks an edited checkpoint through reducers; DeltaChannel bounds storage. |
| [web--langgraph-persistence--checkpointers-vs-stores](../sections/web--langgraph-persistence--checkpointers-vs-stores.md) | LangGraph persistence | Two complementary systems: checkpointers (short-term, thread-scoped graph-state snapshots) and stores (long-term, cross-thread application key-value memory). |
| [web--langgraph-workflows-and-agents--workflow-and-agent-patterns](../sections/web--langgraph-workflows-and-agents--workflow-and-agent-patterns.md) | LangGraph workflows and agents | Workflows (fixed paths) vs agents (dynamic tool loops) over an "augmented LLM"; patterns: prompt chaining, parallelization, routing, orchestrator-worker, evaluator-optimizer. |

## See also

- `persistence` — Endo's daemon persistence and durable state, the closest in-corpus analogue to LangGraph's checkpointing.
- `change-propagation` — reactive/dataflow propagation, comparable to LangGraph's reducer-merged state channels and super-step message passing.
- `patterns` — Endo `@endo/patterns` shape matching (distinct sense of "pattern" from the workflow patterns here).
- `agent-conventions` — per-repository agent operating notes (the in-repo sense of "agent").
- `async-flow` — agoric-sdk's durable, resumable async execution, an in-corpus durable-execution analogue.
