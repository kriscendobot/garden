---
title: "Custom middleware: worked examples (dynamic prompt, model/tool selection, monitoring, caching)"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware/custom
source_content_sha256: 7313334a4204f63b0804d6c77c82e3f2d4218960555d0e846e159d8be0ebf0e9
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30). Sibling: web--langchain-middleware-custom--hooks-state-and-execution-order."
---

Abstract: Five canonical custom-middleware patterns, all using `wrap_model_call` / `wrap_tool_call` and `request.override(...)`. **Dynamic prompt** (the most common use case): in `wrap_model_call`, read `request.system_message` (always a `SystemMessage`, even when the agent was created with a string `system_prompt`), append new content blocks, and call `handler(request.override(system_message=...))` to inject runtime context. **Dynamic model selection**: choose a model based on the request (e.g. a stronger model once `len(request.messages) > 10`) and `request.override(model=...)`. **Dynamic tool selection**: compute a relevant subset of the pre-registered tools and `request.override(tools=relevant)` — shorter prompts, better accuracy, permission control (all tools must still be registered up front on `create_agent`). **Tool-call monitoring**: in `wrap_tool_call`, log `request.tool_call['name']`/`['args']` around `handler(request)`. **Prompt caching (Anthropic)**: append a content block carrying `"cache_control": {"type": "ephemeral"}` to the system message so content up to that point is cached. The recurring discipline: work through `SystemMessage.content_blocks` (not raw strings) and append rather than replace, to preserve existing structure.

## Dynamic prompt

```python
@wrap_model_call
def add_context(request: ModelRequest, handler) -> ModelResponse:
    new_content = list(request.system_message.content_blocks) + [
        {"type": "text", "text": "Additional context."}
    ]
    return handler(request.override(system_message=SystemMessage(content=new_content)))
```

`ModelRequest.system_message` is always a `SystemMessage` object even if the agent was created with `system_prompt="string"`. Use `content_blocks` to read content as a list regardless of original form, and append blocks to preserve structure. (The `@dynamic_prompt` convenience decorator wraps this pattern.)

## Dynamic model selection

```python
@wrap_model_call
def dynamic_model(request: ModelRequest, handler) -> ModelResponse:
    model = complex_model if len(request.messages) > 10 else simple_model
    return handler(request.override(model=model))
```

## Dynamically selecting tools

```python
@wrap_model_call
def select_tools(request: ModelRequest, handler) -> ModelResponse:
    relevant_tools = select_relevant_tools(request.state, request.runtime)
    return handler(request.override(tools=relevant_tools))
```

All available tools must be registered up front on `create_agent(tools=all_tools, ...)`; the middleware filters per call. Benefits: shorter prompts, better model accuracy from fewer options, and permission control. (For registering tools discovered at runtime — e.g. from MCP servers — see the tools page's runtime tool registration.)

## Tool call monitoring

```python
@wrap_tool_call
def monitor_tool(request: ToolCallRequest, handler) -> ToolMessage | Command:
    print(f"Executing tool: {request.tool_call['name']}")
    print(f"Arguments: {request.tool_call['args']}")
    result = handler(request)
    print("Tool completed successfully")
    return result
```

## Prompt caching (Anthropic)

Append a content block with a cache-control directive so content up to that point is cached across calls:

```python
@wrap_model_call
def add_cached_context(request: ModelRequest, handler) -> ModelResponse:
    new_content = list(request.system_message.content_blocks) + [
        {"type": "text", "text": "<large document>", "cache_control": {"type": "ephemeral"}}
    ]
    return handler(request.override(system_message=SystemMessage(content=new_content)))
```

Source: [Custom middleware](https://docs.langchain.com/oss/python/langchain/middleware/custom) retrieved 2026-06-30, content hash `73133342`.
