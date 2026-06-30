---
title: "LangChain models: advanced topics — profiles, multimodal, reasoning, caching, dynamic selection"
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
notes: "Living vendor docs (docs.langchain.com, Mintlify). Consolidates the page's many short Advanced-topics H3s into one reference section. Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA."
---

Abstract: A reference roundup of the model page's advanced topics, consolidated rather than split per-H3. **Model profiles**: a `profile` attribute exposes a dictionary of supported features/capabilities (max input tokens, image inputs, reasoning output, tool calling, etc.), powered largely by the open-source models.dev project plus LangChain augmentations, so applications can branch on capabilities dynamically. **Multimodal**: certain models process and return images, audio, and video via content blocks. **Reasoning**: many models do multi-step reasoning that can be surfaced; reasoning effort is sometimes tunable as tiers (`'low'`/`'high'`) or integer token budgets, and can be turned off. **Local models** run on your own hardware for privacy/cost. **Prompt caching** is engaged at three levels (implicit provider caching, provider-level explicit cache points, and LangChain middleware that caches stable system-prompt/tool content). **Server-side tool use** lets some providers run web search / code interpreters within one turn. Plus **rate limiting** (`rate_limiter`), **base URL / proxy** settings, **log probabilities** (`logprobs`), **token usage** metadata, **invocation config** (`RunnableConfig`), **configurable models** (`configurable_fields`), and **dynamic model selection** (runtime model choice via a `@wrap_model_call` middleware).

## Model profiles

LangChain chat models can expose a dictionary of supported features and capabilities through a `profile` attribute (e.g. `max_input_tokens`, `image_inputs`, `reasoning_output`, `tool_calling`). Much of this data is powered by the open-source [models.dev](https://github.com/sst/models.dev) project, augmented with additional fields for use with LangChain and kept aligned with the upstream project. Profile data lets applications work around model capabilities dynamically.

## Multimodal

Certain models can process and return non-textual data such as images, audio, and video; pass non-textual data by providing content blocks. (See the messages guide's multimodal section.)

## Reasoning

Many models perform multi-step reasoning to arrive at a conclusion, breaking complex problems into smaller steps. If supported, you can surface this reasoning to understand how the model reached its answer. You can sometimes specify the level of effort (categorical tiers like `'low'`/`'high'`, or integer token budgets) or request that reasoning be turned off entirely.

## Local models

LangChain supports running models locally on your own hardware — useful when data privacy is critical, for custom models, or to avoid cloud costs.

## Prompt caching

Many providers offer prompt caching to reduce latency and cost on repeat processing of the same tokens. Engage it at three levels:

- **Implicit provider caching** — providers automatically pass on savings on a cache hit, no configuration (e.g. OpenAI, Gemini).
- **Provider-level explicit controls** — manual cache points for greater control (e.g. OpenAI `prompt_cache_key`, Anthropic content-block `cache_control`, AWS Bedrock `cachePoint`).
- **LangChain middleware** — for agents, middleware caches stable system-prompt and tool content (e.g. `AnthropicPromptCachingMiddleware`, `BedrockPromptCachingMiddleware`).

Cache usage is reflected in the response's usage metadata.

## Server-side tool use

Some providers support server-side tool-calling loops: a model interacts with web search, code interpreters, etc. and analyzes results within a single conversational turn. The response message's content blocks include the invocation and result in a provider-agnostic format; there are no separate `ToolMessage` objects to pass back as in client-side tool calling.

## Other controls

- **Rate limiting** — chat models accept a `rate_limiter` to control request rate and avoid provider rate-limit errors.
- **Base URL and proxy** — configurable for providers implementing the OpenAI Chat Completions API.
- **Log probabilities** — set `logprobs` to return token-level likelihoods.
- **Token usage** — providers return usage info on the `AIMessage`; aggregate counts across an application via a callback or context manager.
- **Invocation config** — pass a `RunnableConfig` via `config` for run-time control of callbacks, metadata, and tracking.
- **Configurable models** — `configurable_fields` makes fields (model, provider by default) selectable at runtime.
- **Dynamic model selection** — choose the model at runtime based on current state and context (routing, cost optimization) by creating middleware with the `@wrap_model_call` decorator that modifies the model in the request.

Source: [LangChain models](https://docs.langchain.com/oss/python/langchain/models) retrieved 2026-06-30, content hash `a17630c0`.
