---
title: "LangChain models: the standard interface, initialization, and parameters"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/models
source_content_sha256: a17630c0272faed4aa0d4e1d10f7641d0cb3f2457c537516c15e953bc6bc81d3
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Models are the reasoning engine of an agent: they drive the decision-making process — which tools to call, how to interpret results, when to give a final answer — and the model choice directly bounds the agent's baseline reliability. LangChain's value proposition is a **standard interface** across all major providers via dedicated integration packages, each implementing the same interface so a provider can be swapped without rewriting application logic; new model names work immediately because provider packages pass model names directly to the provider's API. A model is used either **with an agent** (specified at `create_agent` time) or **standalone** (called directly for generation, classification, or extraction). The easiest standalone start is `init_chat_model("provider:model", **kwargs)`. Standard parameters (temperature, max tokens, etc.) vary by provider; **connection resilience** is built in — models retry up to 6 times with exponential backoff on network errors, 429s, and 5xx, but not on client errors like 401/404 (tune via `max_retries`/`timeout`).

## Models as the reasoning engine

Models are the reasoning engine of agents. They drive the agent's decision-making process, determining which tools to call, how to interpret results, and when to provide a final answer. The quality and capabilities of the chosen model directly impact the agent's baseline reliability and performance — some models are better at following complex instructions, others at structured reasoning, and some support larger context windows. Beyond text generation, many models also support tool calling, structured output, multimodality, and reasoning.

LangChain's standard model interfaces give access to many provider integrations, making it easy to experiment with and switch between models.

## Basic usage

A model can be used two ways:

1. **With agents** — specified dynamically when creating an agent (the `model=` parameter of `create_agent`).
2. **Standalone** — called directly, outside the agent loop, for tasks like text generation, classification, or extraction with no agent framework.

The same interface works in both contexts, so you can start simple and scale up to agent-based workflows.

### Initialize a model

The easiest way to get a standalone model is `init_chat_model` to initialize one from a chat-model provider of your choice.

### Supported providers and models

LangChain supports all major model providers through dedicated integration packages. Each provider package implements the same standard interface, so you can swap providers without rewriting application logic. **New model names work immediately — no LangChain update required — because provider packages pass model names directly to the provider's API.**

### Key methods

A chat model exposes the standard methods `invoke`, `stream`, and `batch` (see the *invocation* section), plus `bind_tools` for tool calling and `with_structured_output` for schema-constrained responses.

## Parameters

A chat model takes parameters that configure its behavior. The full set varies by model and provider, but standard ones include temperature, max output tokens, and similar. With `init_chat_model`, pass these as inline `**kwargs`.

### Connection resilience

LangChain chat models automatically retry failed API requests with exponential backoff. By default, models retry up to **6 times** for network errors, rate limits (429), and server errors (5xx). Client errors like 401 (unauthorized) or 404 are not retried. Adjust `max_retries` and `timeout` when creating a model, then pass that instance to `create_agent`, `create_deep_agent`, or call it standalone.

Source: [LangChain models](https://docs.langchain.com/oss/python/langchain/models) retrieved 2026-06-30, content hash `a17630c0`.
