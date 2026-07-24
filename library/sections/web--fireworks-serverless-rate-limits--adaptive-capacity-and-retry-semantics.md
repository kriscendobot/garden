---
title: Adaptive capacity and retry semantics
source_kind: web
source_url: https://docs.fireworks.ai/serverless/rate-limits.md
source_content_sha256: a3f582b246a27b8899669e870dd04609cd69fb50dd9f6e0441e24a597d3b74f2
source_authors: [Fireworks AI]
source_date: 2026-07-24
ingested: 2026-07-24
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Serverless rate limits are adaptive and scoped per account and per model. Fireworks measures total prompt TPM, uncached prompt TPM, and generated TPM, enforcing TPM rather than TPS; it publishes default ceilings of 21.6M, 5.4M, and 216k TPM respectively. Fast and regular variants have separate limits, while Priority and regular traffic share the same model limit. Read the `X-Ratelimit-Limit-Tokens-*` headers for effective limits. A 429 means the client needs to remain under adaptive capacity and Fireworks explicitly recommends exponential backoff. Staying under a limit does not guarantee success: busy deployments may load-shed with 503, and Priority only reduces that likelihood.

Source: [Fireworks Serverless Rate Limits](https://docs.fireworks.ai/serverless/rate-limits.md).
