---
title: "LangGraph functional API: persistence, error resume, and short-term memory"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-functional-api
source_content_sha256: b0b673a401421eab5664b46d5feba365c4c07b61da6f4c6011f5b5f68f86a4b6
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence, change-propagation]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The functional API's view of the same checkpointer machinery the graph API uses (web--langgraph-checkpointers-*, web--langgraph-persistence--checkpointers-vs-stores); entrypoint.final is the functional-API-specific decouple-return-from-saved primitive."
---

Abstract: How a checkpointer-backed entrypoint persists and resumes. Because each completed `@task`'s result is saved to the checkpoint, re-invoking a workflow after a failure **does not re-run already-completed tasks** — only the failed task and what follows it run again. Short-term memory is the checkpoint of a single `thread_id`: `graph.get_state(config)` returns the current `StateSnapshot` (values, next, metadata, parent config, tasks, interrupts) and `graph.get_state_history(config)` returns the full per-super-step history newest-first. `entrypoint.final(value=..., save=...)` **decouples what the caller receives from what is persisted**: the caller gets `value`, while `save` is what is written to the checkpoint and passed as the entrypoint's `previous` parameter on the next invocation of the same thread — the basis for an accumulator or a memory-carrying chatbot. Long-term, cross-`thread_id` memory uses a store instead (see [[langgraph-store]]).

## Resuming after an error

When a task fails partway through an entrypoint, the results of the tasks that already succeeded are saved in the checkpoint. Re-invoking the workflow on the same thread skips them:

```python
@task
def slow_task():
    time.sleep(1)
    return "Ran slow task."

@task()
def get_info():
    global attempts
    attempts += 1
    if attempts < 2:
        raise ValueError("Failure")   # fails on the first attempt
    return "OK"

@entrypoint(checkpointer=checkpointer)
def main(inputs, writer: StreamWriter):
    slow_task_result = slow_task().result()   # blocking
    get_info().result()                       # raises on first attempt
    return slow_task_result

config = {"configurable": {"thread_id": "1"}}
try:
    main.invoke({'any_input': 'foobar'}, config=config)
except ValueError:
    pass
```

> When we resume execution, we won't need to re-run the `slow_task` as its result is already saved in the checkpoint.

```python
main.invoke(None, config=config)   # 'Ran slow task.'
```

## Short-term memory: managing checkpoints

Short-term memory stores information across invocations of the **same thread id**. Inspect it with `get_state` / `get_state_history`.

View the current thread state (optionally for a specific `checkpoint_id`, else the latest):

```python
config = {"configurable": {"thread_id": "1"}}
graph.get_state(config)
# StateSnapshot(values={'messages': [...]}, next=(), config={...},
#   metadata={'source': 'loop', 'writes': {...}, 'step': 4, ...},
#   created_at='2025-05-05T16:01:24...', parent_config={...}, tasks=(), interrupts=())
```

View the full history of the thread (newest checkpoint first); each `StateSnapshot` carries `values`, `next`, `metadata` (with `source`, `writes`, `step`), `parent_config`, and any `PregelTask`s:

```python
config = {"configurable": {"thread_id": "1"}}
list(graph.get_state_history(config))
```

## Decouple return value from saved value with entrypoint.final

`entrypoint.final` separates what is returned to the caller from what is persisted in the checkpoint. Useful when you want to return a computed result (a summary or status) but save a different internal value, or control what is passed to the `previous` parameter on the next run:

```python
@entrypoint(checkpointer=checkpointer)
def accumulate(n: int, *, previous: int | None) -> entrypoint.final[int, int]:
    previous = previous or 0
    total = previous + n
    # Return the *previous* value to the caller but save the *new* total.
    return entrypoint.final(value=previous, save=total)

config = {"configurable": {"thread_id": "my-thread"}}
print(accumulate.invoke(1, config=config))  # 0
print(accumulate.invoke(2, config=config))  # 1
print(accumulate.invoke(3, config=config))  # 3
```

A memory-carrying chatbot combines `entrypoint.final` with the injected `previous` parameter and `add_messages`: each turn folds the new input into the saved message history, calls the model, and saves the appended history while returning just the response:

```python
@entrypoint(checkpointer=checkpointer)
def workflow(inputs: list[BaseMessage], *, previous: list[BaseMessage]):
    if previous:
        inputs = add_messages(previous, inputs)
    response = call_model(inputs).result()
    return entrypoint.final(value=response, save=add_messages(inputs, response))
```

## Long-term memory

Long-term memory stores information across different **thread ids** — useful for learning something about a user in one conversation and using it in another. It uses a store rather than the thread-scoped checkpointer (see [[langgraph-store]]).

Source: [Use the functional API](https://docs.langchain.com/oss/python/langgraph/use-functional-api) at content SHA-256 `b0b673a4`.
