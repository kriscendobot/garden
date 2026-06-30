---
id: langgraph-functional-api
aliases: [functional API, "@entrypoint", "@task", entrypoint, task, "entrypoint.final", langgraph.func, stream_writer, StreamWriter, get_stream_writer, RetryPolicy, CachePolicy, InMemoryCache, NodeTimeoutError, previous parameter, decouple return value]
topics: [llm-agent-frameworks, persistence, patterns]
---

# langgraph-functional-api

The **functional API** is LangGraph's decorator-based programming model — an alternative to the `StateGraph` [graph API](../sections/web--langgraph-use-graph-api--state-definition-reducers-and-overwrite.md) that adds LangGraph's features (persistence, memory, human-in-the-loop, streaming) to ordinary Python control flow with minimal restructuring. `@entrypoint` marks a workflow function: its first argument is the single input (pass a dict for multiple values) and it binds a `checkpointer`. `@task` marks a unit of work that runs asynchronously and returns a future, whose `.result()` you await — invoking several tasks before resolving them runs them in **parallel**. Both decorators share the same underlying runtime as the graph API, so an entrypoint can `.invoke()` a compiled `StateGraph` and entrypoints can nest (a nested entrypoint inherits the parent's checkpointer). Execution policy is set as decorator parameters (`@task(retry_policy=...)`, `@task(timeout=...)`/`@entrypoint(timeout=...)` with async-only `NodeTimeoutError`, `@task(cache_policy=CachePolicy(ttl=...))` + `@entrypoint(cache=InMemoryCache())`). With a checkpointer, completed task results persist so a resumed workflow skips them; `entrypoint.final(value=..., save=...)` decouples what the caller receives from what is saved and passed as the `previous` parameter next run. Human-in-the-loop uses the same `interrupt()` / `Command(resume=)` cycle as the graph API.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [the @entrypoint / @task programming model](../sections/web--langgraph-use-functional-api--programming-model-entrypoint-and-task.md) | Core decorators: single-input entrypoints, task futures and `.result()`, parallel execution, calling graphs and other entrypoints over the shared runtime. |
| [retry policy, timeouts, and task caching](../sections/web--langgraph-use-functional-api--retries-timeouts-and-caching.md) | Per-task/entrypoint execution policy: `RetryPolicy`, async timeouts and `NodeTimeoutError`, `CachePolicy`/`InMemoryCache`. |
| [persistence, error resume, and short-term memory](../sections/web--langgraph-use-functional-api--persistence-resume-and-short-term-memory.md) | Checkpointer-backed resume-without-rerun, `get_state`/`get_state_history`, `entrypoint.final` decoupling, the `previous` parameter. |
| [human-in-the-loop with interrupt and tool-call review](../sections/web--langgraph-use-functional-api--human-in-the-loop-interrupt-and-review.md) | `interrupt()` / `Command(resume=)` pause-resume in the functional API and the accept/revise/feedback tool-call review pattern. |

## See also

- [[langgraph]] — the orchestration runtime; the functional API is the decorator-based alternative to its StateGraph graph API, over the same runtime.
- [[human-in-the-loop]] — the `interrupt()` / `Command(resume=)` capability the functional API exposes via tasks.
- [[langgraph-checkpointer]] — the short-term persistence the functional API resumes from and reads via `get_state`.
- [[langgraph-store]] — long-term, cross-thread memory (the functional API's "long-term memory").
- [[agent-streaming]] — the streaming mechanism the functional API shares with the graph API (`stream_events`, `get_stream_writer`).
