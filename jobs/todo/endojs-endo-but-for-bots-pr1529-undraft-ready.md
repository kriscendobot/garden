---
requires: host=endolin-garden-ece02cb4
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots PR #1529 (head-guarded relay)

Relay for gauntlet stage `endojs-endo-but-for-bots-pr1529-gauntlet-undraft`: host
oros-studio-garden-ce242c49's PAT gets 403 on `markPullRequestReadyForReview` for endojs.
The panel passed for head `5ce8d6ea121cbb5531e482ac64e4ee49e30e9e24` only.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1529 --json isDraft,state,headRefOid`.
   Require state OPEN and headRefOid exactly `5ce8d6ea121cbb5531e482ac64e4ee49e30e9e24`.
   If it differs or is unreadable, do NOTHING and report it.
2. If isDraft is true, run `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1529`.
3. Re-fetch `isDraft,headRefOid` and report the result. Do nothing else.
