---
title: API, model discovery, and dedicated deployments
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

Fireworks documents chat completions as the recommended OpenAI-compatible text inference surface, with completions and Responses as alternatives. The official model library is the discovery surface for 100+ models, their context windows, and Serverless eligibility. Use a base-model identifier such as `accounts/fireworks/models/deepseek-v3p1`; use `accounts/<ACCOUNT_ID>/deployments/<DEPLOYMENT_ID>` for a dedicated deployment. The provider documents dedicated deployments as the choice for consistent performance, guaranteed capacity, or higher throughput. Selecting a particular model from live availability, cost, and capability data is an integration decision rather than a documented stability guarantee.

Source: [Fireworks Text Models](https://docs.fireworks.ai/guides/querying-text-models.md).
