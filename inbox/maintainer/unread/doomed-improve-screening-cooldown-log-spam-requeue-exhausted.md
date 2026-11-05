from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T17:16:35Z
doom_base: improve-screening-cooldown-log-spam
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T17:16:35Z
last_seen: 2026-11-05T17:16:35Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-screening-cooldown-log-spam; it stays HELD until a human promotes it
(promote-plan.sh improve-screening-cooldown-log-spam) or removes it, so nothing is lost.
Original job base: improve-screening-cooldown-log-spam

--- original job body ---
---
posted_at: 2026-11-05T16:51:02Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/screen-delegated-prs.sh
`scripts/jobs/screen-delegated-prs.sh:65` logs a WARN on every post-threshold quota-deferred tick, producing warnings at 16:21–16:46 despite the shared cooldown already preventing requests. Make the warning edge-latched (with optional milestone reporting) while preserving the existing coalesced maintainer alert and recovery notice.
