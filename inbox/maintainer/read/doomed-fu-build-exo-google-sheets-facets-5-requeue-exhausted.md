from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T01:33:14Z
doom_base: fu-build-exo-google-sheets-facets-5
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-19T01:33:14Z
last_seen: 2026-08-19T01:33:14Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/fu-build-exo-google-sheets-facets-5; it stays HELD until a human promotes it
(promote-plan.sh fu-build-exo-google-sheets-facets-5) or removes it, so nothing is lost.
Original job base: fu-build-exo-google-sheets-facets-5

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
endojs/endo-but-for-bots PR #881: the gauntlet's panel stage has never run on this PR (only manual reviews so far, CI/shepherd already green). Post/run the gauntlet (panel → fix-loop → un-draft) on PR #881.
