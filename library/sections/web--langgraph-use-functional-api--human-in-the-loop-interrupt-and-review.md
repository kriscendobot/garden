---
title: "LangGraph functional API: human-in-the-loop with interrupt and tool-call review"
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
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering. The functional-API expression of the same interrupt()/Command(resume=) human-in-the-loop mechanics the graph API uses (web--langgraph-interrupts--interrupt-and-resume-mechanics); the review-tool-call pattern is the canonical accept/revise/feedback gate."
---

Abstract: Human-in-the-loop in the functional API uses the same `interrupt()` function and `Command` primitive as the graph API. A `@task` calls `interrupt(payload)` to pause the workflow and surface the payload to the caller; because prior tasks' results are persisted, they are **not re-run** when the workflow resumes. The caller resumes by re-invoking (or re-streaming) the entrypoint with `Command(resume=<data>)`, and the value flows back as `interrupt()`'s return. The canonical application is reviewing tool calls before execution: a `review_tool_call` helper interrupts with the proposed call and branches on the human's reply — **accept** (run the call as-is), **revise** (run an edited call), or **feedback** (skip execution and append a `ToolMessage` instructing the model to retry), looping until the model emits no further tool calls.

## Basic human-in-the-loop workflow

Three tasks: append `"bar"`, pause for human input (appending it on resume), append `"qux"`:

```python
from langgraph.func import entrypoint, task
from langgraph.types import Command, interrupt

@task
def step_1(input_query):
    return f"{input_query} bar"

@task
def human_feedback(input_query):
    feedback = interrupt(f"Please provide feedback: {input_query}")
    return f"{input_query} {feedback}"

@task
def step_3(input_query):
    return f"{input_query} qux"

@entrypoint(checkpointer=checkpointer)
def graph(input_query):
    result_1 = step_1(input_query).result()
    result_2 = human_feedback(result_1).result()
    result_3 = step_3(result_2).result()
    return result_3
```

`interrupt()` is called inside a task, letting a human review and edit the previous task's output. The results of prior tasks (here `step_1`) are persisted, so they are not run again following the interrupt. Resume by issuing a `Command` carrying the data the `human_feedback` task expects:

```python
config = {"configurable": {"thread_id": "1"}}
# Initial run pauses at the interrupt after step_1.
stream = graph.stream_events("foo", config, version="v3")
...
# Resume with the human's feedback.
stream = graph.stream_events(Command(resume="baz"), config, version="v3")
```

## Review tool calls

To review tool calls before execution, a `review_tool_call` function calls `interrupt` for human review; execution pauses until a resume command arrives. Given a tool call, the human can **accept** it, **revise** it and continue, or generate a **custom tool message** (e.g. telling the model to re-format its call):

```python
def review_tool_call(tool_call: ToolCall) -> Union[ToolCall, ToolMessage]:
    """Review a tool call, returning a validated version."""
    human_review = interrupt({
        "question": "Is this correct?",
        "tool_call": tool_call,
    })
    review_action = human_review["action"]
    review_data = human_review.get("data")
    if review_action == "continue":
        return tool_call
    elif review_action == "update":
        return {**tool_call, **{"args": review_data}}
    elif review_action == "feedback":
        return ToolMessage(
            content=review_data, name=tool_call["name"], tool_call_id=tool_call["id"]
        )
```

The agent entrypoint loops: call the model, review each generated tool call, execute the accepted/revised calls (in parallel) while appending any `ToolMessage` feedback, then call the model again until no tool calls remain. Prior task results (the initial model call) are persisted across the interrupt. The final response is returned via `entrypoint.final(value=model_response, save=messages)`:

```python
@entrypoint(checkpointer=checkpointer)
def agent(messages, previous):
    if previous is not None:
        messages = add_messages(previous, messages)
    model_response = call_model(messages).result()
    while True:
        if not model_response.tool_calls:
            break
        tool_results, tool_calls = [], []
        for i, tool_call in enumerate(model_response.tool_calls):
            review = review_tool_call(tool_call)
            if isinstance(review, ToolMessage):
                tool_results.append(review)
            else:                       # a validated tool call
                tool_calls.append(review)
                if review != tool_call:
                    model_response.tool_calls[i] = review
        tool_result_futures = [call_tool(tc) for tc in tool_calls]
        remaining_tool_results = [f.result() for f in tool_result_futures]
        messages = add_messages(
            messages, [model_response, *tool_results, *remaining_tool_results]
        )
        model_response = call_model(messages).result()
    messages = add_messages(messages, model_response)
    return entrypoint.final(value=model_response, save=messages)
```

Source: [Use the functional API](https://docs.langchain.com/oss/python/langgraph/use-functional-api) at content SHA-256 `b0b673a4`.
