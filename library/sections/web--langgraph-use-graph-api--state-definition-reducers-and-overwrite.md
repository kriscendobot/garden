---
title: "LangGraph state: definition, updates, reducers, and Overwrite"
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
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The how-to companion to the reference page web--langgraph-graph-api (state-schema-and-reducers); this page adds the Overwrite escape hatch and worked update examples."
---

Abstract: The how-to mechanics of defining and updating a LangGraph graph's State. State can be a `TypedDict`, Pydantic model, or dataclass; a node is a plain Python function whose first argument is the state and that returns updates (never mutating state in place). Each state key has its own **reducer** — absent one, an update overwrites the key; annotating a field with a reducer function (e.g. `operator.add`, or the built-in `add_messages` / prebuilt `MessagesState`) makes updates merge rather than replace. The `Overwrite` wrapper is the escape hatch: returning `Overwrite(value)` (or the JSON `{"__overwrite__": value}`) bypasses a key's reducer and sets the channel directly, for resetting accumulated state — but only one node may overwrite a given key per super-step or an `InvalidUpdateError` is raised.

## Define state

State in LangGraph can be a `TypedDict`, `Pydantic` model, or dataclass. By default a graph's input and output schema are the same and are determined by the state (see the schemas section for distinct input/output schemas). A common formulation for LLM applications tracks a list of messages plus extra fields:

```python
from langchain.messages import AnyMessage
from typing_extensions import TypedDict

class State(TypedDict):
    messages: list[AnyMessage]
    extra_field: int
```

## Update state

A node is a Python function that reads the state and returns updates. The first argument is always the state:

```python
from langchain.messages import AIMessage

def node(state: State):
    messages = state["messages"]
    new_message = AIMessage("Hello!")
    return {"messages": messages + [new_message], "extra_field": 10}
```

Nodes should **return updates to the state directly, instead of mutating the state.** Build a graph with `StateGraph`, populate it with `add_node`, set an entry point, and `.compile()`:

```python
from langgraph.graph import StateGraph

builder = StateGraph(State)
builder.add_node(node)
builder.set_entry_point("node")
graph = builder.compile()

result = graph.invoke({"messages": [HumanMessage("Hi")]})
# {'messages': [HumanMessage('Hi'), AIMessage('Hello!')], 'extra_field': 10}
```

Invocation is kicked off by updating a single key of the state, and the entire state is returned in the invocation result.

## Process state updates with reducers

Each key in the state can have its own independent **reducer** function controlling how node updates are applied. If no reducer is specified, updates **override** the key. For `TypedDict` schemas, define a reducer by annotating the field with a reducer function:

```python
from typing_extensions import Annotated

def add(left, right):
    """Can also import `add` from the `operator` built-in."""
    return left + right

class State(TypedDict):
    messages: Annotated[list[AnyMessage], add]
    extra_field: int
```

Now a node only needs to return the *new* message; the reducer appends it automatically (`return {"messages": [new_message], ...}`).

### MessagesState

In practice there are extra considerations for message lists: updating an existing message, and accepting message-format shorthands (e.g. OpenAI format). LangGraph's built-in `add_messages` reducer handles both (it reconciles by message ID):

```python
from langgraph.graph.message import add_messages

class State(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]
    extra_field: int
```

With `add_messages`, an input message may be a dict shorthand (`{"role": "user", "content": "Hi"}`). LangGraph ships a prebuilt `MessagesState` so you can subclass it for convenience:

```python
from langgraph.graph import MessagesState

class State(MessagesState):
    extra_field: int
```

## Bypass reducers with `Overwrite`

To bypass a reducer and directly overwrite a state value, wrap the return value with `Overwrite`. When a node returns `Overwrite(value)`, the reducer is bypassed and the channel is set directly — useful to reset or replace accumulated state rather than merge it.

```python
from langgraph.types import Overwrite
import operator

class State(TypedDict):
    messages: Annotated[list, operator.add]

def add_message(state: State):
    return {"messages": ["first message"]}

def replace_messages(state: State):
    # Bypass the reducer and replace the entire messages list
    return {"messages": Overwrite(["replacement message"])}
```

Running `add_message` then `replace_messages` yields `['replacement message']` (the accumulated `["initial", "first message"]` is discarded). You can also use JSON form with the special key `"__overwrite__"`: `return {"messages": {"__overwrite__": ["replacement message"]}}`.

When nodes execute in parallel, **only one node may use `Overwrite` on the same state key in a given super-step**; multiple overwrites of the same key in one super-step raise `InvalidUpdateError`.

Source: [Use the graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api) at content SHA-256 `e3c9d981`.
