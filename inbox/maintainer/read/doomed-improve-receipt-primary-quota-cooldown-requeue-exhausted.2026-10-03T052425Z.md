from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-10-03T05:24:25Z
doom_base: improve-receipt-primary-quota-cooldown
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-10-03T05:24:25Z
last_seen: 2026-10-03T05:24:25Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-receipt-primary-quota-cooldown; it stays HELD until a human promotes it
(promote-plan.sh improve-receipt-primary-quota-cooldown) or removes it, so nothing is lost.
Original job base: improve-receipt-primary-quota-cooldown

--- original job body ---
---
tier: minion
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-10-03T04:56:45Z cleared=none -->

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
scripts/jobs/receipt-watcher.sh:97-101 treats GitHub primary-quota stderr as a generic transient and logs a 300s cooldown, though the 2026-10-02T19:45:23Z warning was followed by a 3599s primary-quota latch.
Detect primary quota before the generic transient path, request `api_primary_quota_secs`, and log the actual full quota cooldown; add a regression test for the adopted `gh_api_retry` latch.
