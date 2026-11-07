---
role: conductor
tier: minion
posted_at: 2026-11-05T12:23:17Z
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-07T17:24:08Z cleared=none -->

---
posted_at: 2026-11-05T11:54:25Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: conductor
delegation: minion-town-pr-screening
requires: host=endolin-garden-ece02cb4
# Screened delegated merge: kriscendobot/minion.town#237 at 4e2911dff11e922fda803ca14319fcdba5ee4c96
The proxy's screen attested screenings/kriscendobot-minion.town/237/4e2911dff11e922fda803ca14319fcdba5ee4c96.json on journal2
(delegation config/delegations/minion-town-pr-screening; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/minion.town <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 237 --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.

PR: https://github.com/kriscendobot/minion.town/pull/237

<!-- garden-transient-elapsed: kind=exit0 through=0 values=103 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-07T17:24:25Z
