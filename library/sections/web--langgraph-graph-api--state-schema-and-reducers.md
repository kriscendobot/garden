---
title: "LangGraph state: the shared state schema and per-channel reducers"
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

Abstract: A LangGraph graph is defined first by its `State`: a schema (a `TypedDict`, dataclass, or Pydantic `BaseModel`) plus a set of **reducer** functions, one per state key (channel), that specify how a node's emitted update is merged into the running state. The schema is the input to every node and edge; nodes return partial updates, not the whole state, and may write to any channel in the graph. Each channel has an independent reducer: the default reducer overwrites, while an annotated reducer such as `operator.add` accumulates. The prebuilt `add_messages` reducer (and `MessagesState`) appends new messages but reconciles by message ID so manual/human-in-the-loop edits update existing messages rather than duplicating them.

## State and schema

The first thing you do when defining a graph is define its `State`: the schema plus reducer functions. The schema is the input to all nodes and edges; nodes emit updates that are applied via the reducers. The documented schema form is a `TypedDict` (use a dataclass for defaults, or a Pydantic `BaseModel` for recursive validation, though Pydantic is less performant). The higher-level `create_agent` factory does not support Pydantic state schemas.

By default input and output schemas are the same. You can declare distinct `input_schema` and `output_schema` (subsets of an overall internal schema) and even private channels (`PrivateState`) for internal node-to-node communication. Two subtleties: (1) a node can write to *any* state channel in the graph, not only channels in its declared input schema, because the graph state is the union of all defined channels; (2) input/output/private schemas constrain what a node *reads* and what `invoke` *returns*, but they do **not** hide channels from `stream` (private channels are visible while streaming unless you pass `output_keys`).

## Reducers

Reducers are how node updates are applied to the state. Each key in the state has its own independent reducer. If no reducer is specified, updates **override** that key. With an annotated reducer they accumulate:

```python
from typing import Annotated
from typing_extensions import TypedDict
from operator import add

class State(TypedDict):
    foo: int                          # default reducer: overwrite
    bar: Annotated[list[str], add]    # accumulate via list concatenation
```

Given input `{"foo": 1, "bar": ["hi"]}`, a first node returning `{"foo": 2}` and a second returning `{"bar": ["bye"]}` yields `{"foo": 2, "bar": ["hi", "bye"]}` (foo overwritten, bar accumulated). LangGraph also provides an `Overwrite` type to bypass a reducer for a single update.

## Messages in state

Most LLM providers accept a list of messages. To keep conversation history in state, add a channel holding a list of `Message` objects with a reducer. A plain `operator.add` would *append* even manual updates (duplicating edited messages); the prebuilt `add_messages` reducer instead tracks message IDs, appending new messages but overwriting existing ones by ID, which is what human-in-the-loop state edits need. `add_messages` also deserializes raw dicts into LangChain `Message` objects. The prebuilt `MessagesState` is a state with a single `messages` channel using `add_messages`; applications typically subclass it to add more fields.

Source: [Graph API overview](https://docs.langchain.com/oss/python/langgraph/graph-api) retrieved 2026-06-30, content hash `6d766689`.
