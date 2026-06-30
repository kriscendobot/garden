---
title: "LangGraph node configuration: runtime context, retries, timeouts, error handlers, runtime introspection, and caching"
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
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The fault-tolerance overview lives on the separate /oss/python/langgraph/fault-tolerance page (not yet ingested)."
---

Abstract: The per-node configuration knobs LangGraph exposes through `StateGraph` and the `Runtime` object. **Runtime configuration** (`context_schema=` on the graph; a `runtime: Runtime[ContextSchema]` parameter on a node) lets callers pass per-invocation values (model, system prompt) via `invoke(..., context=...)` without polluting graph state. **Retry policies** (`retry_policy=RetryPolicy(...)` on `add_node`) retry a node on a configurable exception set (the default skips programming errors and only retries 5xx for `requests`/`httpx`). **Node timeouts** (`timeout=` seconds / `timedelta` / `TimeoutPolicy`, async nodes only; `langgraph>=1.2`) cap a single attempt and raise `NodeTimeoutError`, with buffered writes discarded on timeout. **Error handlers** (`error_handler=`, `langgraph>=1.2`) run after retries are exhausted, receive a typed `NodeError`, and can route to recovery via `Command`. **Runtime introspection** surfaces `runtime.execution_info` (thread/run/checkpoint IDs, retry attempt number), `runtime.server_info` (assistant/graph ID, authenticated user on LangGraph Server), and `runtime.drain_requested` (graceful-shutdown signal). **Node caching** (`cache_policy=CachePolicy(ttl=...)` plus `compile(cache=InMemoryCache())`) avoids repeating expensive operations.

## Add runtime configuration

To configure a graph per call without polluting state: specify a config (context) schema, add a `runtime` parameter to nodes (or conditional edges), and pass the context at invocation:

```python
from langgraph.runtime import Runtime

class ContextSchema(TypedDict):
    my_runtime_value: str

class State(TypedDict):
    my_state_value: str

def node(state: State, runtime: Runtime[ContextSchema]):
    if runtime.context["my_runtime_value"] == "a":
        return {"my_state_value": 1}
    ...

builder = StateGraph(State, context_schema=ContextSchema)
...
graph.invoke({}, context={"my_runtime_value": "a"})
```

This is the idiom for "specify which LLM / system message to use at runtime": a `ContextSchema` dataclass with a `model_provider` (and `system_message`) field, a `MODELS` map, and `call_model` reading `runtime.context.model_provider`.

## Add retry policies

Pass `retry_policy=RetryPolicy()` to `add_node`. By default `retry_on` retries on any exception **except** the standard programming-error types (`ValueError`, `TypeError`, `ArithmeticError`, `ImportError`, `LookupError`, `NameError`, `SyntaxError`, `RuntimeError`, `ReferenceError`, `StopIteration`, `StopAsyncIteration`, `OSError`); for `requests`/`httpx` it retries only on 5xx status codes. Customize per node: `RetryPolicy(retry_on=sqlite3.OperationalError)`, `RetryPolicy(max_attempts=5)`.

## Set / configure node timeouts

Use `timeout=` on `add_node` to limit how long a single **async** node attempt may run (seconds, a `timedelta`, or a `TimeoutPolicy(run_timeout=..., idle_timeout=...)` for finer control; per-node timeouts require `langgraph>=1.2`).

```python
builder.add_node("model", call_model, timeout=1.0)
# or
from langgraph.types import TimeoutPolicy
builder.add_node("call_model", call_model, timeout=TimeoutPolicy(run_timeout=120, idle_timeout=30))
```

Timeouts are supported only for **async** nodes — setting `timeout` on a sync node fails at compile time, because sync Python execution cannot be safely canceled in-process. On exceeding the limit, LangGraph raises `NodeTimeoutError` (a subclass of Python's `TimeoutError`); if the node's retry policy retries `TimeoutError`/`NodeTimeoutError`, the attempt is retried and the timer resets for every retry. **Timed-out attempts do not commit their buffered writes**, preventing state updates or child-task scheduling from leaking past the timeout boundary.

## Handle node errors

`error_handler=` on `add_node` (requires `langgraph>=1.2`) registers a function that runs after a node fails and all retries are exhausted. It receives the current state and a typed `NodeError` with failure context, and can route to a recovery branch via `Command`:

```python
from langgraph.errors import NodeError
from langgraph.types import Command, RetryPolicy

def payment_error_handler(state: State, error: NodeError) -> Command:
    return Command(update={"status": f"compensated: {error.error}"}, goto="finalize")

builder.add_node("charge_payment", charge_payment,
    retry_policy=RetryPolicy(max_attempts=3, retry_on=ConnectionError),
    error_handler=payment_error_handler)
```

## Runtime introspection inside a node

- **`runtime.execution_info`** surfaces execution identity and retry state without reading `config` directly: `thread_id`, `run_id`, `checkpoint_id`, `checkpoint_ns`, `task_id`, `node_attempt` (1-indexed; `1` on first try, `2` on first retry), `node_first_attempt_time` (Unix seconds, stable across retries). Use `node_attempt > 1` to switch to a fallback on retries. Available even without a retry policy (`node_attempt` defaults to `1`).
- **`runtime.server_info`** (on LangGraph Server) surfaces `assistant_id`, `graph_id`, and `user` (the authenticated user when custom auth is configured); `None` during local development/testing. (`execution_info`/`server_info` require `deepagents>=0.5.0` or `langgraph>=1.1.5`.)
- **`runtime.drain_requested`** is `True` once a graceful shutdown (`RunControl.request_drain()`) has been requested; read it to skip expensive work before the next super-step boundary, with `runtime.drain_reason` carrying the reason string (`langgraph>=1.2`).

## Add node caching

Pass `cache_policy=CachePolicy(ttl=120)` to `add_node` (with the default `key_func` generator), then enable graph-level caching at compile time with a cache backend:

```python
from langgraph.types import CachePolicy
from langgraph.cache.memory import InMemoryCache

builder.add_node("node_name", node_function, cache_policy=CachePolicy(ttl=120))
graph = builder.compile(cache=InMemoryCache())   # SqliteCache is also available
```

Source: [Use the graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api) at content SHA-256 `e3c9d981`.
