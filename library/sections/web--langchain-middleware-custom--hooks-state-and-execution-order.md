---
title: "Custom middleware: hooks, state updates, creation, and execution order"
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
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30). Sibling: web--langchain-middleware-custom--examples."
---

Abstract: Custom middleware implements hooks at specific points in the agent execution flow, in two styles. **Node-style hooks** run sequentially at fixed points — `before_agent` / `after_agent` (once per invocation) and `before_model` / `after_model` (around each model call) — and update state by returning a dict that the graph's reducers merge. **Wrap-style hooks** — `wrap_model_call` and `wrap_tool_call` — run *around* each call and decide whether to call the handler zero times (short-circuit), once (normal), or many times (retry); they update state by returning an `ExtendedModelResponse` carrying a `Command` (model calls) or a `Command` directly (tool calls). Middleware is created as decorators (quick, single-hook: `@before_model`, `@after_model`, `@wrap_model_call`, `@wrap_tool_call`, `@before_agent`, `@after_agent`, plus the convenience `@dynamic_prompt`) or as `AgentMiddleware` subclasses (multiple hooks, sync+async via `abefore_model`/`aafter_model`, init-time config, and three class attributes: `state_schema`, `tools`, `transformers`). Middleware can extend agent state with a custom `AgentState` subclass to track counters/flags across hooks, and can register stream-transformer factories (`transformers`, needs `langchain>=1.3.2`). Execution order is well-defined: `before_*` hooks run first-to-last, `after_*` run last-to-first (reverse), and `wrap_*` hooks nest like function calls (the first middleware wraps all others). Any hook can exit early by returning `{"jump_to": ...}` with target `end`, `tools`, or `model` (declare it via `can_jump_to`).

## The two hook styles

**Node-style** (sequential; for logging, validation, state updates):

| Hook | When it runs |
| --- | --- |
| `before_agent` | Before agent starts (once per invocation) |
| `before_model` | Before each model call |
| `after_model` | After each model response |
| `after_agent` | After agent completes (once per invocation) |

**Wrap-style** (around each call; for retries, caching, transformation):

| Hook | When it runs |
| --- | --- |
| `wrap_model_call` | Around each model call |
| `wrap_tool_call` | Around each tool call |

A wrap-style hook receives `(request, handler)` and decides how many times to call `handler` — zero (short-circuit), once, or many (retry):

```python
@wrap_model_call
def retry_model(request: ModelRequest, handler) -> ModelResponse:
    for attempt in range(3):
        try:
            return handler(request)
        except Exception as e:
            if attempt == 2:
                raise
            print(f"Retry {attempt + 1}/3 after error: {e}")
```

## State updates

- **Node-style hooks** return a dict; keys map to state fields and are applied through the graph's reducers (messages additive).
- **Wrap-style model hooks** return `ExtendedModelResponse(model_response=response, command=Command(update={...}))`; the `Command` flows through reducers. Wrap-style tool hooks return a `Command` directly. Use when an update depends on logic during the call (summarization trigger points, usage metadata, computed fields).

When multiple middleware return `ExtendedModelResponse`, commands compose: each becomes a separate reducer-applied update (messages additive); for non-reducer fields commands apply **inner-first then outer, so the outermost middleware wins on conflicts**; and if an outer middleware calls `handler()` multiple times (retry), commands from earlier calls are discarded (retry-safe).

## Creating middleware

**Decorators** — quick, single-hook, no complex config: `@before_agent`, `@before_model`, `@after_model`, `@after_agent`, `@wrap_model_call`, `@wrap_tool_call`, and the convenience `@dynamic_prompt`.

**Classes** — `AgentMiddleware` subclasses for multiple hooks, both sync and async implementations of the same hook (`abefore_model`, `aafter_model`, ...), init-time configuration, and reuse. Three class attributes are picked up at compile time: `state_schema` (extend agent state), `tools` (register tools that ship with the middleware, e.g. `write_todos`), and `transformers` (scope-aware stream-transformer factories).

## Custom state schema

Middleware extends the agent's state with a custom `AgentState` subclass to track counters/flags across hooks, share data between hooks or middleware, implement cross-cutting concerns (rate limiting, usage tracking, audit logging), and make conditional decisions. Pass `state_schema=CustomState` to the decorator (or set the class attribute) and invoke the agent with the extra keys.

## Custom stream transformers

Set the `transformers` class attribute to a tuple of factory callables (`Callable[[tuple[str, ...]], StreamTransformer]`, invoked as `factory(scope)` where `scope` is `()` for the root and non-empty for subgraphs) to project live-stream events onto typed extension channels (counters, side-channel artifacts, wire-level redaction) without coupling to the built-in projections. Requires `langchain>=1.3.2`; factories merge with caller-supplied ones at compile time, the built-in `ToolCallTransformer` staying first.

## Execution order

For `middleware=[m1, m2, m3]`: `before_agent`/`before_model` run `m1 → m2 → m3`; `wrap_model_call` nests `m1(m2(m3(model)))`; `after_model`/`after_agent` run `m3 → m2 → m1` (reverse). Rules: `before_*` first-to-last, `after_*` last-to-first, `wrap_*` nested (first middleware wraps all others).

## Agent jumps

Return `{"jump_to": target}` to exit early. Targets: `'end'` (end of execution / first `after_agent`), `'tools'` (tools node), `'model'` (model node / first `before_model`). Declare the capability with `can_jump_to=[...]` on the decorator or `@hook_config`.

## Best practices

Keep middleware focused; handle errors gracefully so they do not crash the agent; node-style for sequential logic, wrap-style for control flow; document custom state properties; unit-test middleware in isolation; order matters (critical middleware first); prefer built-in middleware when one fits.

Source: [Custom middleware](https://docs.langchain.com/oss/python/langchain/middleware/custom) retrieved 2026-06-30, content hash `73133342`.
