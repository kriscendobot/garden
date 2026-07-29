---
gate: orchestrated
orchestrated_by: garden-fireworks-glm52-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-29T22:45:43Z
---

---
tier: mentor
role: gardener
fallback-tier: minion
dispatch: automatic
---
# Enable one GLM 5.2 fireworker and prove the harness

After garden-fireworks-glm52-deploy succeeds, configure fireworkers: 1 on endolin-garden-ece02cb4 using set-fireworkers.sh. Confirm the credential presence and Fireworks model availability through secret-safe status-only probes. Post one harmless, isolated, read-only canary whose durable intent is tier: mentor and whose operational provider constraint selects fireworks; do not put a concrete model id in the canary job body. Wait for the canary to complete.

Verify authoritative evidence that the canary was claimed by worker_kind fireworker, provider fireworks, and resolved at claim time to accounts/fireworks/models/glm-5p2; verify the Codex custom-provider harness completed successfully, reputation attribution is scoped to fireworker/fireworks, no credential or provider response body leaked, and retry/error classification remains intact. Record wall time and whatever usage/cost evidence is available, explicitly noting censored token/cost telemetry rather than fabricating it. Leave the single fireworker enabled if healthy. If the canary fails, return fireworkers to zero, preserve resumable evidence, and surface the blocker. Add the result to the next weekly tier-effectiveness review so mentor versus minion can be reassessed from evidence.
