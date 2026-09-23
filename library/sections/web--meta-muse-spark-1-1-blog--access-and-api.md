---
title: "Muse Spark 1.1 access: the Meta Model API, auth, and rate/cost shape"
source_kind: web
source_url: https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/
source_content_sha256: 12f0e1c902b8a95460949f264882179027144bd527b6cb17f59c01413722cc03
source_authors: [Meta Superintelligence Labs]
source_date: 2026-07-09
ingested: 2026-07-10
ingested_by: scholar
topics: [frontier-model-apis]
status: current
---

## Abstract

How Muse Spark 1.1 is reached and on what terms: the new **Meta Model API** (public preview), described by Meta as **OpenAI-compatible**; also available in "Thinking" mode in the Meta AI app and at meta.ai. The cost/token/rate-limit shape the garden's token-spend concerns need is only partly stated — Meta's post gives no pricing or rate numbers; the concrete rate-limit mechanics come from the plugin README (an output-token rate limit charged before a request runs; per-model 429s that can mean "not enabled for your team").

## API access

Muse Spark 1.1 is available through the new **Meta Model API** (public preview), which Meta describe as **"OpenAI-compatible"** for developer integration. Credentials are a Meta AI API key (developer portal at `developer.meta.com/ai/`). This is the first Spark model offered through an API at all (Muse Spark 1.0 powered Meta AI but had no developer API).

## Non-API surfaces

The model is also accessible in **"Thinking" mode** inside the Meta AI app and at **meta.ai** — consumer surfaces, not programmatic ones.

## Cost, token, and rate-limit shape

Meta's launch post states **no pricing, token cost, or rate-limit numbers**. What is known about the rate/cost shape comes from the plugin README (the [invocation-and-features](../sections/web--simonw-llm-meta-ai--invocation-and-features.md) section):

- Requests count against an **output-token rate limit** *before* they run, so callers set `max_tokens` to avoid exhausting quota.
- Rate limits are **per model**; a persistent 429 can mean the model is **not enabled for your team**, even if it appears in the model list — i.e. availability is gated, consistent with a public *preview*.
- These are **reasoning models**: reasoning tokens count against the output-token budget, so agentic tool loops (which re-invoke the model per turn) spend reasoning tokens each turn.

For the garden this is the salient shape: a preview API with per-team gating and an output-token budget, distinct from the fleet's current Claude Max subscription model, and a direct input to the token-spend reasoning in [[muse-spark-garden-worker-fit]] and the `coding-agent-economics` topic.

Source: [Introducing Muse Spark 1.1 and the Meta Model API](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/) by Meta Superintelligence Labs, published 2026-07-09; content SHA-256 `12f0e1c902b8a95460949f264882179027144bd527b6cb17f59c01413722cc03`.
