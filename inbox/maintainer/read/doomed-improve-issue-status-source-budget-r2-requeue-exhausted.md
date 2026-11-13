from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T04:04:27Z
doom_base: improve-issue-status-source-budget-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T04:04:27Z
last_seen: 2026-11-06T04:04:27Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-issue-status-source-budget-r2; it stays HELD until a human promotes it
(promote-plan.sh improve-issue-status-source-budget-r2) or removes it, so nothing is lost.
Original job base: improve-issue-status-source-budget-r2

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:54Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T03:39:08Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-status-pass.sh
scripts/jobs/issue-status-pass.sh:211 repeatedly exhausts the tick before the source read (12:51:55Z, 13:17:05Z, 13:20:22Z). Read and trust-filter the source before expensive board snapshot work, reserving its configured timeout from the pass budget; then build the board only after a successful source read.
