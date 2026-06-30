---
title: "LangChain tools: execution and return values"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/tools
source_content_sha256: a40a0dad0d7db34773b41d18074eec8e6f33c66305ab16b346e6df3679c10174
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: A tool's return value shapes what the agent does next. Return a **string** for plain human-readable text (converted to a `ToolMessage` the model reads; no state change); return an **object** (e.g. a dict) for structured data the model should inspect field-by-field (serialized as tool output; no direct state change); return **multimodal content blocks** when the model supports text+image+media in one tool result; or return a **`Command`** when the tool must update graph state (include a `ToolMessage` keyed by `runtime.tool_call_id` if the model should see the result, and use reducers for fields parallel tool calls may touch). Setting **`return_direct=True`** short-circuits the loop — the tool's output becomes the final response without another model call (effective only when *all* tools called in a turn are `return_direct`), giving deterministic unmodified output. In an agent, tool **error handling** is configured through middleware (retry or custom error messages), not try/catch in the tool body; LangGraph workflows handle execution through `ToolNode`.

## Tool execution

In LangChain, tools are used by agents (e.g. via `create_agent`) and tool error handling is configured through middleware. For LangGraph workflows, tool execution is handled by `ToolNode` (which also lets tools access the current graph state and run-scoped context).

## Tool return values

You can choose different return values:

- **Return a `string`** for human-readable results. The return value is converted to a `ToolMessage`; the model sees that text and decides what to do next. No agent state fields change unless the model or another tool does so later. Use when the result is naturally human-readable text.
- **Return an `object`** (e.g. a dict) for structured data the model should inspect. The object is serialized and sent back as tool output; the model can read specific fields and reason over them. Like string returns, this does not directly update graph state. Use when downstream reasoning benefits from explicit fields over free-form text.
- **Return multimodal content.** When the model supports multimodal tool results, return standard content blocks so the model receives text, images, and other media in one result. The return value becomes a `ToolMessage` with multimodal `content`; read the normalized list via `message.content_blocks`. The model must support the modalities returned.
- **Return a `Command`** when the tool needs to update graph state (e.g. setting user preferences or app state). Optionally include a `ToolMessage` (keyed by `runtime.tool_call_id`) so the model sees the tool succeeded. The command updates state via `update`; updated state is available to subsequent steps in the same run; use reducers for fields that parallel tool calls may update.

### Return directly from a tool

Set `return_direct` on a tool to short-circuit the agent loop: the agent returns the tool's output to the caller immediately, without sending it back through the model. The tool executes normally and its output is wrapped in a `ToolMessage`, but the agent stops looping and returns that output as the final response, bypassing any additional model call. If the model calls multiple tools in a single turn, `return_direct` takes effect only when **all** called tools have `return_direct=True`. Use this when the tool's output is the complete, user-ready answer, when you want to avoid an extra model call, or when you need deterministic, unmodified output (the model cannot rephrase, summarize, or act on the result).

## Error handling and state injection

Handle tool errors using LangChain agent middleware to retry failed tool calls or return custom error messages. Tools access graph state through `ToolRuntime` (see *accessing context via ToolRuntime* for state, context, store, and streaming APIs).

Source: [LangChain tools](https://docs.langchain.com/oss/python/langchain/tools) retrieved 2026-06-30, content hash `a40a0dad`.
