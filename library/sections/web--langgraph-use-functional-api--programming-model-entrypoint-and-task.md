---
title: "LangGraph functional API: the @entrypoint / @task programming model"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-functional-api
source_content_sha256: b0b673a401421eab5664b46d5feba365c4c07b61da6f4c6011f5b5f68f86a4b6
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The functional API is the @entrypoint/@task alternative to the StateGraph graph API (web--langgraph-use-graph-api); both share the same underlying LangGraph runtime."
---

Abstract: The functional API is LangGraph's decorator-based programming model — an alternative to the `StateGraph` graph API that adds persistence, memory, human-in-the-loop, and streaming to ordinary Python control flow with minimal restructuring. Two decorators carry it: `@entrypoint` marks a workflow function (its first argument is the single input; pass a dict for multiple values) and binds a `checkpointer`; `@task` marks a unit of work that runs asynchronously and returns a future, whose `.result()` you await for the value. Because each `@task` call is a future, invoking several before resolving them runs them in **parallel** (useful for concurrent I/O-bound LLM calls). The functional API and the graph API share one runtime, so an entrypoint can `.invoke()` a compiled `StateGraph`, and entrypoints can call other entrypoints (a nested entrypoint inherits the parent's checkpointer).

## Creating a simple workflow

When defining an `entrypoint`, input is restricted to the first argument of the function. To pass multiple inputs, use a dictionary:

```python
@entrypoint(checkpointer=checkpointer)
def my_workflow(inputs: dict) -> int:
    value = inputs["value"]
    another_value = inputs["another_value"]
    ...

my_workflow.invoke({"value": 1, "another_value": 2})
```

A `@task` is a function whose call returns a future; `.result()` blocks for the value. Tasks compose inside an entrypoint:

```python
from langgraph.func import entrypoint, task
from langgraph.checkpoint.memory import InMemorySaver

@task
def is_even(number: int) -> bool:
    return number % 2 == 0

@task
def format_message(is_even: bool) -> str:
    return "The number is even." if is_even else "The number is odd."

checkpointer = InMemorySaver()

@entrypoint(checkpointer=checkpointer)
def workflow(inputs: dict) -> str:
    """Simple workflow to classify a number."""
    even = is_even(inputs["number"]).result()
    return format_message(even).result()

config = {"configurable": {"thread_id": str(uuid7())}}
result = workflow.invoke({"number": 7}, config=config)
```

A `@task` body may call an LLM (`model.invoke(...)`); given a checkpointer, the workflow's results are persisted.

## Parallel execution

Tasks run in parallel by invoking them concurrently and waiting for the results — useful for IO-bound work like calling LLM APIs. Collect the futures, then resolve them:

```python
@task
def add_one(number: int) -> int:
    return number + 1

@entrypoint(checkpointer=checkpointer)
def graph(numbers: list[int]) -> list[str]:
    futures = [add_one(i) for i in numbers]
    return [f.result() for f in futures]
```

The same shape parallelizes multiple LLM completions (one paragraph per topic, joined into one output); LangGraph's concurrency model improves execution time when tasks involve I/O.

## Calling graphs and other entrypoints

The functional API and the [graph API](web--langgraph-use-graph-api--state-definition-reducers-and-overwrite.md) can be used together in one application because they **share the same underlying runtime**. An entrypoint may `.invoke()` one or more compiled `StateGraph`s:

```python
from langgraph.func import entrypoint
from langgraph.graph import StateGraph

builder = StateGraph()
...
some_graph = builder.compile()

@entrypoint()
def some_workflow(some_input: dict) -> int:
    result_1 = some_graph.invoke(...)
    result_2 = another_graph.invoke(...)
    return {"result_1": result_1, "result_2": result_2}
```

You can also call other **entrypoints** from within an entrypoint or a task. A nested entrypoint declared without its own checkpointer **automatically uses the checkpointer from the parent entrypoint**:

```python
@entrypoint()  # inherits the parent entrypoint's checkpointer
def some_other_workflow(inputs: dict) -> int:
    return inputs["value"]

@entrypoint(checkpointer=checkpointer)
def my_workflow(inputs: dict) -> int:
    value = some_other_workflow.invoke({"value": 1})
    return value
```

## Streaming

The functional API uses the same streaming mechanism as the graph API (see the [streaming guide](web--langgraph-streaming--stream-modes-and-v2-streampart-format.md)). The v3 event-streaming API exposes typed iterators on the returned stream — `interleave("values")` yields `(mode, chunk)` pairs, and `.values` / `.messages` give per-projection iterators:

```python
config = {"configurable": {"thread_id": str(uuid7())}}
stream = main.stream_events({"x": 5}, config=config, version="v3")
for mode, chunk in stream.interleave("values"):
    print(f"{mode}: {chunk}")
# values: 10
```

Emit custom data from inside an entrypoint with `get_stream_writer()` (from `langgraph.config`). On **Python < 3.11** in async code, `get_stream_writer` does not work; instead add a `writer: StreamWriter` parameter to the entrypoint and LangGraph passes the writer in.

Source: [Use the functional API](https://docs.langchain.com/oss/python/langgraph/use-functional-api) at content SHA-256 `b0b673a4`.
