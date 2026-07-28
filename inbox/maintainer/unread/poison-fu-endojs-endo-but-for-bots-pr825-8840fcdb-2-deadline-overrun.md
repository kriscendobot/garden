from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-28T12:43:50Z
poison_base: fu-endojs-endo-but-for-bots-pr825-8840fcdb-2
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-28T12:43:50Z
last_seen: 2026-07-28T12:43:50Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/fu-endojs-endo-but-for-bots-pr825-8840fcdb-2; it stays HELD until a human promotes it
(promote-plan.sh fu-endojs-endo-but-for-bots-pr825-8840fcdb-2) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: fu-endojs-endo-but-for-bots-pr825-8840fcdb-2

--- original job body ---
In endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/825 is open, non-draft, and mergeable, but its CI green record predates the final comment-only commit `74f71d55b`. Shepherd the PR: re-run/await CI on the current head so a green record exists on `74f71d55b`, and report the result on the PR.


<!-- garden-deadline-overrun: 1 -->
