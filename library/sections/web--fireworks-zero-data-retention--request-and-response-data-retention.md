---
title: Request and Response API data retention
source_kind: web
source_url: https://docs.fireworks.ai/guides/security_compliance/data_handling.md
source_content_sha256: 3b85fbe6726135975527838ad902016c2299eebf28a40ca8115aab4b1109cc07
source_authors: [Fireworks AI]
source_date: 2026-07-24
ingested: 2026-07-24
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Fireworks documents zero data retention by default for open-model prompts and generations: request data is volatile for the request, with prompt-cache data and KV cache potentially volatile for several minutes, and is not persistently logged without opt-in. Service metadata such as token counts is logged. The Responses API is a separate exception when `store=True` (the documented default): it retains prompts, model responses, and tool calls for 30 days; set `store=False` to opt out, and delete by `response_id` for immediate removal. A garden integration should therefore default to non-persistent request handling and explicitly set Responses storage behavior rather than rely on defaults.

Source: [Fireworks Zero Data Retention](https://docs.fireworks.ai/guides/security_compliance/data_handling.md).
