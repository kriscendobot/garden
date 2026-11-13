from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T03:33:55Z
doom_base: improve-decision-ledger-contention-spool-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T03:33:55Z
last_seen: 2026-11-06T03:33:55Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-decision-ledger-contention-spool-r2; it stays HELD until a human promotes it
(promote-plan.sh improve-decision-ledger-contention-spool-r2) or removes it, so nothing is lost.
Original job base: improve-decision-ledger-contention-spool-r2

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:54Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T03:10:24Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/decision-append.sh
Defect: `scripts/jobs/decision-append.sh:108` drops decisions when its optional 5-second clone lock wait is busy; the reaper lost `schedule-plain-retry` at 17:24:39Z and `mark-split-eligible` at 17:35:39Z.
Persist failed decision rows in a host-local durable spool and flush them under the ledger lock on a later successful invocation, retaining fail-open behavior for controllers.
Add coverage for lock contention followed by recovery to verify both rows reach the ledger once.
