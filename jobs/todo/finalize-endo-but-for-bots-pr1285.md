---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finalize (curate → merge) endojs/endo-but-for-bots PR #1285

The maintainer @kriskowal APPROVED this PR
(https://github.com/endojs/endo-but-for-bots/pull/1285#pullrequestreview-5271845031).
The sole ask in the review ("Please build.") has been routed to a separate
builder job (`build-slots-ocapn-op-lanes`); a conflict rebase onto `llm` has
already landed on the PR head (design/slots-ocapn-op-lanes @ 4b0dd5aaa5), and the
PR is now mergeable.

This is the CURATION step: dispatch the **conductor** to un-draft (the PR is
still draft) and merge. Do NOT name a merge method — the conductor owns that
choice (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream.
  - The PR must still be OPEN, mergeable, and checks green. CI was queued at
    hand-off (docs-only design change: adds designs/slots-ocapn-op-lanes.md,
    updates designs/README.md). If it regressed (conflicts, red CI), dispatch the
    shepherd/fixer instead of forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/1285#pullrequestreview-5271845031

<!-- garden-transient-elapsed: kind=exit0 through=0 values=982 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-21T22:04:20Z -->
