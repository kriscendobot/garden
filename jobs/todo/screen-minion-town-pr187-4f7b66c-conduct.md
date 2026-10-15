---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
# Screened delegated merge: kriscendobot/minion.town#187 at 4f7b66c5596b6a190a53364308b7437d7085d8cc
The proxy's screen attested screenings/kriscendobot-minion.town/187/4f7b66c5596b6a190a53364308b7437d7085d8cc.json on journal2
(delegation config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 187 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.
This PR heals production after merge ad0257e18e2d050d2ed4b1728f8066f468357097.
PR: https://github.com/kriscendobot/minion.town/pull/187
