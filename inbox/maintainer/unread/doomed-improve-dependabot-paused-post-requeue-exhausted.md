from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-16T11:13:18Z
doom_base: improve-dependabot-paused-post
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-16T11:13:18Z
last_seen: 2026-11-16T11:13:18Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-dependabot-paused-post; it stays HELD until a human promotes it
(promote-plan.sh improve-dependabot-paused-post) or removes it, so nothing is lost.
Original job base: improve-dependabot-paused-post

--- original job body ---
---
posted_at: 2026-11-16T10:21:07Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
scripts/jobs/dependabot-watcher.sh:1056 discards post-job’s rc=78, then lines 1059-1071 misclassify the deliberate pause refusal as a lost post every tick. Preserve and recognize GARDEN_PAUSED_RC, suppress the retry warning, and skip the paused PR until its pause is lifted; the same false warning recurred from 09:28:28Z through 10:19:55Z.
