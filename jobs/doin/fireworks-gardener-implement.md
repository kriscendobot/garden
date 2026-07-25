Implement a first-class Fireworks.ai-backed gardener worker kind in the garden repository.

Ground the implementation in the completed journal research under the fireworks-ai-integration topic and the jobs scholar-ingest-fireworks-ai-harness plus its follow-up. Follow the existing worker-kind spine and the cleric, hermit, and mystic provider harnesses as patterns. Add the worker-kind registry entry, handler/provider adapter for the OpenAI-compatible Fireworks endpoint, FIREWORKS_API_KEY credential plumbing that never logs or persists the secret, explicit model selection and routing eligibility, count setter and scaler/systemd integration, provider-specific availability/quota/retry classification, operator documentation, and focused regression tests.

Keep model identifiers and serving-path choices configurable rather than baking in volatile catalog assumptions. Preserve the monitoring and external-text safety boundaries. Validate all unauthenticated paths locally; if FIREWORKS_API_KEY is available after deployment, perform a minimal authenticated canary without exposing the key. Report any credential or model-selection decision that still requires the maintainer.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: hermit
  claimed_at: 2026-07-25T06:22:52Z
