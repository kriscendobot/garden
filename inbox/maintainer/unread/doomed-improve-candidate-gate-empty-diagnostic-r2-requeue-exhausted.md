from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T03:04:34Z
doom_base: improve-candidate-gate-empty-diagnostic-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T03:04:34Z
last_seen: 2026-11-06T03:04:34Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-candidate-gate-empty-diagnostic-r2; it stays HELD until a human promotes it
(promote-plan.sh improve-candidate-gate-empty-diagnostic-r2) or removes it, so nothing is lost.
Original job base: improve-candidate-gate-empty-diagnostic-r2

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:54Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T02:09:52Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
scripts/jobs/deploy-garden.sh:507 records an rc=1 suite failure with an empty diagnostic, as the 2026-11-05T11:51:31Z rejection shows. When a captured suite output is empty, append deterministic invocation and gate-state context so deploy failures remain actionable.
