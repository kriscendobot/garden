from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T11:03:53Z
doom_base: weave-endojs-endo-but-for-bots-pr1560
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T11:03:53Z
last_seen: 2026-11-17T11:03:53Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/weave-endojs-endo-but-for-bots-pr1560; it stays HELD until a human promotes it
(promote-plan.sh weave-endojs-endo-but-for-bots-pr1560) or removes it, so nothing is lost.
Original job base: weave-endojs-endo-but-for-bots-pr1560

--- original job body ---
---
posted_at: 2026-11-17T10:04:03Z
arc: unallocated
role: weaver
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR #1560, the M3 child-agent coordinator, onto the current `llm` tip to resolve its dirty merge state and unblock its approved critical path.
