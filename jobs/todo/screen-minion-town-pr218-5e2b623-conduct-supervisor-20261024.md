---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
requires: host=endolin-garden-ece02cb4
# Screened delegated merge: kriscendobot/minion.town#218 at 5e2b6232bc4dfd27083912167ed48cbaf06cb5af
The proxy's screen attested screenings/kriscendobot-minion.town/218/5e2b6232bc4dfd27083912167ed48cbaf06cb5af.json
on journal2 (panel_match: exact, screened_at 2026-10-24T19:32:52Z; delegation
config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md).
No maintainer approval is required; do not request one.

Posted by the minion.town arc supervisor (minion-town-arc-press-20261024-213514) because
the screen's own three conductor slots for this head (screen-minion-town-pr218-5e2b623-conduct,
-r2, -r3) were all burned by panel-freshness refusals BEFORE the exact-head panel ran,
so the screen now refuses to post another (maintainer notice
minion-town-pr-screening-stalled-pr218-5e2b623). `assert-panel-head-fresh.sh` reports
`fresh`/`covered` at this head since the fresh-panel job.

1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town split/pr216-ledger
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 218 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.
PR: https://github.com/kriscendobot/minion.town/pull/218
