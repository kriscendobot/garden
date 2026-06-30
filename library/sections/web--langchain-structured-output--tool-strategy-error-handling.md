---
title: "LangChain structured output: ToolStrategy error handling and retries"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/structured-output
source_content_sha256: de77c57a14a983fe045f403b1320e28a8ef1c5ae5c3f3c14ba22a2583f40dd6f
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: Because a model generating structured output via tool calling can make mistakes, `ToolStrategy` provides an automatic retry mechanism: on a failure the agent feeds the error back as a `ToolMessage` and prompts the model to fix it. Two failure classes are caught by default — a `MultipleStructuredOutputsError` (the model called more than one structured-output tool when only one is expected) and a `StructuredOutputValidationError` (the generated data failed schema validation, e.g. a rating outside 1–5). The `handle_errors` parameter tunes the behavior across six shapes: `True` (default template), a custom message string (always retry with that text), a single exception type or a tuple of types (retry only on those, re-raise the rest), a callable returning a message (custom per-error handling), or `False` (no retry — all exceptions propagate). The `tool_message_content` parameter customizes the success message recorded in history when structured output is captured.

## Custom tool message content

`tool_message_content` overrides the message that appears in the conversation history when structured output is generated. Without it, the final tool message reads `Returning structured response: {...}`; with it, you supply your own (e.g. `"Action item captured and added to meeting notes!"`).

## Error handling

The agent retries automatically on two error classes, surfacing the error to the model as a `ToolMessage` ending in "Please fix your mistakes":

- **Multiple structured outputs** — the model calls several structured-output tools at once. The agent reports the error for each and the model retries with a single correct call.
- **Schema validation** — the structured output violates the schema (e.g. `rating: 10` against `le=5`). The validation error names the offending field and constraint, and the model retries with a conforming value.

## handle_errors strategies

```python
ToolStrategy(schema=ProductRating, handle_errors=True)   # default: catch all, default template
ToolStrategy(schema=ProductRating, handle_errors="Please provide a valid rating 1-5.")  # always this message
ToolStrategy(schema=ProductRating, handle_errors=ValueError)            # retry only on ValueError
ToolStrategy(schema=ProductRating, handle_errors=(ValueError, TypeError))  # retry only on these
ToolStrategy(schema=ProductRating, handle_errors=custom_error_handler)  # callable(Exception) -> str
ToolStrategy(schema=ProductRating, handle_errors=False)                 # no retry; all errors raised
```

- **`True`** — catch all errors with the default error template.
- **`str`** — always retry with this fixed tool message.
- **exception type / tuple** — only retry (with the default message) on those types; otherwise raise.
- **callable** — a function `(error) -> str` that returns the retry message; can branch on `isinstance(error, StructuredOutputValidationError)` vs `MultipleStructuredOutputsError`.
- **`False`** — disable retries; let every exception propagate.

Source: [LangChain structured output](https://docs.langchain.com/oss/python/langchain/structured-output) retrieved 2026-06-30, content hash `de77c57a`.
