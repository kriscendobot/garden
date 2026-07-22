Implemented and pushed `d25cb4eb3f`.

- Added 60s wrapper backoff for duplicate endpoint, missing binary, and all child exits.
- Preserved SIGTERM/SIGINT clean exits.
- Restored shared Ollama host derivation helper.
- Added regression tests: 11 new cases pass; existing hermit test: 16 pass.
