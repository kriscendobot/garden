from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-16T07:33:07Z
doom_base: endojs-endo-but-for-bots-pr856-weave
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-16T07:33:07Z
last_seen: 2026-08-16T07:33:07Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr856-weave; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr856-weave) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr856-weave

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Weave (rebase) https://github.com/endojs/endo-but-for-bots/pull/856 (fix(endor): run ambiguous import-bearing .js entries as ESM) onto current llm.

State verified 2026-08-16: OPEN, non-draft, mergeStateStatus DIRTY, head ca0b6c023, untouched since 2026-07-28 though its own CI was 24/24 green. A re-review is requested from kriskowal but is not worth acting on until the conflict is resolved. Four separate maintainer-inbox messages asked for re-approval on a stale head; the rebase is the actual blocker.

After the rebase lands and CI is green, hand off for maintainer review.
