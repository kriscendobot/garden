from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T02:13:08Z
doom_base: fu-requeue-ps23-stranded-claims-4
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-08-19T02:13:08Z
last_seen: 2026-08-19T02:13:08Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/fu-requeue-ps23-stranded-claims-4; it stays HELD until a human promotes it
(promote-plan.sh fu-requeue-ps23-stranded-claims-4) or removes it.
Original job base: fu-requeue-ps23-stranded-claims-4

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Garden repo (main2): SUBTEST 7 of `elapsed-constancy-classifier-test.sh` fails on main2 (explicit-cap exemption not firing — sub-floor reclassification wins instead). Fix it.
