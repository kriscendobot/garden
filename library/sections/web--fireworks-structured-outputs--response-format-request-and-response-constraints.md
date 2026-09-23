---
title: Response format request and response constraints
source_kind: web
source_url: https://docs.fireworks.ai/structured-responses/structured-response-formatting.md
source_content_sha256: 618edcfff37257fac189eea3382834a24a18d7e5ca8e8719fa5d30b647775f51
source_authors: [Fireworks AI]
source_date: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Structured output is requested through the OpenAI-compatible `response_format` field. `{"type": "json_object"}` forces valid JSON without a particular schema; `{"type": "json_schema", "json_schema": {"name": ..., "schema": ...}}` enforces a particular JSON Schema and is the recommended variant. The request prompt should also instruct the model to produce JSON and include the schema, because generation constraints do not make the schema visible to the model as task context. A `finish_reason` of `"length"` can still yield truncated, invalid JSON, so the caller must provision enough output tokens and validate the returned content.

JSON mode works on Chat Completions and Completions. Tool calling enables JSON mode automatically, so its separate JSON-mode prompt guidance does not apply. The documented schema behavior treats schemas with `properties` as though `unevaluatedProperties: false` were set, preventing hallucinated fields. This is provider behavior, not a substitute for application-level validation at a trust boundary.

Source: [Fireworks Structured Outputs](https://docs.fireworks.ai/structured-responses/structured-response-formatting.md).
