---
gate: orchestrated
orchestrated_by: garden-fireworks-glm52-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-29T22:45:33Z
---

---
tier: mentor
role: gardener
fallback-tier: minion
dispatch: automatic
---
# Register Fireworks GLM 5.2 as a mentor model

Repository: https://github.com/kriscendobot/garden. Land directly on main2, no PR.

Replace the placeholder Fireworks model inventory entry with the live, verified selector accounts/fireworks/models/glm-5p2, using the garden routing namespace required by the harness. Classify GLM 5.2 as mentor initially. The maintainer expects the weekly tier-effectiveness engagement to demote it to minion later if evidence shows that is the fastest and cheapest effective placement.

Reconcile the closed model-tier inventory, model routing defaults, Fireworks operations guide, provider catalog, resolver behavior, and tests. The current operations guide records a successful 2026-07-28 canary but still describes wildcard classification that conflicts with the newer fail-closed inventory; make the current closed-inventory contract authoritative. Preserve the rule that automatic jobs express tier intent rather than concrete model pins.

Add or verify a bounded operational mechanism for selecting the Fireworks provider during a canary while the job remains tier: mentor. A provider constraint may select the lane, but must not embed the concrete GLM model in the job body; claim-time resolution chooses the current Fireworks mentor model from the inventory. Unknown provider or tier combinations fail closed. Verify with hermetic tests, shell syntax, and a secret-safe live availability probe that emits only availability/status, never API response bodies or credentials. Report the landed main2 revision and exact deploy/activation steps.
