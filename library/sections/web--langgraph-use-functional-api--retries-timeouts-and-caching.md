---
title: "LangGraph functional API: retry policy, timeouts, and task caching"
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
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The same RetryPolicy/timeout/CachePolicy primitives the graph API exposes on add_node (see web--langgraph-use-graph-api--node-configuration-retries-timeouts-errors-and-caching), surfaced as @task / @entrypoint decorator parameters."
---

Abstract: Per-task and per-entrypoint execution policy in the functional API, set as decorator parameters rather than `add_node` arguments. `@task(retry_policy=RetryPolicy(...))` retries a failing task (the default `RetryPolicy` targets specific network errors; `retry_on=ValueError` retries on a given exception type). `@task(timeout=...)` / `@entrypoint(timeout=...)` bound a single async attempt (seconds or a `timedelta`); timeouts apply only to **async** tasks/entrypoints — a `timeout` on a sync function raises at declaration. On expiry LangGraph raises `NodeTimeoutError` (a subclass of Python's `TimeoutError`), which a retry policy can itself retry, with the timer resetting per attempt. `@task(cache_policy=CachePolicy(ttl=...))` plus `@entrypoint(cache=InMemoryCache())` memoizes a task's result by its inputs for `ttl` seconds, so repeated identical calls within the window skip recomputation.

## Retry policy

Configure a `RetryPolicy` and attach it to a task. The default policy is tuned for network errors; pass `retry_on` to retry on a specific exception:

```python
from langgraph.func import entrypoint, task
from langgraph.types import RetryPolicy

# The default RetryPolicy is optimized for retrying specific network errors.
retry_policy = RetryPolicy(retry_on=ValueError)

@task(retry_policy=retry_policy)
def get_info():
    global attempts
    attempts += 1
    if attempts < 2:
        raise ValueError('Failure')
    return "OK"

@entrypoint(checkpointer=checkpointer)
def main(inputs, writer):
    return get_info().result()

main.invoke({'any_input': 'foobar'}, config={"configurable": {"thread_id": "1"}})
# 'OK'
```

## Set task and entrypoint timeouts

Use the `timeout` parameter with `@task` or `@entrypoint` to limit how long a single async attempt can run. Provide the timeout in seconds or as a `datetime.timedelta`:

```python
import asyncio
from langgraph.errors import NodeTimeoutError
from langgraph.func import entrypoint, task
from langgraph.types import RetryPolicy

@task(
    timeout=1.0,
    retry_policy=RetryPolicy(retry_on=NodeTimeoutError),
)
async def call_api(url: str) -> str:
    await asyncio.sleep(2)
    return f"result from {url}"

@entrypoint(timeout=5.0)
async def workflow(inputs: dict) -> str:
    return await call_api(inputs["url"])

try:
    await workflow.ainvoke({"url": "https://example.com"})
except NodeTimeoutError:
    print("Task timed out")
```

Timeouts are supported only for **async** tasks and entrypoints. Setting `timeout` on a sync function raises an error when the task or entrypoint is declared. When a task or entrypoint exceeds its timeout, LangGraph raises `NodeTimeoutError`, which subclasses Python's built-in `TimeoutError`; if a retry policy retries `TimeoutError` or `NodeTimeoutError`, the timed-out attempt is retried. The timeout applies to each attempt independently, so the timer resets for every retry.

## Caching tasks

Memoize a task's result by attaching a `CachePolicy` to the task and an `InMemoryCache` to the entrypoint. `ttl` is specified in seconds; the cache invalidates after that time:

```python
import time
from langgraph.cache.memory import InMemoryCache
from langgraph.func import entrypoint, task
from langgraph.types import CachePolicy

@task(cache_policy=CachePolicy(ttl=120))
def slow_add(x: int) -> int:
    time.sleep(1)
    return x * 2

@entrypoint(cache=InMemoryCache())
def main(inputs: dict) -> dict[str, int]:
    result1 = slow_add(inputs["x"]).result()
    result2 = slow_add(inputs["x"]).result()  # served from cache
    return {"result1": result1, "result2": result2}
```

Source: [Use the functional API](https://docs.langchain.com/oss/python/langgraph/use-functional-api) at content SHA-256 `b0b673a4`.
