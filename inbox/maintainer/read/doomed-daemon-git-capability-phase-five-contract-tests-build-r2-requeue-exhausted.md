from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T02:14:42Z
doom_base: daemon-git-capability-phase-five-contract-tests-build-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T02:14:42Z
last_seen: 2026-11-07T02:14:42Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/daemon-git-capability-phase-five-contract-tests-build-r2; it stays HELD until a human promotes it
(promote-plan.sh daemon-git-capability-phase-five-contract-tests-build-r2) or removes it, so nothing is lost.
Original job base: daemon-git-capability-phase-five-contract-tests-build-r2

--- original job body ---
---
role: builder
tier: mentor
arc: minion-town-git-remote
posted_at: 2026-11-06T02:09:04Z
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T05:17:07Z cleared=none -->

---
role: builder
tier: mentor
token-budget: 250000
arc: minion-town-git-remote
fallback-tier: minion
dispatch: automatic
---
Build the unblocked Phase 5 contract-test slice for `endojs/endo-but-for-bots` from the `daemon-git-capability` M3 design on `llm`, opening a draft PR that prevents drift among the Git exo interface, types, and generated code-mode declarations.
