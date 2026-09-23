---
title: "LangGraph interrupts: human-in-the-loop patterns"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/interrupts
source_content_sha256: 2b8b11d645f16c019d434392733a54d7be5d16fce0cdf70d4e2392e4383656b5
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: The catalog of human-in-the-loop patterns interrupts unlock, all driven by event streaming and resumed with `Command(resume=...)`. **HITL streaming**: a loop that calls `stream_events`, streams model chunks (`stream.messages`) and per-step snapshots (`stream.values`), checks `stream.interrupted`, gets human input, resumes, and repeats until done. **Multiple interrupts**: when parallel branches each call `interrupt()`, resume them in one invocation by mapping each interrupt ID to its resume value (`Command(resume={id: value})`). **Approve or reject**: pause before a critical action and route on the boolean resume (`Command(goto="proceed"/"cancel")`). **Review and edit state**: surface generated content for a human to edit, then write the edited resume value back into state. **Interrupts in tools**: place `interrupt()` inside a tool body so the tool itself pauses for approval, and let the resume payload override the tool's arguments before execution. **Validating human input**: call `interrupt()` exactly once per node invocation, store the re-prompt in state, and loop back via a conditional edge until valid — never a `while True` + `interrupt()` loop (which re-executes exponentially because the node replays from the start on each resume).

## Stream with HITL interrupts

Use the typed projections from `graph.stream_events(..., version="v3")` in a loop until the run finishes: stream AI responses token-by-token via `stream.messages` (for nested subgraphs, `stream.subgraphs[*].messages`), observe per-step state snapshots via `stream.values`, detect interrupts via `stream.interrupted` and read payloads from `stream.interrupts`, then resume by calling `stream_events` again with `Command(resume=...)` and repeat until no longer interrupted.

```python
stream_input = initial_input
while True:
    stream = graph.stream_events(stream_input, config=config, version="v3")
    for message in stream.messages:
        for token in message.text:
            display_streaming_content(token)
    if not stream.interrupted:
        final_state = stream.output
        break
    interrupt_info = stream.interrupts[0].value
    user_response = get_user_input(interrupt_info)
    stream_input = Command(resume=user_response)
```

## Handling multiple interrupts

When parallel branches interrupt simultaneously (fan-out to multiple nodes that each call `interrupt()`), resume multiple interrupts in a single invocation by mapping each interrupt ID to its resume value, so each response is paired with the correct interrupt:

```python
resume_map = {i.id: f"answer for {i.value}" for i in stream.interrupts}
resumed = graph.stream_events(Command(resume=resume_map), config, version="v3")
```

## Approve or reject

A common use is pausing before a critical action to ask for approval, then routing on the resume value:

```python
def approval_node(state) -> Command[Literal["proceed", "cancel"]]:
    is_approved = interrupt({"question": "Proceed?", "details": state["action_details"]})
    return Command(goto="proceed") if is_approved else Command(goto="cancel")
```

Resume with `Command(resume=True)` to approve or `Command(resume=False)` to reject.

## Review and edit state

Let a human review and edit part of the state before continuing (correcting LLM output, adding missing info). The node surfaces the current content via `interrupt({...})` and writes the edited resume value back into state:

```python
def review_node(state):
    edited = interrupt({"instruction": "Review and edit this content", "content": state["generated_text"]})
    return {"generated_text": edited}
```

## Interrupts in tools

Place an `interrupt()` directly inside a tool function so the tool pauses for approval whenever it is called, allowing human review/editing of the tool call before execution. The resume payload can override the tool's inputs before the action runs (e.g. an approved/edited email). This keeps approval logic with the tool, making it reusable; the model calls the tool naturally and the interrupt pauses execution on invocation.

## Validating human input

To validate input and re-prompt on invalid values, the recommended approach is to call `interrupt()` **once per node invocation**, return from the node with the re-prompt stored in state, and use a **conditional edge** to loop back until valid. Avoid `while True` + `interrupt()` loops inside a single node: because the node re-runs from the beginning on every resume, a multi-`interrupt()` loop replays all previous iterations (first resume replays 1, second replays 2, …), causing exponential re-execution. The correct pattern stores the pending question in state, calls `interrupt()` exactly once with the current question, returns an updated question if the answer is invalid, and routes back via `add_conditional_edges` until a valid value is collected.

Source: [LangGraph interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts) retrieved 2026-06-30, content hash `2b8b11d6`.
