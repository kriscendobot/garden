---
title: "LangChain short-term memory: context-window management and state access"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/short-term-memory
source_content_sha256: a874692dcd9ad3be3705bb19a22e0a13a3ec816fb23ae61930a2cbf3aded5529
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: Long conversations exceed the LLM's context window, and even within the window models degrade on long contexts — distracted by stale content, slower, and costlier — so applications "forget" stale information. LangChain offers three context-management patterns plus custom strategies: **trim** (remove the first or last N messages before the LLM call), **delete** (permanently remove messages from graph state), and **summarize** (replace earlier history with a model-generated summary). Trimming and deleting lose information; summarization preserves it at the cost of an extra model call. The same short-term state is **accessible and mutable** from four places — tools (via the `ToolRuntime` parameter), the dynamic prompt, and the `@before_model` / `@after_model` middleware hooks — each receiving the state, optionally returning updates.

## Common patterns

### Trim messages

Count tokens and truncate when the history approaches the limit. Apply trimming with the `@before_model` middleware decorator, returning a `RemoveMessage(id=REMOVE_ALL_MESSAGES)` followed by the messages to keep:

```python
@before_model
def trim_messages(state: AgentState, runtime: Runtime) -> dict[str, Any] | None:
    messages = state["messages"]
    if len(messages) <= 3:
        return None
    new_messages = [messages[0]] + messages[-3:]
    return {"messages": [RemoveMessage(id=REMOVE_ALL_MESSAGES), *new_messages]}
```

### Delete messages

Permanently remove messages from graph state with `RemoveMessage`. Removing a specific message uses `RemoveMessage(id=m.id)`; removing all uses `RemoveMessage(id=REMOVE_ALL_MESSAGES)`. This requires a state key with the `add_messages` reducer (the default `AgentState` provides it). **Warning:** ensure the resulting history stays valid for the provider — some require the first message to be `user`, and most require an assistant tool-call message to be followed by its `tool` results.

### Summarize messages

Trimming and deleting cull information; summarization condenses the history with a chat model instead. Use the built-in `SummarizationMiddleware`, configured with a `trigger` (e.g. `("tokens", 4000)`) and how much to `keep` (e.g. `("messages", 20)`):

```python
agent = create_agent(model="gpt-5.5", tools=[...],
    middleware=[SummarizationMiddleware(model="gpt-5.4-mini",
                                        trigger=("tokens", 4000), keep=("messages", 20))],
    checkpointer=InMemorySaver())
```

## Accessing memory (state)

The agent's short-term state can be read and modified in several places:

- **In a tool** — accept a `runtime: ToolRuntime` parameter (hidden from the model). Read with `runtime.state[...]`; write by returning a `Command(update={...})` from the tool, which can both update custom state keys and append a `ToolMessage` to history.
- **In a dynamic prompt** — the `@dynamic_prompt` middleware receives a `ModelRequest`, from which `request.runtime.context[...]` (and state) drive a per-call system prompt.
- **`@before_model`** — process or rewrite messages before each model call (the trim example above).
- **`@after_model`** — process messages after each model call, e.g. removing a response containing sensitive words by returning `RemoveMessage(id=last_message.id)`.

The `runtime` carries both the thread-scoped **state** and the cross-thread **store** (see `web--langchain-long-term-memory--cross-thread-store-and-tool-access`), giving tools a unified handle on short- and long-term memory.

Source: [LangChain short-term memory](https://docs.langchain.com/oss/python/langchain/short-term-memory) retrieved 2026-06-30, content hash `a874692d`.
