from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T20:33:17Z
doom_base: screen-minion-town-pr253-9c79d18-conduct
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T20:33:17Z
last_seen: 2026-11-07T20:33:17Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/screen-minion-town-pr253-9c79d18-conduct; it stays HELD until a human promotes it
(promote-plan.sh screen-minion-town-pr253-9c79d18-conduct) or removes it, so nothing is lost.
Original job base: screen-minion-town-pr253-9c79d18-conduct

--- original job body ---
---
posted_at: 2026-11-07T20:01:00Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
requires: host=endolin-garden-ece02cb4
# Screened delegated merge: kriscendobot/minion.town#253 at 9c79d1807388884a67b19c151290f31765611364
The proxy's screen attested screenings/kriscendobot-minion.town/253/9c79d1807388884a67b19c151290f31765611364.json on journal2
(delegation config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 253 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.

PR: https://github.com/kriscendobot/minion.town/pull/253
