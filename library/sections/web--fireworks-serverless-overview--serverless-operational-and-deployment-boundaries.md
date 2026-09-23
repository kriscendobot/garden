---
title: Serverless operational and deployment boundaries
source_kind: web
source_url: https://docs.fireworks.ai/serverless/overview.md
source_content_sha256: 68db6776b4cd751a85919307ff400c300149a123eb435784b8bd8321713a346e
source_authors: [Fireworks AI]
source_date: 2026-07-24
ingested: 2026-07-24
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Serverless is Fireworks-managed multi-tenant inference for model-library entries tagged Serverless, billed per input, cached-input, and generated token. Standard is the default path, Priority is selected by `service_tier: "priority"` where supported, and Fast is selected by a Fast model ID. `usage` is the billing source of truth. Prompt caching is enabled by default; use a stable `x-session-affinity` key, or OpenAI `user`, to improve replica-local cache reuse. Fireworks states at least two weeks notice before a Serverless model removal, but recommends on-demand for long-term model-version stability. On-demand is dedicated GPU-hour capacity with custom base-model or LoRA support and direct control of replicas and latency posture.

Source: [Fireworks Serverless Overview](https://docs.fireworks.ai/serverless/overview.md).
