---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-10-24T03:22:39Z
job: endojs-endo-but-for-bots-pr774-review-bedb3ee0-retro
claim: a57db70290051913
---
Retrospective verdict: **review miss** (`process`, severity `major`) for
endojs/endo-but-for-bots PR #774 review 5609838628.

The approval body itself only gave workflow and budget direction, but the PR's
actual history shows a standing-rule failure. Its only durable panel runs
reviewed superseded SturdyRef heads `ef4662f0` and `12050148`, both with
must-fix dispositions. The later fixer/restack replaced that work with the
Parcel implementation and presented `dbd2b003`; its own completion report
stamped the exact-head coverage as review-required. The replacement gauntlet
then halted at clean on `501a4f42` before panel, and conduct rebased the PR to
`ef1ae4f9`. The maintainer approved that unpanelled head and it entered conduct.
That violates `roles/COMMON.md`'s exact-head rule and shows the existing
freshness disposition did not bind the approval-to-conduct path. It is process
failure, not evaluator gaming: the sensor fired and a gauntlet was attempted,
but the chain did not fail closed after the pre-panel halt.

Recorded through `review-miss-record.sh` as
`review-misses/misses/endojs-endo-but-for-bots-pr774-review-bedb3ee0.md`, joining
cluster `post-gauntlet-fixer-change-unreviewed`. Writer result: count 6 across
six PRs, status open, recurrence 0, drain_reopen 0.

Threshold decision: held without a new builder dispatch. The cluster already
has improvement job `review-improve-post-gauntlet-fixer-change-unreviewed` and
a prior genuine post-fix recurrence, so the retrospective procedure forbids a
second automatic improvement round. Appended a cluster rationale identifying
the approval/conductor boundary as the next inspection point; a sanctioned
round should require an exact-head passing panel or explicit maintainer override
after a gauntlet halts before panel.

Independent primary check: the deferred Parcel layer-2 plan exists in
`jobs/plan/ebfb-parcel-layer2-build-20261022.md`, and both conduct jobs exist in
tada. They un-drafted and rebased #774, but GitHub still shows the PR open and
unmerged because CI is red. The primary did not falsely claim a completed merge;
its “handled” shorthand meant durable delegation. No false-peer no-op, but the
directive is not yet fully landed.

Self-improvement: nothing this time.
