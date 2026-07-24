---
title: OpenAI-compatible authentication, endpoint, and streaming contract
source_kind: web
source_url: https://docs.fireworks.ai/tools-sdks/openai-compatibility.md
source_content_sha256: 5af5434b13a157052a7fc0df0efb8833a84141d9f26d9ee71ca92f0b8ae36c99
source_authors: [Fireworks AI]
source_date: 2026-07-24
ingested: 2026-07-24
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Fireworks documents the OpenAI client base URL as `https://api.fireworks.ai/inference/v1` and authenticates with the Fireworks API key, including through `OPENAI_API_BASE` and `OPENAI_API_KEY` compatibility variables. Standard completions and chat completions use Fireworks model identifiers. If prompt plus `max_tokens` exceeds context, Fireworks defaults to `context_length_exceeded_behavior: "truncate"`; `"error"` requests an OpenAI-like invalid-request outcome. In streaming responses the final chunk, identified by a finish reason, carries `usage`; the documentation notes that OpenAI SDK types may not declare that extension. Never persist or print the key. The job credential is pending redeploy, so no authenticated request was attempted.

Source: [Fireworks OpenAI compatibility](https://docs.fireworks.ai/tools-sdks/openai-compatibility.md).
