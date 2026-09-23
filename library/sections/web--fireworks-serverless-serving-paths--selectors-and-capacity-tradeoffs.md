---
title: Serving path selectors and capacity tradeoffs
source_kind: web
source_url: https://docs.fireworks.ai/serverless/serving-paths.md
source_content_sha256: 36176ff8c5022bfb0aec029f66dfff6d73021366e2977adbff3bda2715988d0d
source_authors: [Fireworks AI]
source_date: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Standard is the default Serverless path and needs no `service_tier` request parameter. Priority is selected by setting `service_tier` to `"priority"` on OpenAI-compatible chat completions or Anthropic-compatible messages requests. It is priced higher, scheduled ahead of Standard traffic, and documented as less likely to be load shed with a 503 response during peak traffic; it is only available for models shown as Priority-capable in the pricing table.

Fast is selected through a Fast router model identifier rather than `service_tier`, such as `accounts/fireworks/routers/kimi-k2p6-fast`, `.../glm-5p2-fast`, or `.../glm-5p1-fast` in the captured reference. Fireworks describes Fast as the same model quality with a target of more than 100 generated tokens per second for eligible interactive workloads, at a higher price. A caller must therefore preserve the requested model identifier and service-tier field in its request schema, and should not infer Priority availability from the existence of a Fast variant.

Source: [Fireworks Serverless Serving Paths](https://docs.fireworks.ai/serverless/serving-paths.md).
