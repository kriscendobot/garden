# Topic: Fireworks AI integration

> Abstract: Practical integration guidance for Fireworks AI inference: OpenAI-compatible authentication and endpoints, choosing serverless models or dedicated deployments, streaming and observability, capacity/error handling, and data-retention boundaries. This topic records documented provider behavior; application-level retry, secret handling, and model-selection policy are explicitly marked as integration synthesis.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [API, model discovery, and dedicated deployments](../sections/web--fireworks-text-models--api-models-and-deployments.md) | Fireworks official docs | OpenAI-compatible text APIs, model-library discovery, and dedicated deployment identifiers. |
| [Streaming, observability, and advanced capabilities](../sections/web--fireworks-text-models--streaming-observability-and-advanced-capabilities.md) | Fireworks official docs | Streaming usage/performance signals, dashboard limits, and the advanced-capability guide map. |
| [Configuration and inference error boundary](../sections/web--fireworks-text-models--configuration-and-inference-errors.md) | Fireworks official docs | Sampling defaults, token-limit behavior, and the provider error-code boundary. |
| [OpenAI-compatible authentication, endpoint, and streaming contract](../sections/web--fireworks-openai-compatibility--authentication-endpoint-and-streaming-contract.md) | Fireworks official docs | Endpoint, environment variables, context overflow behavior, and final-stream usage. |
| [Serverless operational and deployment boundaries](../sections/web--fireworks-serverless-overview--serverless-operational-and-deployment-boundaries.md) | Fireworks official docs | Serverless versus on-demand, billing, cache affinity, serving paths, and lifecycle notice. |
| [Adaptive capacity and retry semantics](../sections/web--fireworks-serverless-rate-limits--adaptive-capacity-and-retry-semantics.md) | Fireworks official docs | Per-account/model adaptive TPM limits, 429 backoff, and 503 load shedding. |
| [Request and Response API data retention](../sections/web--fireworks-zero-data-retention--request-and-response-data-retention.md) | Fireworks official docs | Zero retention for open-model inference and explicit Responses storage control. |
| [Serverless token billing and current rate schedule](../sections/web--fireworks-serverless-pricing--token-billing-and-current-rate-schedule.md) | Fireworks official docs | Hash-pinned 2026-07-25 Serverless pricing dimensions, rates, and batch discount. |
| [Serving path selectors and capacity tradeoffs](../sections/web--fireworks-serverless-serving-paths--selectors-and-capacity-tradeoffs.md) | Fireworks official docs | Standard, Priority, and Fast request selectors, eligibility, and throughput intent. |
| [CLI installation and account sign-in practice](../sections/web--fireworks-firectl--installation-and-account-sign-in-practice.md) | Fireworks official docs | Firectl install channels, interactive sign-in, account confirmation, and upgrade practice. |
| [External MLOps and observability integrations](../sections/web--fireworks-mlops-observability--external-integrations.md) | Fireworks official docs | Weights & Biases and MLflow Tracing integrations and their documented boundaries. |
| [Tool definition, call response, and result turn](../sections/web--fireworks-tool-calling--definition-call-response-and-result-turn.md) | Fireworks official docs | OpenAI-compatible tool schema, returned call fields, and multi-turn result exchange. |
| [Tool selection, streaming, and schema validation](../sections/web--fireworks-tool-calling--selection-streaming-and-schema-validation.md) | Fireworks official docs | `tool_choice`, streamed argument assembly, and supported schema-validation behavior. |
| [Response format request and response constraints](../sections/web--fireworks-structured-outputs--response-format-request-and-response-constraints.md) | Fireworks official docs | `response_format` JSON modes, prompt requirements, and truncation boundary. |
| [Schema references, reasoning tradeoff, and grammar mode](../sections/web--fireworks-structured-outputs--schema-references-reasoning-and-grammar-mode.md) | Fireworks official docs | JSON Schema pointer semantics, reasoning tradeoff, and grammar-mode fallback. |

## See also

- [`agent-fleet-orchestration`](agent-fleet-orchestration.md): the garden-side consumer of an inference provider.
- [`agent-conventions`](agent-conventions.md): safe runtime configuration and operational practice.
