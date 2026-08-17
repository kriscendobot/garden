from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-16T07:43:07Z
doom_base: endojs-endo-but-for-bots-pr340-shepherd-20260816
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-16T07:43:07Z
last_seen: 2026-08-16T07:43:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr340-shepherd-20260816; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr340-shepherd-20260816) or removes it.
Original job base: endojs-endo-but-for-bots-pr340-shepherd-20260816

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Shepherd https://github.com/endojs/endo-but-for-bots/pull/340 (feat(daemon): OCapN-Noise transport for daemon-to-daemon) to green.

State verified 2026-08-16: OPEN, non-draft, mergeStateStatus UNSTABLE, head f081208e1 (updated 08-15). Exactly one check fails: test (24.x, ubuntu-latest). Everything else passes 27/28.

This is the transport root of the OCapN stack (340 -> 684 -> 688 -> 693), so getting it green unblocks the restack. Diagnose and fix the single failing job; do not rewrite unrelated history.
