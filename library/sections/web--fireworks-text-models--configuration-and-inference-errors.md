---
title: Configuration and inference error boundary
source_kind: web
source_url: https://docs.fireworks.ai/guides/querying-text-models.md
source_content_sha256: ebe68dc6fdd2d2ce50d64ef385103d6aec28003eac9c7f0ae603c4ad8fc22d51
source_authors: [Fireworks AI]
source_date: 2026-07-24
ingested: 2026-07-24
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Fireworks applies a model's Hugging Face generation configuration when sampling parameters are omitted, and exposes the effective settings in `fireworks-sampling-options`. It documents a default `max_tokens` of 2048, model-context-window limits, and `finish_reason: "length"` for token-limit truncation. The text-model guide points callers to the inference-error-code guide for resolution of inference failures. A production harness should record finish reasons and provider error data and make retry eligibility status-specific; that policy is synthesis, not specified by this overview page.

Source: [Fireworks Text Models](https://docs.fireworks.ai/guides/querying-text-models.md).
