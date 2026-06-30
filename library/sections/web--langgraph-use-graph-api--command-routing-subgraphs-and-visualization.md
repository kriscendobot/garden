---
title: "LangGraph Command: combined state-update-and-routing, subgraph navigation, tool state updates, and graph visualization"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-graph-api
source_content_sha256: e3c9d981ebadecf5d6203c251ac917c8d0b4b55f999ff9d533dd9248b463196e
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, change-propagation, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. Subgraph navigation here is the Command.PARENT mechanics; the dedicated use-subgraphs page is a separate source."
---

Abstract: The `Command` primitive and how it unifies state updates with control flow in a single node return, plus graph visualization. Returning `Command(update={...}, goto="node")` from a node both updates state and routes — a replacement for a separate conditional edge — and requires a `Command[Literal[...]]` return annotation so the graph can render the possible destinations (with `Command`, the graph needs no explicit edges between those nodes). `graph=Command.PARENT` routes from a subgraph node to a node in the (closest) parent graph, the basis of multi-agent handoffs; a key shared between parent and subgraph state and updated across the boundary **must** have a reducer defined in the parent. Returning `Command(update=...)` from a **tool** updates graph state from inside the tool (the update must include a `ToolMessage` in `messages` for a valid history); the prebuilt `ToolNode` propagates such tool `Command`s automatically. Visualization renders any graph to **Mermaid** syntax (`draw_mermaid()`) or a **PNG** (`draw_mermaid_png()` via Mermaid.Ink, Pyppeteer, or Graphviz).

## Combine control flow and state updates with `Command`

To both update state and decide the next node in the *same* node, return a `Command`:

```python
def my_node(state: State) -> Command[Literal["my_other_node"]]:
    return Command(update={"foo": "bar"}, goto="my_other_node")
```

A worked example replaces a conditional edge entirely: `node_a` returns `Command(update={"foo": value}, goto=goto)` choosing `node_b` or `node_c` at random, and the graph is built with **no edges** between A, B, and C — control flow lives in the `Command`. The `Command[Literal["node_b", "node_c"]]` return annotation is required: it tells LangGraph (and the renderer) which nodes `node_a` can navigate to.

## Navigate to a node in a parent graph

With subgraphs, a node inside a subgraph can navigate to a node in the parent graph by setting `graph=Command.PARENT`:

```python
def my_node(state: State) -> Command[Literal["my_other_node"]]:
    return Command(update={"foo": "bar"}, goto="other_subgraph", graph=Command.PARENT)
```

`goto` then names a node in the parent graph (navigation targets the **closest** parent relative to the subgraph). A subgraph node is added to the parent as a compiled subgraph (`builder.add_node("subgraph", subgraph)`), and the subgraph's `node_a` routes out to the parent's `node_b`/`node_c`. **State updates with `Command.PARENT`:** when a subgraph node sends an update for a key shared by both parent and subgraph state schemas, you **must** define a reducer for that key in the parent state; the reducer then merges the cross-boundary write (no manual appending needed).

## Use Command inside tools

A common pattern updates graph state from inside a tool (e.g. look up customer info at conversation start). Return `Command(update={...})` from the tool:

```python
from langchain.tools import ToolRuntime

@tool
def lookup_user_info(runtime: ToolRuntime):
    """Use this to look up user information."""
    user_info = get_user_info(runtime.server_info.user.identity)
    return Command(update={
        "user_info": user_info,
        "messages": [ToolMessage("Successfully looked up user information", tool_call_id=runtime.tool_call_id)],
    })
```

You **must** include `messages` (or the relevant message-history key) in `Command.update` when returning `Command` from a tool, and that list **must** contain a `ToolMessage` — LLM providers require an AI message with tool calls to be followed by tool-result messages. For tools that return `Command`, use the prebuilt `ToolNode`, which handles and propagates them to graph state automatically; a custom tool-calling node must propagate the `Command` updates itself.

## Visualize your graph

Any `Graph` (including `StateGraph`) can be visualized. Convert to **Mermaid** syntax with `app.get_graph().draw_mermaid()`, or render a **PNG** with `app.get_graph().draw_mermaid_png()` using one of three methods:

- **Mermaid.Ink** API (default; no extra packages).
- **Mermaid + Pyppeteer** (`pip install pyppeteer`; allows curve style, node colors, label wrapping, etc.).
- **Graphviz** (`app.get_graph().draw_png()`; requires pygraphviz).

Source: [Use the graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api) at content SHA-256 `e3c9d981`.
