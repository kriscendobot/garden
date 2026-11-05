from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T13:43:31Z
doom_base: improve-issue-status-source-budget
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T13:43:31Z
last_seen: 2026-11-05T13:43:31Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-issue-status-source-budget; it stays HELD until a human promotes it
(promote-plan.sh improve-issue-status-source-budget) or removes it, so nothing is lost.
Original job base: improve-issue-status-source-budget

--- original job body ---
---
posted_at: 2026-11-05T13:21:24Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/issue-status-pass.sh
scripts/jobs/issue-status-pass.sh:211 repeatedly exhausts the tick before the source read (12:51:55Z, 13:17:05Z, 13:20:22Z). Read and trust-filter the source before expensive board snapshot work, reserving its configured timeout from the pass budget; then build the board only after a successful source read.
