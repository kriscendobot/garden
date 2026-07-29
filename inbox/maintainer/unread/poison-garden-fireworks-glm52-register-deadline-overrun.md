from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-29T23:33:11Z
poison_base: garden-fireworks-glm52-register
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-29T23:33:11Z
last_seen: 2026-07-29T23:33:11Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/garden-fireworks-glm52-register; it stays HELD until a human promotes it
(promote-plan.sh garden-fireworks-glm52-register) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: garden-fireworks-glm52-register

--- original job body ---
---
role: gardener
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-29T22:46:04Z cleared=none -->

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

<!-- garden-deadline-overrun: 1 -->
