---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1505
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots PR #1505 (head-guarded)

Handoff from gauntlet stage `endojs-endo-but-for-bots-pr1505-gauntlet-undraft`: the oros-studio bot PAT gets 403 on `markPullRequestReadyForReview`.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1505 --json isDraft,state,headRefOid`
2. Only if state is OPEN AND headRefOid is exactly `0ba87f2ccc290674174bfc09cd4c6d13def32f17` AND isDraft is true: `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1505`. If the head differs, do nothing and report head-mismatch.
3. Re-check `isDraft,headRefOid` and report the result. Do nothing else.
