---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1526
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots PR #1526 (head-guarded)

The gauntlet undraft stage `endojs-endo-but-for-bots-pr1526-gauntlet-undraft` (host
oros-studio) passed its panel but cannot mark the PR ready: the bot PAT there gets
403 on `markPullRequestReadyForReview`. That stage is polling `isDraft` and waits on
this job.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1526 --json isDraft,state,headRefOid`
2. Only if state is OPEN AND headRefOid is exactly
   `ee8abe16961bcb36912bb54f090469434400905d` AND isDraft is true, run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1526`.
   If the head differs, do NOT un-draft; report head-mismatch. If already ready, no-op.
3. Re-read `isDraft,headRefOid` and report the result. Do nothing else.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T04:50:37Z
