---
title: Tool selection, streaming, and schema validation
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

`tool_choice` controls selection: `auto` is the default, `none` disables calls, `required` requires at least one call, and a function selector forces one named function. Some models support parallel tool calls, but the guide requires checking model capabilities before depending on that behavior. For streamed calls, tool-call IDs, names, and argument fragments arrive through `delta.tool_calls`; the caller accumulates arguments by call index and acts only after `finish_reason` is `"tool_calls"` and each assembled argument string has been parsed and validated.

Tool `parameters` support the same documented JSON Schema feature set as structured responses, including primitive and composite types, constraints, `$defs` or `definitions`, in-document `$ref`, recursion, and annotations. External `$ref` URIs are unsupported. The guide recommends low temperature (0.0 to 0.3), detailed descriptions, constrained enums, and defensive JSON parsing. A 400 schema-reference error can indicate an invalid pointer, an external reference, or an older dedicated image that lacks newer recursive or nested-definition support.

Source: [Fireworks Tool Calling](https://docs.fireworks.ai/guides/function-calling.md).
