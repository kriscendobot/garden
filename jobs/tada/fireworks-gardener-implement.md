Implemented and pushed `2c21ea3f2c` to `main2`.

Added explicit-only `fireworker` Fireworks.ai provider, secret-safe credential handoff, configurable endpoint/model routing, retry/error classification, scaler integration, operator canary documentation, and regression coverage.

Validated: Fireworker harness (12 pass), API-key handoff (7 pass), model routing (29 pass), worker spine (127 pass).

Follow-up: maintainer must choose an explicit Fireworks model/deployment route; Priority serving-path support remains intentionally disabled pending a verified request-field adapter.
