---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1498
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots PR #1498 (head-guarded)

The gauntlet `endojs-endo-but-for-bots-pr1498-gauntlet` panel passed head
`f92173c6d5d18656dcdf0a89957c6c183ed9b508`. The undraft stage ran on host oros-studio-garden-ce242c49, whose
bot PAT gets 403 on `markPullRequestReadyForReview` for endojs. This job's only task:

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1498 --json isDraft,state,headRefOid`
2. Only if state is OPEN, headRefOid is exactly `f92173c6d5d18656dcdf0a89957c6c183ed9b508`, and isDraft is true, run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1498`. If the head differs, do NOT un-draft. Report the mismatch.
3. Re-read isDraft/headRefOid and report the result. Do nothing else.
