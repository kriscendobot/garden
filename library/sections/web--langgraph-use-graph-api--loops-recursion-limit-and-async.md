---
title: "LangGraph loops, the recursion limit, and async execution"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-graph-api
source_content_sha256: e3c9d981ebadecf5d6203c251ac917c8d0b4b55f999ff9d533dd9248b463196e
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, change-propagation]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: How to build cyclic graphs in LangGraph and run them asynchronously. A **loop** needs a termination mechanism: typically a conditional edge that routes to `END` once a condition holds (e.g. an accumulator passes a threshold), making the ReAct shape of a tool-calling model node alternating with a tools node. The **recursion limit** (`{"recursion_limit": N}` in the run config) bounds the number of super-steps and raises `GraphRecursionError` if exceeded — a safety net for loops without a guaranteed termination; the limit counts super-steps, so a four-node-per-lap loop completes one lap per four of the limit. The `RemainingSteps` managed-value annotation lets a node read how many steps remain and end gracefully instead of erroring. **Async** execution improves IO-bound throughput: convert nodes to `async def`, `await` inside them, and invoke with `.ainvoke`/`.astream`; because LangChain objects implement the Runnable protocol with async variants, upgrading a sync graph is usually quick.

## Create and control loops

A graph with a loop needs a way to terminate, most commonly a conditional edge routing to `END` once a termination condition holds:

```python
def route(state: State) -> Literal["b", END]:
    if len(state["aggregate"]) < 7:
        return "b"
    else:
        return END

builder.add_edge(START, "a")
builder.add_conditional_edges("a", route)
builder.add_edge("b", "a")
```

Invoking alternates `a` and `b` until the accumulator passes the threshold. This architecture mirrors a ReAct agent where node `a` is a tool-calling model and node `b` is the tools.

## Impose a recursion limit

When termination is not guaranteed, set the recursion limit in the run config; it bounds the number of super-steps and raises `GraphRecursionError`, which you can catch:

```python
from langgraph.errors import GraphRecursionError

try:
    graph.invoke(inputs, {"recursion_limit": 3})
except GraphRecursionError:
    print("Recursion Error")
```

The limit counts **super-steps**, not nodes: a loop whose lap is four super-steps (A; B; C and D concurrent; back to A) completes one lap per four units of the limit.

To return the last state instead of raising, use the `RemainingSteps` managed-value annotation — a `ManagedValue` channel that exists only for the duration of the run and tracks steps remaining. A node reads it to decide whether to end:

```python
from langgraph.managed.is_last_step import RemainingSteps

class State(TypedDict):
    aggregate: Annotated[list, operator.add]
    remaining_steps: RemainingSteps

def route(state: State) -> Literal["b", END]:
    if state["remaining_steps"] <= 2:
        return END
    return "b"
```

## Async

The async paradigm gives significant performance improvements for IO-bound work run concurrently (e.g. concurrent chat-model API requests). To convert a sync graph to async:

1. Make nodes `async def` instead of `def`.
2. Use `await` appropriately inside them.
3. Invoke with `.ainvoke` or `.astream`.

Because many LangChain objects implement the Runnable protocol — which provides async variants of all sync methods — upgrading a sync graph to async is typically quick. A node becomes, e.g.:

```python
async def call_model(state, runtime):
    response = await model.ainvoke(state["messages"])
    return {"messages": [response]}
```

Source: [Use the graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api) at content SHA-256 `e3c9d981`.
