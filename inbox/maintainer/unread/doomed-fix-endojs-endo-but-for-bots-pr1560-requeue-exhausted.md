from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T03:13:51Z
doom_base: fix-endojs-endo-but-for-bots-pr1560
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T03:13:51Z
last_seen: 2026-11-17T03:13:51Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-endojs-endo-but-for-bots-pr1560; it stays HELD until a human promotes it
(promote-plan.sh fix-endojs-endo-but-for-bots-pr1560) or removes it, so nothing is lost.
Original job base: fix-endojs-endo-but-for-bots-pr1560

--- original job body ---
---
posted_at: 2026-11-17T00:36:29Z
arc: unallocated
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1560’s current panel must-fix findings, then verify the durable child-agent coordinator remains CI-ready.
