from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T04:13:28Z
doom_base: shepherd-endojs-endo-but-for-bots-pr1596-20261117
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T04:13:28Z
last_seen: 2026-11-17T04:13:28Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/shepherd-endojs-endo-but-for-bots-pr1596-20261117; it stays HELD until a human promotes it
(promote-plan.sh shepherd-endojs-endo-but-for-bots-pr1596-20261117) or removes it, so nothing is lost.
Original job base: shepherd-endojs-endo-but-for-bots-pr1596-20261117

--- original job body ---
---
posted_at: 2026-11-17T02:12:00Z
arc: unallocated
role: shepherd
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Shepherd endojs/endo-but-for-bots PR #1596 (`build/m3-mvs-resolver-reference`) to resolve its failing zizmor check and restore green CI for the M3 MVS resolver reference implementation.
