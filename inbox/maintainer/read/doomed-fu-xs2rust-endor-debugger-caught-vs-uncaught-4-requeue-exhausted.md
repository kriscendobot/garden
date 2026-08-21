from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T02:33:12Z
doom_base: fu-xs2rust-endor-debugger-caught-vs-uncaught-4
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-19T02:33:12Z
last_seen: 2026-08-19T02:33:12Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-4; it stays HELD until a human promotes it
(promote-plan.sh fu-xs2rust-endor-debugger-caught-vs-uncaught-4) or removes it, so nothing is lost.
Original job base: fu-xs2rust-endor-debugger-caught-vs-uncaught-4

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
endojs/endo-but-for-bots PR #600 (Ironhorse/xs2rust debugger): fix the three `BreakpointTable` parity nits — missing `line == 0 && id == 0` guard, the un-ported `start` pseudo-breakpoint, and a doc reference to a nonexistent `"unhandled"` pseudo-breakpoint.
