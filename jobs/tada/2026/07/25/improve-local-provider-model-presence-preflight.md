Implemented and pushed `a6899eda05` to `main2`.

- Added local `/v1/models` presence gate with actionable `ollama pull <model>` diagnostic.
- Resolved models before preflight in cleric; foreman now skips empty local providers.
- Added hermit and foreman empty-model-list coverage.

Verified: targeted harnesses pass; broader jobs test suite passes.
