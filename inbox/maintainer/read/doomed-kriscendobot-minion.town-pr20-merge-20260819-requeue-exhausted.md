from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T05:43:20Z
doom_base: kriscendobot-minion.town-pr20-merge-20260819
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-19T05:43:20Z
last_seen: 2026-08-19T05:43:20Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/kriscendobot-minion.town-pr20-merge-20260819; it stays HELD until a human promotes it
(promote-plan.sh kriscendobot-minion.town-pr20-merge-20260819) or removes it, so nothing is lost.
Original job base: kriscendobot-minion.town-pr20-merge-20260819

--- original job body ---
---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Merge kriscendobot/minion.town#20 ("feat: retire toy MCP tools for daemon guests").

State verified by the liaison: APPROVED (kriskowal, 2026-08-17T23:26:09Z), CI
green, MERGEABLE/CLEAN, non-draft. Maintainer said "go ahead" on merging this
during a muster session. Standard conduct: verify state is unchanged, merge,
report the merge commit.
