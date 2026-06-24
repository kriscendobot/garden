---
title: Multi-format tool-call normalization
source: packages/fae/src/extract-tool-calls.js
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/src/extract-tool-calls.js
source_line_range: 1-188
source_commit: db3739ef53f582422fb8bc031befa954c187db26
source_date: 2026-04-09
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [agent-conventions, daemon]
status: current
---

188-line `packages/fae/src/extract-tool-calls.js` — the model-agnostic tool-call extraction layer for the Fae agent. A single exported function `extractToolCallsFromContent` normalizes LLM assistant text across THREE wire formats into a uniform `ChatMessage['tool_calls']` array, then returns cleaned content stripped of tool-call markup and chain-of-thought `<think>` blocks. This is the response-side counterpart to cycle 416's tool-discovery pipeline: where tools.js surfaces capabilities TO the LLM, extract-tool-calls.js interprets what the LLM sends BACK.

## Multi-format tool-call normalization

`extractToolCallsFromContent(content)` handles three distinct wire formats emitted by different LLM backends:

1. **Standard JSON inside `<tool_call>` tags**: `<tool_call>{"name":"foo","arguments":{...}}</tool_call>`. Parsed via `JSON.parse`; the most common path for OpenAI-API-compatible models.

2. **Qwen XML parameter format inside `<tool_call>` tags**: `<tool_call><function=name><parameter=key>value</parameter>...</function></tool_call>`. Handled by `parseFunctionParamFormat`; dispatched when JSON parse fails. Qwen models emit this format.

3. **Bare `<function=name>` blocks outside `<tool_call>` tags**: some models emit function calls without the enclosing `<tool_call>` wrapper. Handled in a second pass over content-with-tool-calls-removed.

The extraction is two-pass: first pass extracts `<tool_call>...</tool_call>` blocks (including those nested inside `<think>` blocks); second pass extracts bare `<function=name>` blocks from the remaining content.

Within the JSON path, `arguments` is normalized: if it is already a string it is used as-is; if it is an object it is re-serialized with `JSON.stringify`. Within the XML path, `parseParamValue` applies typed coercion: JSON.parse for arrays/objects/booleans/null, regex for numbers, fallback to trimmed string. Both paths produce the same `{ id, type, function: { name, arguments } }` shape.

The `<think>...</think>` block stripping handles chain-of-thought reasoning output from models that emit internal reasoning before tool calls. Both closed (`<think>...</think>`) and unclosed (`<think>...` with no closing tag) variants are stripped. The result is that tool calls inside a `<think>` block are still extracted correctly (they are captured by the first-pass regex), but their surrounding reasoning text is removed from `cleanedContent`.

A fallback within the JSON parse catch applies a last-resort regex: `/"name"\s*:\s*"([^"]+)"` and `/"arguments"\s*:\s*(\{[\s\S]*\})`. This handles malformed JSON where the structure is recoverable but JSON.parse rejects it outright.

Tool call IDs are generated as `tool_${Date.now()}_${index}` — synthetic, timestamp-based, monotonically ordered within one content extraction call. The index increments across both passes so IDs are unique per extraction.

`harden(extractToolCallsFromContent)` at line 188 follows the project-wide harden-exports convention.

Source: [packages/fae/src/extract-tool-calls.js](https://github.com/endojs/endo-but-for-bots/blob/db3739ef53f582422fb8bc031befa954c187db26/packages/fae/src/extract-tool-calls.js) at commit `db3739e`.
