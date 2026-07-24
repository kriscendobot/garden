---
id: fireworks-ai-integration
aliases: [Fireworks AI, Fireworks API, FIREWORKS_API_KEY, api.fireworks.ai, OpenAI-compatible Fireworks, Fireworks serverless]
topics: [fireworks-ai-integration]
---

# Fireworks AI integration

**Fireworks AI integration** is an OpenAI-compatible inference-client configuration with `https://api.fireworks.ai/inference/v1`, a Bearer API key, and an explicitly selected Fireworks model or deployment identifier. The operational boundary is important: Serverless is shared, per-token, and model-lifecycle-managed; on-demand deployments are dedicated, GPU-hour capacity with version and replica control. A robust garden harness should treat model availability, price, and capacity as live provider data, preserve request-side correlation and response usage/performance metrics, retry 429s with exponential backoff, and distinguish 503 load shedding from a rate-limit guarantee. These last retry/selection recommendations are synthesis from the documented constraints, not a Fireworks contractual guarantee.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [API, model discovery, and dedicated deployments](../sections/web--fireworks-text-models--api-models-and-deployments.md) | OpenAI-compatible text APIs, model-library discovery, and dedicated deployment identifiers. |
| [Streaming, observability, and advanced capabilities](../sections/web--fireworks-text-models--streaming-observability-and-advanced-capabilities.md) | Streaming usage/performance signals, dashboard limits, and the advanced-capability guide map. |
| [Configuration and inference error boundary](../sections/web--fireworks-text-models--configuration-and-inference-errors.md) | Sampling defaults, token-limit behavior, and the provider error-code boundary. |
| [OpenAI-compatible authentication, endpoint, and streaming contract](../sections/web--fireworks-openai-compatibility--authentication-endpoint-and-streaming-contract.md) | Endpoint, environment variables, context overflow behavior, and final-stream usage. |
| [Serverless operational and deployment boundaries](../sections/web--fireworks-serverless-overview--serverless-operational-and-deployment-boundaries.md) | Serverless versus on-demand, billing, cache affinity, serving paths, and lifecycle notice. |
| [Adaptive capacity and retry semantics](../sections/web--fireworks-serverless-rate-limits--adaptive-capacity-and-retry-semantics.md) | Per-account/model adaptive TPM limits, 429 backoff, and 503 load shedding. |
| [Request and Response API data retention](../sections/web--fireworks-zero-data-retention--request-and-response-data-retention.md) | Zero retention for open-model inference and explicit Responses storage control. |

## See also

- [[model-routing]]
- [[agent-streaming]]
