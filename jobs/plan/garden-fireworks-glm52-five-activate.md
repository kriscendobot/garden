---
gate: orchestrated
orchestrated_by: garden-fireworks-glm52-five-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-30T00:12:32Z
---

---
tier: mentor
role: gardener
fallback-tier: minion
dispatch: automatic
---
# Enable and verify five GLM 5.2 fireworkers

After garden-fireworks-glm52-five-deploy succeeds, configure fireworkers: 5 on endolin-garden-ece02cb4 using set-fireworkers.sh. Confirm credential presence and model availability through secret-safe probes. Run a harmless tier: mentor, provider-constrained Fireworks canary without a concrete model pin and wait for completion. Verify it resolves to accounts/fireworks/models/glm-5p2 at claim time, runs through worker_kind fireworker and provider fireworks, attributes reputation correctly, leaks no credentials or response bodies, and records available latency/usage evidence honestly. Leave all 5 fireworkers enabled only if the canary and worker health pass; otherwise return fireworkers to zero and surface the blocker. Verify 5 active fireworkers, 5 configured mystics, drain lifted, and zero failed garden units.
