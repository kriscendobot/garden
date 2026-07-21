from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-07-13T19:03:28Z
poison_base: gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-13T19:03:28Z
last_seen: 2026-07-13T19:03:28Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop; it stays HELD until a human promotes it
(promote-plan.sh gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop) or removes it, so nothing is lost.
Original job base: gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop

--- original job body ---
Run the gauntlet (clean → panel review → fix-loop → un-draft) on endojs/endo-but-for-bots#707, the git-capability stack Phase 3 that delivers the worked version-controlled-filesystem loop named as milestone M3's exit criterion. The PR is green on CI but still DRAFT; drive it to review-passed and un-drafted so it joins the merge-ready stack (#705/#706/#708) alongside it.


<!-- garden-deadline-overrun: 1 -->
