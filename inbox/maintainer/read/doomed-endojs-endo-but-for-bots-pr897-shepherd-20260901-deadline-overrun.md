from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-09-01T23:45:15Z
doom_base: endojs-endo-but-for-bots-pr897-shepherd-20260901
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-09-01T23:45:15Z
last_seen: 2026-09-01T23:45:15Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr897-shepherd-20260901; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr897-shepherd-20260901) or removes it.
Original job base: endojs-endo-but-for-bots-pr897-shepherd-20260901

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive on endojs/endo-but-for-bots#897 (kriskowal, comment https://github.com/endojs/endo-but-for-bots/pull/897#issuecomment-5500124655, 2026-09-01):

"@kriscendobot Please shepherd."

Shepherd PR #897 (fix(daemon): #713 panel must-fix + summary-fix bundle — maxResults, ReDoS, revocation, symlink-deny, help, trailing-newline, glorp seam) to green CI, per roles/shepherd/AGENT.md. A prior shepherd round on this PR already completed (jobs/tada/endojs-endo-but-for-bots-pr897-shepherd.md) — this is a fresh round against the PR's current head, not a repeat of that one.
