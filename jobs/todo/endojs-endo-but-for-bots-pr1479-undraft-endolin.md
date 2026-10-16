---
role: gardener
arc: minion-town-mcp-ocapn
pr: https://github.com/endojs/endo-but-for-bots/pull/1479
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Un-draft endojs/endo-but-for-bots PR #1479 (handoff from oros-studio 403)

The gauntlet `endojs-endo-but-for-bots-pr1479-gauntlet` panel PASSED on head
`f188f851c05989e8f05aa15c8e6faf0eaa6b74f3`. The undraft stage ran on host
oros-studio-garden-ce242c49, whose bot PAT lacks Pull requests: write on endojs
(`markPullRequestReadyForReview` 403). This job is pinned to an endolin host
that can write PRs.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1479 --json isDraft,state,headRefOid`.
   Require state OPEN and headRefOid exactly `f188f851c05989e8f05aa15c8e6faf0eaa6b74f3`.
   If the head differs, do NOT un-draft. Report the mismatch. A new head needs a fresh panel.
2. If it is already ready, this is a no-op. Otherwise run `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1479`.
3. Re-fetch and confirm that isDraft is false and the head is unchanged. Report the result.

The advisory appellate pass is already done (non-blocking). It suggested checking for stale `@endo/syrups`
references in other designs, and that the default `tcp-testing-only` framing is incompatible with
spec-draft netstring peers, which the README "Complete" row does not mention. Both are follow-up material only.
