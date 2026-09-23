---
title: "LangChain models: tool calling and structured output"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/models
source_content_sha256: a17630c0272faed4aa0d4e1d10f7641d0cb3f2457c537516c15e953bc6bc81d3
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Two model capabilities sit at the boundary between a raw model and an agent. **Tool calling**: a model can *request* to call tools (data fetches, web searches, code execution); you make tools available by binding them with `bind_tools`, after which the model may choose to call any bound tool. Crucially, the model only emits a tool-call *request* — when using a model standalone you must execute the tool and feed the result back yourself, whereas an agent's loop handles execution automatically. `tool_choice` can force a particular tool or any tool. Some providers also offer server-side built-in tools. **Structured output**: a model's response can be constrained to a given schema via three methods — `'json_schema'` (the provider's dedicated structured-output feature), `'function_calling'` (forcing a tool call shaped like the schema), and `'json_mode'` (a precursor that emits valid JSON described in the prompt). Pydantic schemas validate automatically; `TypedDict`/JSON Schema require manual validation; `include_raw=True` returns both the parsed value and the raw `AIMessage`.

## Tool calling

Models can request to call tools that perform tasks such as fetching data from a database, searching the web, or running code. A tool pairs a callable with a schema. To make defined tools available to a model, bind them with `bind_tools`; in subsequent invocations the model can choose to call any of the bound tools as needed.

When binding user-defined tools, the model's response includes a **request** to execute a tool. When using a model separately from an agent, it is up to you to execute the requested tool and return the result back to the model for use in subsequent reasoning. When using an agent, the agent loop handles the tool-execution loop for you.

By default the model has the freedom to choose which bound tool to use; you can force the choice with `tool_choice` to ensure the model uses either a particular tool or **any** tool from the list. Some providers also offer built-in tools (web search, code interpreters) executed server-side, enabled via model or invocation parameters.

## Structured output

Models can be requested to provide their response in a format matching a given schema, which is useful for ensuring the output can be easily parsed and used in subsequent processing. LangChain supports multiple schema types and methods for enforcing structured output. Key considerations:

- **Method parameter** — some providers support different methods:
  - `'json_schema'`: uses dedicated structured-output features offered by the provider.
  - `'function_calling'`: derives structured output by forcing a tool call that follows the given schema.
  - `'json_mode'`: a precursor to `'json_schema'` offered by some providers; generates valid JSON, but the schema must be described in the prompt.
- **Include raw** — set `include_raw=True` to get both the parsed output and the raw AI message.
- **Validation** — Pydantic models provide automatic validation; `TypedDict` and JSON Schema require manual validation.

Source: [LangChain models](https://docs.langchain.com/oss/python/langchain/models) retrieved 2026-06-30, content hash `a17630c0`.
