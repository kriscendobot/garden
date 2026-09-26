Implemented and pushed `a1dd8984510f83c38f438f9aac5c5429ac5d3bbd` to `main2`.

- Added official Kimi Code-backed `mystic` worker kind, exact `model: kimi-k3` claiming, isolated per-job state/resume, marker gating, credential-safe injection, and zero-default operation.
- Added offline handler, routing, spine, scaler/unit, reputation, completion, and cleanup coverage.
- Messaged maintainer that deployment is ready. Live funded canary remains pending.

Verified: `kimi-provider-test` (18), `worker-spine-kinds-test` (101), `model-routing-test` (29), `scaler-desired-count-test` (12), `completion-signal-test`, `handler-orphan-reap-test` (15), `foreman-provider-order-test` (8).

Self-improvement: nothing this time.
