---
title: "Streaming: common patterns — reasoning, tool calls, human-in-the-loop, sub-agents"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/streaming
source_content_sha256: 7f967e5c4d677bc8e40fc1fac8d8e52adef8c7ac08a56897c7edb56f5bc3e02b
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns, human-in-the-loop]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

Abstract: Four recurring streaming patterns built on the base modes. **Reasoning / thinking tokens**: stream with `messages` mode and filter `content_blocks` for `type == "reasoning"` (or read `message.reasoning` via event streaming); reasoning must be enabled on the model, and LangChain normalizes provider-specific formats (Anthropic `thinking`, OpenAI `reasoning` summaries) into the one standard `"reasoning"` block type. **Streaming tool calls**: `messages` mode gives partial-JSON `tool_call_chunk`s as they generate; to also see the *completed, parsed* tool calls, combine `stream_mode=["messages", "updates"]` (when the messages are tracked in state, as in `create_agent`'s model node) and read the completed message off the `updates` chunk — or aggregate chunks in the loop (sum `AIMessageChunk`s and act on `chunk_position == "last"`) when they are not state-tracked. **Human-in-the-loop streaming**: configure `HumanInTheLoopMiddleware` + a checkpointer, collect `__interrupt__` entries seen during the `updates` stream, then resume the *same* streaming loop with `Command(resume=decisions)` — the order of decisions must match the order of collected actions. **Sub-agent streaming**: give each agent a `name`, pass `subgraphs=True`, and disambiguate token source via the `lc_agent_name` metadata key (also attached to that agent's `AIMessage`s).

## Reasoning / thinking tokens

Stream model reasoning by filtering standard content blocks for `type` `"reasoning"`:

```python
stream = agent.stream_events({"messages": [...]}, version="v3")
for message in stream.messages:
    for token in message.reasoning:
        print(f"[thinking] {token}", end="")
    for token in message.text:
        print(token, end="", flush=True)
```

Reasoning output must be enabled on the model (e.g. Anthropic `thinking={"type": "enabled", "budget_tokens": 5000}`). This works the same across providers because LangChain normalizes provider formats into the standard `"reasoning"` content block.

## Streaming tool calls (partial + completed)

`stream_mode="messages"` streams incremental `AIMessageChunk`s for every LLM call, including partial `tool_call_chunks`. To also access completed, parsed tool calls:

1. If the messages are tracked in state (default for `create_agent`'s model node), use `stream_mode=["messages", "updates"]` and read the completed message from the `updates` chunk (`source in ("model", "tools")`).
2. If they are not state-tracked, emit them as custom updates, or aggregate chunks in the loop:

```python
full_message = None
for chunk in agent.stream({"messages": [input_message]}, stream_mode=["messages", "updates"], version="v2"):
    if chunk["type"] == "messages":
        token, metadata = chunk["data"]
        if isinstance(token, AIMessageChunk):
            full_message = token if full_message is None else full_message + token
            if token.chunk_position == "last":
                if full_message.tool_calls:
                    print(f"Tool calls: {full_message.tool_calls}")
                full_message = None
```

## Streaming with human-in-the-loop

Build on the tool-call example: configure the agent with `HumanInTheLoopMiddleware(interrupt_on={...})` and a checkpointer; collect interrupts surfaced under `source == "__interrupt__"` during the `updates` stream; build a decision per interrupt (`approve` / `edit` / `reject`), keeping the **decision order aligned with the collected action order**; then resume by passing `Command(resume=decisions)` into the same streaming loop.

## Streaming from sub-agents

When multiple LLMs run, disambiguate message sources: pass a `name` to each `create_agent`, specify `subgraphs=True` on the stream, and read `metadata.get("lc_agent_name")` in `messages` mode to know which agent emitted a token. The `name` is also attached to any `AIMessage`s that agent generates.

Source: [LangChain streaming](https://docs.langchain.com/oss/python/langchain/streaming) retrieved 2026-06-30, content hash `7f967e5c`.
