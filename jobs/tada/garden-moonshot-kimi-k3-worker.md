Implemented and pushed `8f7b35468d3a28842f1030f75129b232fdd44423` to `main2`.

Added explicit-model-only `kimi` workers (`moonshot`, `kimis`, `garden-kimi@`), Moonshot Codex configuration, isolated `kimi-k3` routing, launcher key forwarding, bounded activation runbook, and provisional dated catalog/rate-card facts. Kimi cannot claim unpinned work or default design/build roles.

Verification passed: worker spine (99), Kimi provider (7), routing (29), scaler (12), services (37), foreman provider (10), library links (42), full `bash -n`, CI-scoped shellcheck, and `tests/checks/run.sh`.

Operator follow-up after deploy: recreate the container with `MOONSHOT_API_KEY` set, run the status-only `/v1/models` probe, `scripts/jobs/set-kimis.sh 1`, run one explicit `model: kimi-k3` low-risk tool canary, inspect provider-scoped reputation, then scale back to zero.

Unresolved: live Codex-to-Moonshot chat-completions and K3 tool-call compatibility remain unverified pending the funded-key canary.

Self-improvement: nothing this time.
