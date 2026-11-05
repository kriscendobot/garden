from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T20:13:50Z
doom_base: improve-transient-retry-budget
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T20:13:50Z
last_seen: 2026-11-05T20:13:50Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-transient-retry-budget; it stays HELD until a human promotes it
(promote-plan.sh improve-transient-retry-budget) or removes it, so nothing is lost.
Original job base: improve-transient-retry-budget

--- original job body ---
---
posted_at: 2026-11-05T19:51:16Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/reaper.sh
Defect: `scripts/jobs/reaper.sh:1091` increments the plain-exit counter for a `reap-now` transient unless the fleet brake is engaged, exhausting an innocent job’s sole retry; `design-daemon-git-remotes-extended-transports` hit rc=75 again after that charged retry at 2026-11-05T19:33:37Z.
Treat non-outage `reap-now` transient cycles as non-attributable: preserve the prior retry count, requeue with bounded backoff, and reserve split-eligible parking for deterministic or otherwise attributable failures.
