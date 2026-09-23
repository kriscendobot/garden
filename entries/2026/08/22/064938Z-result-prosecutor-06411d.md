---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-08-22T06:49:39Z
---
Retrospective completed for `endojs-endo-but-for-bots-pr475-review-92a260ae`
(review 4965315618 on PR #475).

Verdict: review miss (`type-error`). At review commit `ce8d0578`, the PR still
carried the pre-narrowing `ArrayBufferView | ArrayBufferLike` union across byte
APIs in bytes, hex, ocapn, pass-style, and utf8. The typist brief already
requires JSDoc parameter types to match the runtime shape and requires type
narrowings to hold at function boundaries, so a head-wide sweep should have
preceded maintainer review. Later project commits removed these stale unions,
confirming they were not deliberate API generality.

Recorded `review-misses/misses/endojs-endo-but-for-bots-pr475-review-92a260ae.md`
and joined `type-annotation-narrowing-sweep`. The cluster is now count=3 but
prs=[475], so it remains open and below the floor requiring at least two
distinct PRs. No `review-improve-*` job was dispatched; recurrence=0.

World-state discrepancy: the named primary job is parked as reaper-doomed in
`jobs/plan/` and the original inline comment has no direct bot reply. Other
later review jobs did land the substantive repo-wide narrowing, but they do not
complete that primary review-response artifact. The primary loop remains
unchanged and owns its own disposition.

Self-improvement: nothing this time.
