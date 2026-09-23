---
title: "Built-in middleware: context management, cost limits, and resilience"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware/built-in
source_content_sha256: 1009bcd409a8e5ec4993d8a8e934427d9c9f456a4dc482f5a8e29aaa4de33937
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. This is one of two consolidated sections over the built-in-middleware catalog (a reference-shaped page); per-middleware H3 anchors are preserved inline for grep. Sibling: web--langchain-middleware-built-in--tools-safety-and-capabilities. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

Abstract: LangChain (and Deep Agents) ship a catalog of production-ready, configurable **prebuilt middleware** that work with any provider. This section consolidates the ones that **manage the context window and control loop cost / resilience**. `SummarizationMiddleware` compresses older conversation history into a text summary when a token/message/fraction `trigger` is met, preserving recent messages via `keep` (text-only — it does not compress multimodal payloads). `ContextEditingMiddleware` with `ClearToolUsesEdit` clears older tool outputs (keeping the most recent `keep`) once a token `trigger` is hit, optionally clearing tool-call inputs and excluding named tools. `ModelCallLimitMiddleware` caps model calls per-thread and per-run with `exit_behavior` `end`/`error`. `ToolCallLimitMiddleware` caps tool calls globally or per named tool, per-thread and per-run, with `exit_behavior` `continue`/`error`/`end`. `ModelFallbackMiddleware` tries alternate models in order when the primary fails. `ToolRetryMiddleware` and `ModelRetryMiddleware` retry failed tool/model calls with configurable exponential backoff (`max_retries`, `backoff_factor`, `initial_delay`, `max_delay`, `jitter`) and an `on_failure` policy (`return_message`/`continue`, `raise`/`error`, or a custom formatter). The full provider-agnostic catalog (also covering tool-shaping, safety, and capability middleware) is in the sibling section.

## Provider-agnostic catalog (the full table)

| Middleware | Purpose |
| --- | --- |
| Summarization | Summarize history near token limits. |
| Human-in-the-loop | Pause for human approval of tool calls. *(sibling section)* |
| Model call limit | Cap model calls to bound cost. |
| Tool call limit | Cap tool calls globally or per tool. |
| Model fallback | Fall back to alternate models on failure. |
| PII detection | Detect/handle PII. *(sibling section)* |
| To-do list | Task planning + tracking via `write_todos`. *(sibling section)* |
| LLM tool selector | LLM selects relevant tools first. *(sibling section)* |
| Tool retry | Retry failed tool calls with backoff. |
| Model retry | Retry failed model calls with backoff. |
| LLM tool emulator | Emulate tools with an LLM for testing. *(sibling section)* |
| Context editing | Trim/clear old tool uses. |
| Provider tool search | Defer tools behind server-side tool search. *(sibling section)* |
| Shell tool / File search / Filesystem / Subagent | Deep Agents capability tools. *(sibling section)* |

### Summarization

`SummarizationMiddleware(model, trigger, keep)` summarizes older messages when a `trigger` is met, keeping recent context. `trigger` is a `ContextSize` tuple (one threshold), a `TriggerClause` dict (multiple thresholds, AND), or a list of either (OR). Thresholds: `fraction` (0-1 of the model's context size, needs profile data), `tokens` (absolute), `messages` (count). `keep` specifies exactly one of `fraction`/`tokens`/`messages`. It is text-oriented compression: it does not resize image/audio/video payloads — store media externally and pass references. Deprecated params: `summary_prefix`, `max_tokens_before_summary`, `messages_to_keep` (use `summary_prompt`, `trigger=("tokens", ...)`, `keep=("messages", ...)`).

```python
SummarizationMiddleware(model="gpt-5.4-mini", trigger=("tokens", 4000), keep=("messages", 20))
```

### Context editing

`ContextEditingMiddleware(edits=[ClearToolUsesEdit(trigger=100000, keep=3)])` clears older tool outputs when the conversation exceeds `trigger` tokens, always preserving the most recent `keep` results. `ClearToolUsesEdit` options: `clear_at_least` (minimum tokens to reclaim), `clear_tool_inputs` (also blank the originating tool-call args), `exclude_tools` (never clear these), `placeholder` (text substituted for cleared outputs, default `[cleared]`). `token_count_method` is `approximate` or `model`.

### Model call limit

`ModelCallLimitMiddleware(thread_limit=10, run_limit=5, exit_behavior="end")` caps model calls across a thread (requires a checkpointer) and per run; `exit_behavior` is `end` (graceful) or `error` (raise).

### Tool call limit

`ToolCallLimitMiddleware` caps tool calls globally (no `tool_name`) or per named tool, with `thread_limit` (needs checkpointer) and `run_limit` (at least one required). `exit_behavior`: `continue` (default; block exceeded calls with error messages, let the model decide when to stop), `error` (raise `ToolCallLimitExceededError`), or `end` (stop with a `ToolMessage` + AI message — single-tool only, else `NotImplementedError`). Compose multiple limiters (one global, several per-tool).

### Model fallback

`ModelFallbackMiddleware("gpt-5.4-mini", "claude-3-5-sonnet-20241022")` tries each fallback in order when the primary model fails — for resilience to outages, cost optimization, and provider redundancy.

### Tool retry / Model retry

`ToolRetryMiddleware` and `ModelRetryMiddleware` retry failed calls with exponential backoff. Shared options: `max_retries` (default 2), `backoff_factor` (default 2.0; `0.0` = constant delay), `initial_delay` (1.0), `max_delay` (60.0), `jitter` (±25%, default true), `retry_on` (exception tuple or predicate). `on_failure`: tool default `return_message` (return a `ToolMessage` the LLM can handle) / `raise`; model default `continue` (return an `AIMessage` with the error) / `error`; or a custom callable returning the message string. `ToolRetryMiddleware` also takes a `tools` allowlist.

Source: [Built-in middleware](https://docs.langchain.com/oss/python/langchain/middleware/built-in) retrieved 2026-06-30, content hash `1009bcd4`.
