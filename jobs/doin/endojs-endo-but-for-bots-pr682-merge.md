# Conduct merge of endojs/endo-but-for-bots PR #682

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/682
Title: design(endo-reminder): @endo/reminder message-scheduler plugin (supersedes endoclaw-timer)

This is the finalization/curation step for an APPROVED review
(pullrequestreview-4701240350 by kriskowal, APPROVED). All review asks are
resolved: the sole ask (Open Question #1 on the reminder-id scheme) was
recorded as design decision 18 (random hex from #609's injected id generator,
for collision avoidance + duplicate-schedule support). The branch was rebased
onto `llm` to clear a designs/README.md index conflict.

Current state (verified 2026-07-15): isDraft=false, mergeable=MERGEABLE,
mergeStateStatus=CLEAN, all checks green (build/lint/test/browser-tests/zizmor
pass). Base branch is `llm`.

Task: conduct the merge. Un-draft is already done (not a draft). Choose the
merge method per conductor discipline and merge. Bot repo — merging is
authorized (NOT agoric-sdk, NOT endojs/endo upstream). Re-verify mergeable +
green at claim time (a peer may have pushed) before merging.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: cleric
  claimed_at: 2026-07-15T05:58:54Z
