---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
requires: host=endolin-garden-ece02cb4
# Screened delegated merge: kriscendobot/minion.town#214 at 0e644c0c2a57f4c95491cf8c78c9c37566c886e5
The proxy's screen attested screenings/kriscendobot-minion.town/214/0e644c0c2a57f4c95491cf8c78c9c37566c886e5.json on journal2
(delegation config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 214 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.
This PR heals production after merge a2d2426951de58a0a3e953f24af7a7ea74c39a81.
PR: https://github.com/kriscendobot/minion.town/pull/214

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T00:37:20Z
