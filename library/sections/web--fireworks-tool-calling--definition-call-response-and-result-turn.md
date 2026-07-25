---
title: Tool definition, call response, and result turn
source_kind: web
source_url: https://docs.fireworks.ai/guides/function-calling.md
source_content_sha256: eeeb8a9b3182bc67645d67dbb402007350b700433a93ebc163300c7a95526029
source_authors: [Fireworks AI]
source_date: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Tool calling uses an OpenAI-compatible `tools` array. Each entry has `type: "function"` and a `function` object containing a 64-character-max identifier (letters, digits, underscores, or dashes), a descriptive string, and a JSON Schema `parameters` object. The model may return `message.tool_calls`, whose entries carry a call `id`, `type`, `function.name`, and JSON-encoded `function.arguments`. Tool definitions, parameter descriptions, enums, and required fields are part of the model-facing contract rather than merely local validation metadata.

The application owns execution. It validates and parses the returned arguments, runs the selected external action, appends the assistant message containing the tool call, then appends a `role: "tool"` message with the matching `tool_call_id` and serialized result before issuing the next completion request. This means a harness must preserve call IDs and the complete assistant tool-call message, validate argument JSON before use, and treat the tool result as untrusted application input rather than executing a model-selected action directly.

Source: [Fireworks Tool Calling](https://docs.fireworks.ai/guides/function-calling.md).
