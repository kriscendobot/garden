---
id: fireworks-ai-integration
aliases: [Fireworks AI, Fireworks API, FIREWORKS_API_KEY, api.fireworks.ai, OpenAI-compatible Fireworks, Fireworks serverless, Fireworks tool calling, Fireworks structured outputs, Firectl]
topics: [fireworks-ai-integration]
---

# Fireworks AI integration

**Fireworks AI integration** is an OpenAI-compatible inference-client configuration with `https://api.fireworks.ai/inference/v1`, a Bearer API key, and an explicitly selected Fireworks model or deployment identifier. It covers Serverless billing and serving selectors, tool-call and structured-output request/response schemas, the interactive Firectl account workflow, and observability integrations. The operational boundary is important: Serverless is shared, per-token, and model-lifecycle-managed; on-demand deployments are dedicated, GPU-hour capacity with version and replica control. A robust garden harness should treat model availability, price, and capacity as live provider data, preserve request-side correlation and response usage/performance metrics, retry 429s with exponential backoff, and distinguish 503 load shedding from a rate-limit guarantee. These last retry/selection recommendations are synthesis from the documented constraints, not a Fireworks contractual guarantee.

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
| [Serverless token billing and current rate schedule](../sections/web--fireworks-serverless-pricing--token-billing-and-current-rate-schedule.md) | Current hash-pinned token rates, fallback bands, embedding rates, and batch discount. |
| [Serving path selectors and capacity tradeoffs](../sections/web--fireworks-serverless-serving-paths--selectors-and-capacity-tradeoffs.md) | Standard default, Priority service tier, and Fast router-model selector. |
| [CLI installation and account sign-in practice](../sections/web--fireworks-firectl--installation-and-account-sign-in-practice.md) | Firectl installation and interactive account-session commands. |
| [External MLOps and observability integrations](../sections/web--fireworks-mlops-observability--external-integrations.md) | Weights & Biases and MLflow Tracing integration directory. |
| [Tool definition, call response, and result turn](../sections/web--fireworks-tool-calling--definition-call-response-and-result-turn.md) | Tool schema, tool-call fields, and the result-message return turn. |
| [Tool selection, streaming, and schema validation](../sections/web--fireworks-tool-calling--selection-streaming-and-schema-validation.md) | Selection modes, streamed fragments, and in-document schema references. |
| [Response format request and response constraints](../sections/web--fireworks-structured-outputs--response-format-request-and-response-constraints.md) | JSON-object and JSON-schema output request forms and limits. |
| [Schema references, reasoning tradeoff, and grammar mode](../sections/web--fireworks-structured-outputs--schema-references-reasoning-and-grammar-mode.md) | Pointer semantics, reasoning output tradeoff, and BNF grammar alternative. |

## See also

- [[model-routing]]
- [[agent-streaming]]
