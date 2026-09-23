---
title: Serverless token billing and current rate schedule
source_kind: web
source_url: https://docs.fireworks.ai/serverless/pricing.md
source_content_sha256: 400901c47d693b4285ff78fbf040db838713c869bd91d044c181bd84ca62c864
source_authors: [Fireworks AI]
source_date: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Fireworks bills Serverless text and vision inference separately for input, cached input, and output tokens, with all quoted prices measured in US dollars per one million tokens. The 2026-07-25 page lists, for example, Kimi K2.7 Code Standard at $0.95/$0.19/$4.00 and Priority at $1.425/$0.285/$6.00; the three numbers are input/cached-input/output. A dash in the Priority column means that model has no Priority path. Fast variants are separately priced variants, not a different billing dimension. Batch inference receives a 50% reduction on Serverless input and output pricing.

The listed fallback schedule for unlisted text or vision models is $0.10 per million tokens below 4B parameters, $0.20 for 4B to 16B, $0.90 above 16B, $0.50 for mixture-of-experts models through 56B, and $1.20 for mixture-of-experts models from 56.1B through 176B. These fallback prices apply equally to input and output and have no separate cached-input rate. Embeddings bill input only: $0.008 per million tokens through 150M parameters, $0.016 from 150M through 350M, and $0.10 for Qwen3 8B. Live model availability and prices can change, so an integration should treat this dated hash-pinned schedule as a snapshot and consult the official page before cost-sensitive deployment changes.

Source: [Fireworks Serverless Pricing](https://docs.fireworks.ai/serverless/pricing.md).
