---
id: langgraph
aliases: [LangGraph, StateGraph, super-step, super-steps, Pregel, reducer, add_messages, MessagesState, Send, Command, time travel, checkpoint, checkpointer, durability mode]
topics: [llm-agent-frameworks, persistence, change-propagation]
---

# langgraph

LangGraph is a low-level orchestration framework and runtime for long-running, stateful LLM agents, built by LangChain Inc. and inspired by Google's Pregel. It models an agent workflow as an explicit graph of **nodes** (functions that read the shared State and return updates) and **edges** (which node runs next, fixed or conditional), executed by message passing in discrete **super-steps**. The shared **State** is a schema plus per-channel **reducer** functions that merge node updates (overwrite by default, accumulate when annotated). A **checkpointer** persists per-thread state snapshots at each super-step boundary, enabling human-in-the-loop, memory, fault tolerance, and **time travel** (replay/fork). It can be used with or without LangChain.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [orchestration runtime and product split](../sections/web--langgraph-overview--orchestration-runtime-and-product-split.md) | What LangGraph is and where it sits among Deep Agents / LangChain / LangSmith. |
| [state schema and reducers](../sections/web--langgraph-graph-api--state-schema-and-reducers.md) | The shared State, schema variants, and per-channel reducers. |
| [nodes, edges, super-steps, Send and Command routing](../sections/web--langgraph-graph-api--nodes-edges-super-steps-and-command-routing.md) | The execution model: Pregel super-steps, Send fan-out, Command routing. |
| [threads, checkpoints, fault tolerance](../sections/web--langgraph-checkpointers--threads-checkpoints-and-fault-tolerance.md) | Threads, super-step checkpoints, pending-writes fault tolerance, the saver interface. |
| [durability modes and time travel](../sections/web--langgraph-checkpointers--durability-modes-and-time-travel.md) | exit/async/sync durability, replay, update_state, time travel. |
| [checkpointers vs stores](../sections/web--langgraph-persistence--checkpointers-vs-stores.md) | Short-term checkpointers vs long-term cross-thread stores. |
| [workflow and agent patterns](../sections/web--langgraph-workflows-and-agents--workflow-and-agent-patterns.md) | Workflow vs agent patterns built on LangGraph. |

## See also

- [[langchain]] — the agent framework whose `create_agent` agents are built on LangGraph.
- [[langgraph-checkpointer]] — the persistence mechanism, in detail.
