---
title: "LangGraph control flow: sequences, parallel branches, deferral, conditional branching, and map-reduce (Send)"
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
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The Send API is also summarized at web--langgraph-graph-api--nodes-edges-super-steps-and-command-routing; this is the worked how-to form."
---

Abstract: How to compose the common graph structures in LangGraph. A **sequence** is `add_node` + `add_edge` chains, or the `add_sequence([...])` shorthand (`langgraph>=0.2.46`); splitting an application into sequenced nodes is what lets LangGraph checkpoint between steps, resume interrupts, time-travel, stream, and visualize. **Branches** fan out and fan back in: nodes wired to the same downstream node run concurrently in one super-step (use an accumulating reducer to keep both branches' writes; the super-step is transactional, so an exception in any parallel branch discards all of that step's updates), `max_concurrency` caps the parallelism, and updates from a parallel super-step are not consistently ordered. `defer=True` on a node delays it until all other pending tasks finish (for uneven branch lengths, as in map-reduce). **Conditional branching** (`add_conditional_edges`) picks the next node(s) at runtime from the state, optionally routing to multiple destinations. **Map-reduce** uses the `Send` API: a conditional edge returns `Send("node", per_item_state)` objects to fan a dynamic number of parallel invocations, each with its own state, that fan back in through a reducer.

## Create a sequence of steps

Add nodes and wire them with edges, or use the `add_sequence` shorthand:

```python
builder = StateGraph(State)
builder.add_node(step_1); builder.add_node(step_2); builder.add_node(step_3)
builder.add_edge(START, "step_1")
builder.add_edge("step_1", "step_2")
builder.add_edge("step_2", "step_3")

# shorthand (langgraph >= 0.2.46)
builder = StateGraph(State).add_sequence([step_1, step_2, step_3])
builder.add_edge(START, "step_1")
```

`add_edge` takes node names (for functions, `node.__name__`); you must specify the entry point via an edge from `START`; the graph halts when no nodes remain to execute. Splitting an application into a sequence is what gives LangGraph a place to checkpoint state between nodes, resume human-in-the-loop interrupts, rewind/branch via time travel, stream execution steps, and visualize/debug in Studio.

## Create branches (parallel execution)

Parallelization uses fan-out and fan-in over standard and conditional edges. Fanning out from `a` to `b` and `c` then back in to `d` runs `b` and `c` concurrently in the same super-step; `d` runs after both finish. Use an accumulating reducer so concurrent writes combine instead of clobbering:

```python
class State(TypedDict):
    aggregate: Annotated[list, operator.add]   # append-only across parallel writes
# edges: START->a, a->b, a->c, b->d, c->d, d->END
```

Notes:

- Updates from a parallel super-step **may not be ordered consistently**; for a deterministic order, write outputs to a separate field with an explicit ordering value.
- A super-step is **transactional**: if any parallel branch raises, **none** of that super-step's updates are applied. With a checkpointer, successful nodes within a super-step are saved and not repeated on resume. Handle flaky work with in-node try/except or a `retry_policy` (only failing branches retry).
- Cap parallelism with `max_concurrency` in the run config: `graph.invoke(input, {"configurable": {"max_concurrency": 10}})`.

### Defer node execution

`add_node(d, defer=True)` delays `d` until all other pending tasks are complete — useful when branches have different lengths (a one-step `c` branch vs a two-step `b` → `b_2` branch). With `defer=True`, `d` waits for the entire `b` branch to finish rather than running as soon as its first inbound edge fires.

### Conditional branching

When the fan-out should vary at runtime based on state, use `add_conditional_edges` with a routing function that reads state and returns the next node name(s):

```python
def conditional_edge(state: State) -> Literal["b", "c"]:
    return state["which"]

builder.add_conditional_edges("a", conditional_edge)
```

A routing function may also return a sequence of destinations to route to multiple nodes at once.

## Map-Reduce and the Send API

For map-reduce and advanced branching where the number of branches is not known ahead of time, a conditional edge returns `Send` objects, each naming a node and a distinct per-branch state:

```python
from langgraph.types import Send

def continue_to_jokes(state: OverallState):
    return [Send("generate_joke", {"subject": s}) for s in state["subjects"]]

builder.add_conditional_edges("generate_topics", continue_to_jokes, ["generate_joke"])
```

Here `generate_topics` produces a list of subjects; `continue_to_jokes` fans out one `generate_joke` invocation per subject, each receiving its own `{"subject": ...}` state; the per-branch `jokes` writes fan back in through the `Annotated[list[str], operator.add]` reducer; a downstream `best_joke` node reduces them.

Source: [Use the graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api) at content SHA-256 `e3c9d981`.
