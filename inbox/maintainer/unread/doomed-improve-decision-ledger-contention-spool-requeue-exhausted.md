from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T18:13:24Z
doom_base: improve-decision-ledger-contention-spool
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T18:13:24Z
last_seen: 2026-11-05T18:13:24Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-decision-ledger-contention-spool; it stays HELD until a human promotes it
(promote-plan.sh improve-decision-ledger-contention-spool) or removes it, so nothing is lost.
Original job base: improve-decision-ledger-contention-spool

--- original job body ---
---
posted_at: 2026-11-05T17:51:35Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/decision-append.sh
Defect: `scripts/jobs/decision-append.sh:108` drops decisions when its optional 5-second clone lock wait is busy; the reaper lost `schedule-plain-retry` at 17:24:39Z and `mark-split-eligible` at 17:35:39Z.
Persist failed decision rows in a host-local durable spool and flush them under the ledger lock on a later successful invocation, retaining fail-open behavior for controllers.
Add coverage for lock contention followed by recovery to verify both rows reach the ledger once.
