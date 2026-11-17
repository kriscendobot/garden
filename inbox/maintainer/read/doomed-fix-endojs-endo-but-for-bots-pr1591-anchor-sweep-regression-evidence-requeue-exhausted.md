from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T09:04:08Z
doom_base: fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T09:04:08Z
last_seen: 2026-11-17T09:04:08Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence; it stays HELD until a human promotes it
(promote-plan.sh fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence) or removes it, so nothing is lost.
Original job base: fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence

--- original job body ---
---
posted_at: 2026-11-17T05:31:20Z
arc: endo-ocapn-background
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1591’s panel must-fix by proving the bwrap exit handler sweeps a retained process group when the leader exits while a member survives.
