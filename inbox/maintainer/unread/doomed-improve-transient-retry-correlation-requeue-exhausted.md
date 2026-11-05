from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T14:43:22Z
doom_base: improve-transient-retry-correlation
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T14:43:22Z
last_seen: 2026-11-05T14:43:22Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-transient-retry-correlation; it stays HELD until a human promotes it
(promote-plan.sh improve-transient-retry-correlation) or removes it, so nothing is lost.
Original job base: improve-transient-retry-correlation

--- original job body ---
---
posted_at: 2026-11-05T14:21:39Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1941 records a second transient failure only as progress; four distinct jobs reached that state on `endolin-garden-ece02cb4` between 13:53:51Z and 14:13:28Z. Add a short-lived, host-local distinct-base burst detector that emits one deduplicated error and engages a bounded retry/claim cooldown for correlated second-attempt transient failures, while retaining the reaper as disposition owner.
