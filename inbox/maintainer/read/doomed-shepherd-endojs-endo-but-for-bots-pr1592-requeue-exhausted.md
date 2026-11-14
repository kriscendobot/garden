from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-14T14:53:19Z
doom_base: shepherd-endojs-endo-but-for-bots-pr1592
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-14T14:53:19Z
last_seen: 2026-11-14T14:53:19Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/shepherd-endojs-endo-but-for-bots-pr1592; it stays HELD until a human promotes it
(promote-plan.sh shepherd-endojs-endo-but-for-bots-pr1592) or removes it, so nothing is lost.
Original job base: shepherd-endojs-endo-but-for-bots-pr1592

--- original job body ---
---
posted_at: 2026-11-14T14:16:26Z
arc: unallocated
role: shepherd
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Shepherd endojs/endo-but-for-bots PR #1592 after its stack reweave: diagnose and drive the current CI failures to a green result without duplicating the existing base-fix work.
