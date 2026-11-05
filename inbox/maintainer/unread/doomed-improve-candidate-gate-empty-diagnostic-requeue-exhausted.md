from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T12:43:38Z
doom_base: improve-candidate-gate-empty-diagnostic
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T12:43:38Z
last_seen: 2026-11-05T12:43:38Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-candidate-gate-empty-diagnostic; it stays HELD until a human promotes it
(promote-plan.sh improve-candidate-gate-empty-diagnostic) or removes it, so nothing is lost.
Original job base: improve-candidate-gate-empty-diagnostic

--- original job body ---
---
posted_at: 2026-11-05T12:22:04Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
scripts/jobs/deploy-garden.sh:507 records an rc=1 suite failure with an empty diagnostic, as the 2026-11-05T11:51:31Z rejection shows. When a captured suite output is empty, append deterministic invocation and gate-state context so deploy failures remain actionable.
