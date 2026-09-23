---
id: subgraph
aliases: [subgraph, subgraphs, Command.PARENT, parent graph, nested graph, compiled subgraph]
topics: [llm-agent-frameworks, change-propagation, patterns]
---

# subgraph

A **subgraph** in LangGraph is a compiled `StateGraph` added as a node inside a parent graph (`builder.add_node("subgraph", compiled_subgraph)`), letting a graph be composed of nested graphs. A node *inside* a subgraph can route to a node in the parent graph by returning `Command(goto=..., graph=Command.PARENT)` — navigation targets the **closest** enclosing parent — which is the mechanism behind LangGraph multi-agent handoffs (each agent is a subgraph; control transfers across the boundary). When a subgraph node updates a state key that is shared by both the parent and subgraph state schemas, the parent **must** define a reducer for that key so the cross-boundary write merges correctly. LangGraph's dedicated `use-subgraphs` how-to page (a separate source, not yet ingested) covers shared-state vs different-state subgraph composition in full; the references below capture the `Command.PARENT` navigation mechanics and the handoff pattern built on it.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Command: routing, subgraph navigation, tool state updates, and visualization](../sections/web--langgraph-use-graph-api--command-routing-subgraphs-and-visualization.md) | `Command.PARENT` routes from a subgraph node to a parent-graph node; shared keys updated across the boundary need a parent-side reducer. |
| [handoffs: single-agent vs subgraph approaches](../sections/web--langchain-handoffs--single-agent-vs-subgraph-approaches.md) | Multiple agents as subgraphs handing off via `Command.PARENT`; context engineering for a valid handoff history. |

## See also

- [[langgraph]] — the orchestration runtime; subgraphs are compiled `StateGraph`s nested as nodes.
- [[multi-agent-handoff]] — control transfer across agents, built on `Command.PARENT` subgraph routing.
- [[human-in-the-loop]] — `interrupt()` inside a subgraph resumes the subgraph node from its start.
