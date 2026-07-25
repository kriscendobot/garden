Ingested six verified official Fireworks documentation pages into the `fireworks-ai-integration` topic: Serverless pricing, serving paths, Firectl, MLOps/observability, Tool Calling, and Structured Outputs.

Each page was fetched directly before writing and records its SHA-256 web-source anchor. The exact Tool Calling and Structured Outputs child pages were discovered from and verified against the Text Models guide. The eight new section files cover current token rates and selectors, interactive CLI installation/sign-in practice, W&B and MLflow integrations, tool request/call/result and streaming schemas, and structured-output response-format/schema behavior.

Updated the source index, topic, concept, and keyword lookup entries. No authenticated Fireworks calls were made and no API key was read, printed, or persisted.

Verification: `library-link-check.sh` resolved the six source clusters against the committed journal content; `regenerate-topics-counts.sh --check` reported current; `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` reported their generated indexes current.

Deferred backlog: none.

Self-improvement: none.
