from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T08:35:16Z
doom_base: fix-endojs-endo-but-for-bots-pr1560-20261117
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T08:35:16Z
last_seen: 2026-11-17T08:35:16Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-endojs-endo-but-for-bots-pr1560-20261117; it stays HELD until a human promotes it
(promote-plan.sh fix-endojs-endo-but-for-bots-pr1560-20261117) or removes it, so nothing is lost.
Original job base: fix-endojs-endo-but-for-bots-pr1560-20261117

--- original job body ---
---
posted_at: 2026-11-17T05:12:03Z
arc: unallocated
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1560’s outstanding review findings on the child-agent coordinator, with regression coverage, and drive its CI back to green.
