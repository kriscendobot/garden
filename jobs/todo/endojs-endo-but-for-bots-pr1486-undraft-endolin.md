---
role: gardener
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1486
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots PR #1486 (handoff from oros-studio)

The gauntlet `endojs-endo-but-for-bots-pr1486-gauntlet` passed its panel at head
`51fec38c4d69c7d94f36dbac58873270b0b87f99`. Its undraft stage ran on
oros-studio-garden-ce242c49, where the bot PAT gets 403 on
`markPullRequestReadyForReview` for endojs repos, so this job is pinned to an endolin host.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1486 --json isDraft,state,headRefOid`.
   Require state OPEN and headRefOid exactly `51fec38c4d69c7d94f36dbac58873270b0b87f99`.
   If the head differs or the metadata can't be read, do NOT un-draft. Report that and stop.
2. If isDraft is true, run `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1486`.
3. Re-fetch and report the final isDraft/headRefOid. Make no other changes.
