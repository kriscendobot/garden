---
title: "LangGraph state schemas: distinct input/output, private state, and Pydantic models"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-graph-api
source_content_sha256: e3c9d981ebadecf5d6203c251ac917c8d0b4b55f999ff9d533dd9248b463196e
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: Three ways a LangGraph graph's state schema can diverge from the single-shared-schema default. **Distinct input and output schemas** (`input_schema=` / `output_schema=` on `StateGraph`) validate the incoming structure and filter the result to only the declared output keys, while an internal schema still carries inter-node communication. **Private state** is exchanged between specific nodes without entering the graph's public input/output: a node declares an intermediate output type that a downstream node consumes, and a later node that types its input as the overall state never sees it — channels are determined by each node's declared input/output types. **Pydantic models** as `state_schema` add run-time input validation (and optional type coercion), with known limitations: validation runs only on inputs to the first node, the graph output is a plain dict (not a model instance), error traces do not name the failing node, and recursive validation can be slow.

## Define input and output schemas

By default `StateGraph` operates with a single schema and all nodes communicate using it. You can instead define distinct input and output schemas; an internal schema is still used for inter-node communication. The input schema validates that the provided input matches the expected structure; the output schema filters the internal data so only the declared output keys are returned.

```python
from langgraph.graph import StateGraph, START, END
from typing_extensions import TypedDict

class InputState(TypedDict):
    question: str

class OutputState(TypedDict):
    answer: str

class OverallState(InputState, OutputState):
    pass

def answer_node(state: InputState):
    return {"answer": "bye", "question": state["question"]}

builder = StateGraph(OverallState, input_schema=InputState, output_schema=OutputState)
builder.add_node(answer_node)
builder.add_edge(START, "answer_node")
builder.add_edge("answer_node", END)
graph = builder.compile()

print(graph.invoke({"question": "hi"}))   # {'answer': 'bye'}
```

The output of `invoke` includes only the output schema (the extra `question` key set by the node is filtered out).

## Pass private state between nodes

Nodes can exchange information crucial to intermediate logic but irrelevant to the graph's overall input/output, and that should only be shared between certain nodes. A node declares a private output type; the next node declares it as its input; a third node typing its input as the overall public state does **not** see the private data. The wiring is driven entirely by each node's declared input/output types:

```python
class OverallState(TypedDict):
    a: str

class Node1Output(TypedDict):
    private_data: str

def node_1(state: OverallState) -> Node1Output:
    return {"private_data": "set by node_1"}

class Node2Input(TypedDict):
    private_data: str

def node_2(state: Node2Input) -> OverallState:
    return {"a": "set by node_2"}

def node_3(state: OverallState) -> OverallState:   # never sees private_data
    return {"a": "set by node_3"}

builder = StateGraph(OverallState).add_sequence([node_1, node_2, node_3])
builder.add_edge(START, "node_1")
graph = builder.compile()
```

`node_2` receives `{'private_data': 'set by node_1'}`; `node_3` receives only `{'a': ...}`.

## Use Pydantic models for graph state

`StateGraph` accepts a `state_schema` of any type; besides `TypedDict`/`dataclass`, a Pydantic `BaseModel` adds **run-time validation on inputs**:

```python
from pydantic import BaseModel

class OverallState(BaseModel):
    a: str

def node(state: OverallState):
    return {"a": "goodbye"}

builder = StateGraph(OverallState)
builder.add_node(node)
builder.add_edge(START, "node")
builder.add_edge("node", END)
graph = builder.compile()

graph.invoke({"a": 123})   # raises a pydantic ValidationError: `a` must be a string
```

**Known limitations:**

- The graph output is **not** an instance of the Pydantic model (it is a dict).
- Run-time validation occurs **only on inputs to the first node**, not on subsequent nodes or outputs.
- The validation error trace does not show which node the error arises in.
- Pydantic's recursive validation can be slow; for performance-sensitive applications consider a `dataclass`.

Additional behaviors to be aware of: **serialization** — passing a Pydantic instance in, the node receives a validated model, but the graph returns a dict you must re-wrap (`ComplexState(**result)`) to recover the model, including for nested models; **runtime type coercion** — Pydantic coerces compatible inputs (string `"42"` → `int`, `"true"` → `bool`) but raises on incompatible ones; **message models** — use `AnyMessage` (not `BaseMessage`) in a state schema for proper message serialization/deserialization over the wire.

Source: [Use the graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api) at content SHA-256 `e3c9d981`.
