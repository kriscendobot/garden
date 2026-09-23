Implemented and pushed `dfb21011cc` to `main2`.

- Added `GARDEN_FOREMAN_PROVIDER_ORDER`; default remains `anthropic`, temporary order supports `openai,local,anthropic`.
- Reused shared Codex/Ollama auth, routing, effort, and endpoint configuration.
- Added safe fallback on provider/quota failures; malformed output is rejected without fallback/posting.
- Documented restoring Claude-only order next week.
- Added deterministic provider-order tests.

Verified: provider test (8 pass), foreman notice test (6 pass), model-routing test (24 pass), syntax and diff checks.

Follow-up: re-verify Codex/Ollama CLI flags on the live GPU host before first live local invocation.
