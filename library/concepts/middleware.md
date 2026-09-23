---
id: middleware
aliases: [middleware, AgentMiddleware, create_agent middleware, before_model, after_model, before_agent, after_agent, wrap_model_call, wrap_tool_call, hook_config, can_jump_to, jump_to, dynamic_prompt, ExtendedModelResponse, ModelRequest, request.override, SummarizationMiddleware, ContextEditingMiddleware, ClearToolUsesEdit, ModelCallLimitMiddleware, ToolCallLimitMiddleware, ModelFallbackMiddleware, ToolRetryMiddleware, ModelRetryMiddleware, LLMToolSelectorMiddleware, ProviderToolSearchMiddleware, LLMToolEmulator, PIIMiddleware, TodoListMiddleware, write_todos, ShellToolMiddleware, FilesystemFileSearchMiddleware, FilesystemMiddleware, SubAgentMiddleware, prebuilt middleware, custom middleware]
topics: [llm-agent-frameworks, patterns, agent-conventions]
---

# middleware

In LangChain, **middleware** is the mechanism for tightly controlling what happens inside an agent's loop. Middleware is passed as a `middleware=[...]` list to `create_agent` and its hooks run *inside the compiled [[langgraph]]* that `create_agent` returns (not a separate runtime) — so the whole agent, middleware and all, can be embedded in a larger `StateGraph` as a node or subgraph. Two hook styles exist: **node-style** hooks (`before_agent` / `before_model` / `after_model` / `after_agent`) run sequentially at fixed points and update state by returning a dict the graph's reducers merge; **wrap-style** hooks (`wrap_model_call` / `wrap_tool_call`) run *around* each call, decide whether to invoke the handler zero (short-circuit), one, or many times (retry), and update state via an `ExtendedModelResponse` carrying a `Command`. Hooks can exit early with `{"jump_to": "end" | "tools" | "model"}` (declared via `can_jump_to`). Middleware is authored as decorators (single-hook: `@before_model`, `@wrap_model_call`, `@dynamic_prompt`, ...) or as `AgentMiddleware` subclasses (multiple hooks, sync+async, init-time config, plus `state_schema` / `tools` / `transformers` class attributes). Execution order is fixed: `before_*` first-to-last, `after_*` last-to-first, `wrap_*` nested (the first middleware wraps all others). LangChain and Deep Agents ship a **prebuilt catalog** (summarization, context editing, call limits, model fallback, tool/model retry, LLM tool selector, provider tool search, tool emulator, PII detection, human-in-the-loop, to-do list, shell tool, file search, filesystem, subagents) and a **custom-middleware** path for everything else. This is the "harness configuration" layer the [[langchain]] agent is built around.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [middleware overview and graph composition](../sections/web--langchain-middleware--overview-and-graph-composition.md) | What middleware controls; hooks run inside the compiled graph; embed the agent in a larger StateGraph. |
| [built-in: context, cost, and resilience](../sections/web--langchain-middleware-built-in--context-cost-and-resilience.md) | Summarization, context editing, model/tool call limits, model fallback, tool/model retry. |
| [built-in: tools, safety, and capabilities](../sections/web--langchain-middleware-built-in--tools-safety-and-capabilities.md) | Tool selector/search/emulator, HITL, PII, to-do, shell, file search, filesystem, subagents. |
| [custom: hooks, state, and execution order](../sections/web--langchain-middleware-custom--hooks-state-and-execution-order.md) | Node vs wrap hooks, state updates, decorators vs classes, execution order, agent jumps. |
| [custom: worked examples](../sections/web--langchain-middleware-custom--examples.md) | Dynamic prompt/model/tool selection, tool monitoring, Anthropic prompt caching. |
| [configuring the harness via middleware](../sections/web--langchain-agents--configure-the-harness-via-middleware.md) | The middleware catalog as the harness's support areas (from the agents page). |

## See also

- [[langchain]] — middleware is the configurable layer of the LangChain agent harness.
- [[langgraph]] — middleware hooks run inside the compiled LangGraph; `Command`/reducers are the state-update mechanism.
- [[human-in-the-loop]] — `HumanInTheLoopMiddleware` is the "steering" capability packaged as middleware.
- [[langgraph-store]] — the long-term store the filesystem/memory middleware route `/memories/` to.
