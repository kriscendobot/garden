---
id: langgraph
aliases: [LangGraph, StateGraph, super-step, super-steps, Pregel, reducer, add_messages, MessagesState, Overwrite, Send, Command, Command.PARENT, time travel, checkpoint, checkpointer, durability mode, interrupt, interrupts, handoff, store, BaseStore, InMemoryStore, Runtime, cross-thread memory, context_schema, RetryPolicy, retry_policy, NodeTimeoutError, TimeoutPolicy, error_handler, NodeError, execution_info, server_info, drain_requested, CachePolicy, node caching, add_sequence, defer, add_conditional_edges, map-reduce, recursion limit, recursion_limit, GraphRecursionError, RemainingSteps, ainvoke, astream, input_schema, output_schema, private state]
topics: [llm-agent-frameworks, persistence, change-propagation]
---

# langgraph

LangGraph is a low-level orchestration framework and runtime for long-running, stateful LLM agents, built by LangChain Inc. and inspired by Google's Pregel. It models an agent workflow as an explicit graph of **nodes** (functions that read the shared State and return updates) and **edges** (which node runs next, fixed or conditional), executed by message passing in discrete **super-steps**. The shared **State** is a schema plus per-channel **reducer** functions that merge node updates (overwrite by default, accumulate when annotated). A **checkpointer** persists per-thread state snapshots at each super-step boundary, enabling **human-in-the-loop** (the `interrupt()` function), memory, fault tolerance, and **time travel** (replay/fork). A complementary **store** ([[langgraph-store]]) holds long-term, cross-thread key-value memory outside the thread-scoped graph state, injected into nodes via the `Runtime`. Control flow uses `Command` (combine a state update with a `goto`) and `Command.PARENT` (route across subgraph boundaries, the basis of multi-agent handoffs). It can be used with or without LangChain.

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
| [interrupts: pause and resume mechanics](../sections/web--langgraph-interrupts--interrupt-and-resume-mechanics.md) | interrupt(), Command(resume=), node restart — the HITL foundation. |
| [handoffs: single-agent vs subgraph approaches](../sections/web--langchain-handoffs--single-agent-vs-subgraph-approaches.md) | Command.PARENT subgraph routing for multi-agent handoffs. |
| [stores: the BaseStore, namespaces, Items, and semantic search](../sections/web--langgraph-stores--basestore-namespaces-and-semantic-search.md) | The cross-thread store model: namespaces/keys/Items, put/get/search, semantic search, Runtime injection. |
| [stores: building a custom store](../sections/web--langgraph-stores--building-a-custom-store.md) | The BaseStore contract: five async methods, namespace design, serialization, vector search, testing. |
| [state: definition, updates, reducers, and Overwrite](../sections/web--langgraph-use-graph-api--state-definition-reducers-and-overwrite.md) | How-to: define/update State, annotate reducers (add_messages/MessagesState), and the Overwrite reducer-bypass escape hatch. |
| [state schemas: input/output, private state, Pydantic](../sections/web--langgraph-use-graph-api--state-schemas-private-state-and-pydantic.md) | How-to: distinct input/output schemas, private inter-node state, and Pydantic state validation with its limitations. |
| [node configuration: runtime, retries, timeouts, errors, caching](../sections/web--langgraph-use-graph-api--node-configuration-retries-timeouts-errors-and-caching.md) | How-to: context_schema/Runtime, RetryPolicy, async timeouts, error_handler, execution_info/server_info/drain, CachePolicy. |
| [control flow: sequences, branches, map-reduce](../sections/web--langgraph-use-graph-api--sequences-branches-and-map-reduce.md) | How-to: add_sequence, parallel fan-out/fan-in (transactional super-steps), defer, conditional edges, Send map-reduce. |
| [loops, recursion limit, and async](../sections/web--langgraph-use-graph-api--loops-recursion-limit-and-async.md) | How-to: termination via conditional edge to END, recursion_limit/GraphRecursionError, RemainingSteps, ainvoke/astream. |
| [Command: routing, subgraph navigation, tool updates, visualization](../sections/web--langgraph-use-graph-api--command-routing-subgraphs-and-visualization.md) | How-to: Command(update,goto), Command.PARENT subgraph routing, state updates from tools, Mermaid/PNG visualization. |

## See also

- [[langchain]] — the agent framework whose `create_agent` agents are built on LangGraph.
- [[langgraph-checkpointer]] — the short-term persistence mechanism, in detail.
- [[langgraph-store]] — the long-term cross-thread store, in detail.
- [[human-in-the-loop]] — the interrupt-driven pause/resume capability LangGraph provides.
- [[multi-agent-handoff]] — control transfer built on `Command.PARENT` and subgraph nodes.
- [[subgraph]] — a compiled `StateGraph` nested as a node; `Command.PARENT` navigation across the boundary.
- [[agent-streaming]] — streaming a graph's execution (`stream_mode`, `stream_events`).
