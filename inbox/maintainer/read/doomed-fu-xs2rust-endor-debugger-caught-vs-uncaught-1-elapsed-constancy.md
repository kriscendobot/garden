from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T02:23:34Z
doom_base: fu-xs2rust-endor-debugger-caught-vs-uncaught-1
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-08-19T02:23:34Z
last_seen: 2026-08-19T02:23:34Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-1; it stays HELD until a human promotes it
(promote-plan.sh fu-xs2rust-endor-debugger-caught-vs-uncaught-1) or removes it.
Original job base: fu-xs2rust-endor-debugger-caught-vs-uncaught-1

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
endojs/endo-but-for-bots PR #600 (Ironhorse/xs2rust debugger): recover the debugger row — this blocks the rest of the debugger work.
