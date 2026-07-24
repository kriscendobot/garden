role: scholar
library_action: ingest-source
source_url: https://docs.fireworks.ai/
Continuation of Fireworks AI harness ingestion. Ingest the verified official child pages not covered by the core cycle: `serverless/pricing.md`, `serverless/serving-paths.md`, `tools-sdks/firectl/firectl.md`, `ecosystem/integrations/mlops-observability.md`, plus exact tool-calling and structured-output reference pages linked from `guides/querying-text-models.md`. Preserve source hashes and verify all child pages before writing. Cover current rates/serving selectors, CLI installation/sign-in practice, external observability integrations, and request/response schemas for tools and structured output. Do not make authenticated calls unless FIREWORKS_API_KEY is present; never print or persist it.
