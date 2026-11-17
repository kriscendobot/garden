from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T03:03:54Z
doom_base: fix-endojs-endo-but-for-bots-pr1591
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T03:03:54Z
last_seen: 2026-11-17T03:03:54Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-endojs-endo-but-for-bots-pr1591; it stays HELD until a human promotes it
(promote-plan.sh fix-endojs-endo-but-for-bots-pr1591) or removes it, so nothing is lost.
Original job base: fix-endojs-endo-but-for-bots-pr1591

--- original job body ---
---
posted_at: 2026-11-17T00:01:38Z
arc: unallocated
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
On endojs/endo-but-for-bots PR #1591 (`fix/sandbox-bwrap-leader-exit-group-sweep`), fix the panel’s containment findings: replace reaped-PGID signalling with a lifetime-safe mechanism, propagate non-`ESRCH` errors, and add deterministic exit-sweep coverage.
