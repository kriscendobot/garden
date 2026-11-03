---
posted_at: 2026-11-03T13:46:46Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
requires: host=endolin-garden-ece02cb4
# Screened delegated merge: kriscendobot/minion.town#234 at bb6f1bee265fa0c7341291330adc70a5a1f422ac
The proxy's screen attested screenings/kriscendobot-minion.town/234/bb6f1bee265fa0c7341291330adc70a5a1f422ac.json on journal2
(delegation config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 234 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.

PR: https://github.com/kriscendobot/minion.town/pull/234
