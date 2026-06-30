---
title: "LangGraph nodes, edges, super-steps, Send and Command routing"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/graph-api
source_content_sha256: 6d76668987a81930350d4f31e53d2b44bde9e26c94897b0107c8dc7dff4ed783
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, change-propagation]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: LangGraph models an agent workflow as an explicit graph of three components: **nodes** (functions that read state and return updates: an LLM or plain code), **edges** (which node runs next, fixed or conditional), and a **State** the edges evolve. Execution proceeds by Pregel-style message passing in discrete **super-steps**: nodes that run in parallel share a super-step, sequential nodes occupy separate super-steps, and the graph halts when no node has an inbound message. Routing comes in fixed (`add_edge`) and conditional (`add_conditional_edges`) forms; `Send` fans out a dynamic number of parallel node invocations (map-reduce); and `Command` combines a state update with control flow (`goto`, `resume`, cross-graph navigation) in a single return value.

## Graphs and super-steps

LangGraph models workflows as graphs with three components: `State` (the shared snapshot), `Nodes` (functions encoding agent logic; they receive state, compute or perform side effects, and return updated state), and `Edges` (functions choosing the next node: conditional branches or fixed transitions). "Nodes do the work, edges tell what to do next." Nodes and edges are just functions, an LLM or plain code.

The underlying algorithm uses **message passing** inspired by Google's Pregel. When a node completes it sends messages along its edges; recipient nodes execute and pass results onward. The program proceeds in discrete **super-steps**. A super-step is one iteration over the graph: nodes running in parallel are in the same super-step, sequential nodes in separate ones. All nodes start `inactive`; a node becomes `active` when it receives a message on an incoming edge (channel), runs, and responds with updates. At the end of each super-step, nodes with no inbound messages vote to halt. Execution terminates when all nodes are inactive and no messages are in transit. You must `.compile()` a graph (basic structural checks; also where checkpointers and breakpoints are set) before using it.

## Edges

- **Normal edges** (`add_edge("a", "b")`): always go from A to B.
- **Conditional edges** (`add_conditional_edges("a", routing_fn[, mapping])`): a routing function reads state and returns the next node name(s), optionally via a mapping dict.
- **Entry point**: an edge from the virtual `START` node; a **conditional entry point** uses a routing function from `START`.

A node may have multiple outgoing edges; all destinations execute in parallel in the next super-step. For any single node, pick one routing mechanism (static edges *or* dynamic routing): mixing them runs both paths.

## `Send`: dynamic fan-out (map-reduce)

When the number of branches is not known ahead of time, a conditional edge can return `Send` objects, each naming a node and a distinct per-branch state. This supports map-reduce: a first node generates a list, and a downstream node is applied to each item with its own input state.

```python
from langgraph.types import Send

def continue_to_jokes(state):
    return [Send("generate_joke", {"subject": s}) for s in state['subjects']]
```

## `Command`: state update plus control flow

`Command` is a versatile primitive accepting `update` (state updates), `goto` (navigate to nodes), `graph` (target a parent graph from a subgraph via `Command.PARENT`), and `resume` (provide a value to resume after an `interrupt`). It is used in three contexts: returned from nodes (combine update and routing), as input to `invoke`/`stream` (resume after an interrupt), and returned from tools. Use `Command` when you need to **both** update state and route; use a conditional edge when you only need to route. `Command` only adds dynamic edges; any static edges from the same node still execute. Cross-graph `Command.PARENT` navigation underpins multi-agent handoffs (and requires a reducer on any shared key written from subgraph to parent).

Source: [Graph API overview](https://docs.langchain.com/oss/python/langgraph/graph-api) retrieved 2026-06-30, content hash `6d766689`.
