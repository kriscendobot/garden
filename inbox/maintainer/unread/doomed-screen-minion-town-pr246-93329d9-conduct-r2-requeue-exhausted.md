from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T18:43:41Z
doom_base: screen-minion-town-pr246-93329d9-conduct-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T18:43:41Z
last_seen: 2026-11-07T18:43:41Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/screen-minion-town-pr246-93329d9-conduct-r2; it stays HELD until a human promotes it
(promote-plan.sh screen-minion-town-pr246-93329d9-conduct-r2) or removes it, so nothing is lost.
Original job base: screen-minion-town-pr246-93329d9-conduct-r2

--- original job body ---
---
posted_at: 2026-11-07T18:06:10Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
requires: host=endolin-garden-ece02cb4
# Screened delegated merge: kriscendobot/minion.town#246 at 93329d9faf0564a579182194209e7d3c89e97245
The proxy's screen attested screenings/kriscendobot-minion.town/246/93329d9faf0564a579182194209e7d3c89e97245.json on journal2
(delegation config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 246 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.

PR: https://github.com/kriscendobot/minion.town/pull/246
