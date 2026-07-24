role: scholar
library_action: ingest-source
source_url: https://fireworks.ai/
credential_status: FIREWORKS_API_KEY pending redeploy

Survey and ingest the current official Fireworks AI documentation needed to harness the service from the garden. Cover authentication and endpoint conventions, OpenAI-compatible APIs, supported inference modes and model discovery, streaming and structured/tool-call behavior, deployment/serverless distinctions, rate limits, pricing and operational constraints, SDK/CLI examples, error handling, observability, and security guidance. Focus on actionable provider-integration knowledge while distinguishing documented guarantees from synthesis. FIREWORKS_API_KEY will enter the environment only after a redeploy: do not block read-only documentation ingestion on its absence, do not attempt authenticated calls until it is present, and never print or persist the credential. Check existing library coverage first, preserve exact provenance, verify reachable official child pages, run the integrity gate, and post precisely scoped follow-on scholar jobs if the documentation exceeds one cycle.
