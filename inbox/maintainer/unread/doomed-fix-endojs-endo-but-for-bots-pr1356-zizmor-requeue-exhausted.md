from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-27T23:36:32Z
doom_base: fix-endojs-endo-but-for-bots-pr1356-zizmor
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-27T23:36:32Z
last_seen: 2026-09-27T23:36:32Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-endojs-endo-but-for-bots-pr1356-zizmor; it stays HELD until a human promotes it
(promote-plan.sh fix-endojs-endo-but-for-bots-pr1356-zizmor) or removes it, so nothing is lost.
Original job base: fix-endojs-endo-but-for-bots-pr1356-zizmor

--- original job body ---
---
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix the failing zizmor check on endojs/endo-but-for-bots PR #1356, branch build/hardened-url-shim, and restore CI to green.
