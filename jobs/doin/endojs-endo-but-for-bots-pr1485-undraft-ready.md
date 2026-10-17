---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots#1485 (host-pinned PR-write handoff)

The gauntlet undraft stage `endojs-endo-but-for-bots-pr1485-gauntlet-undraft` ran on oros-studio-garden-ce242c49, whose bot PAT gets 403 on `markPullRequestReadyForReview` for endojs. The panel passed on head `cd471213433cb024ca50414cc0506655d6979b06`.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1485 --json isDraft,state,headRefOid`. Require state OPEN and headRefOid exactly `cd471213433cb024ca50414cc0506655d6979b06`. If either check fails, do NOT un-draft. Report that and message the parent job `endojs-endo-but-for-bots-pr1485-gauntlet-undraft`.
2. If isDraft is true, run `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1485`. If it is already ready, do nothing.
3. Re-fetch and report isDraft/headRefOid. Do nothing else (no review, no push).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T07:55:56Z
