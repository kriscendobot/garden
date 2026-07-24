---
title: Streaming, observability, and advanced capabilities
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

For `stream=True`, Fireworks returns token deltas and documents closing the connection to stop ungenerated-token billing. Usage is returned on every non-streaming response and in the final streaming chunk. Non-streaming performance data is in response headers; streaming callers can request `perf_metrics_in_response` to receive metrics in the body. The usage dashboard reflects server-acknowledged requests, not pre-server connection failures or client retry attempts, while dedicated deployments can export Prometheus-style server metrics. Fireworks routes tool calling, JSON-schema structured outputs, Responses, predicted outputs, prompt caching, and batch inference to dedicated guides: their availability and detailed semantics need provider-page verification before a harness enables them.

Source: [Fireworks Text Models](https://docs.fireworks.ai/guides/querying-text-models.md).
