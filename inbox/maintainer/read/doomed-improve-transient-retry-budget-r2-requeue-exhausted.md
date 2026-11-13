from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T02:43:54Z
doom_base: improve-transient-retry-budget-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T02:43:54Z
last_seen: 2026-11-07T02:43:54Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-transient-retry-budget-r2; it stays HELD until a human promotes it
(promote-plan.sh improve-transient-retry-budget-r2) or removes it, so nothing is lost.
Original job base: improve-transient-retry-budget-r2

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:55Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T05:16:27Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/reaper.sh
Defect: `scripts/jobs/reaper.sh:1091` increments the plain-exit counter for a `reap-now` transient unless the fleet brake is engaged, exhausting an innocent job’s sole retry; `design-daemon-git-remotes-extended-transports` hit rc=75 again after that charged retry at 2026-11-05T19:33:37Z.
Treat non-outage `reap-now` transient cycles as non-attributable: preserve the prior retry count, requeue with bounded backoff, and reserve split-eligible parking for deterministic or otherwise attributable failures.
