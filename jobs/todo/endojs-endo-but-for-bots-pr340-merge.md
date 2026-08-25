---
role: conductor
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Merge endojs/endo-but-for-bots PR #340 (finalization)

PR #340 (https://github.com/endojs/endo-but-for-bots/pull/340) carries a
maintainer APPROVAL from @kriskowal (review 5017515598). Its one review
ask — extract `makeGracefulReader` into `@endo/stream-node/graceful-reader.js`
and parameterize the gracefully-handled error codes — has been RESOLVED:
commit 98add24d69 on head branch `claude/endo-daemon-ocapn-FkmHO`, reply at
https://github.com/endojs/endo-but-for-bots/pull/340#discussion_r3851861958.

You are the conductor / finalization step. Drive PR #340 to merge:
- Confirm the PR is not draft (it was already un-drafted) and mergeable.
- Wait for CI to go green on the new head (the resolution commit re-triggers
  checks); if a re-review is required because the approval predates the new
  commit, surface that to the maintainer via the liaison rather than merging
  around it.
- Choose the merge method yourself and merge once green + approved.

Bot repo (endojs/endo-but-for-bots) — merging here is authorized. NEVER
merge agoric-sdk or the endojs/endo upstream.
