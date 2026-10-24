---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1394-review-fa16249a
verdict: miss
category: process
pr: 1394
cluster: post-gauntlet-fixer-change-unreviewed
review_at: 2026-10-22T20:54:20Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1394#pullrequestreview-5620286083
identity: endojs/endo-but-for-bots#1394:review:5620286083:retro
producing_role: builder, restacker, shepherd
producing_job: parcel-pivot-stack-20261014; endojs-endo-but-for-bots-pr1394-parcel-restack-20261015-r5527149922; endojs-endo-but-for-bots-pr1394-shepherd-20261015-expanded-window
missed_by: exact-head gauntlet handoff; no code panel over the Parcel pivot (would-be decomplector, purist, wire-watcher, and archivist lenses)
severity: moderate
grounds: |
  The maintainer's review raised ten inline concerns about the Parcel rewrite:
  retaining Parcels in redundant maps, redundant OCapN adaptation layers,
  unnecessarily indirect byte and peer-coordinate handling, overlapping open
  operations, stale SturdyRef compatibility surface, and an unclear CapTP test.
  These are reviewable properties of the submitted diff, not requirements first
  introduced by the review. The primary subsequently removed or simplified each
  of those mechanisms in commits now present on the PR, confirming that the
  feedback addressed the implementation rather than changing the feature's scope.

  The last completed panel reviewed SturdyRef-era head 7516782577 on 2026-10-08.
  The builder then pivoted the stack to Parcel and presented head 6d089a6a31;
  restack and shepherd work advanced PR 1394 through 991e943649. The pivot's
  gauntlet halted in its clean stage because its parent was red, and no panel
  reviewed any Parcel head before the maintainer reviewed 991e943649. The
  journal's panel jobs and the PR's bot reviews independently show that gap.
  This is the existing post-gauntlet-fixer-change-unreviewed pattern: a
  substantive replacement reached maintainer review while the only passing
  panel verdict covered a different implementation.

  The standing exact-head rule and its assert-panel-head-fresh sensor existed
  before this review, but the chained handoffs did not bind it: the pivot said a
  gauntlet was staged, the gauntlet halted before panel, the restack handed CI to
  a shepherd, and the terminal shepherd attempt made no new push and therefore
  did not restore panel coverage. The freshness sensor finally reported
  "review required" only when the later review-response job completed, after the
  maintainer had already supplied the missing review. This is not evaluator
  gaming: the change did not alter what a check measured; the exact-head review
  stage was skipped across a halted-gauntlet and handoff boundary.
---

# Miss: the Parcel pivot reached maintainer review under a stale panel verdict

The review asked to remove retained Parcel maps and legacy compatibility surface,
and to collapse redundant encoding, coordinate, pass-style, and opening layers.
It also asked that the CapTP test state its subject clearly. This is a bot-authored
paraphrase; the original inline comments remain only at `comment_url`.

The primary deliverable exists in the live PR: all ten threads have bot replies
naming addressing commits, those commits are ancestors of current head
`979ac47178`, and a top-level completion summary is present. The retrospective
miss is the absence of a panel over the Parcel implementation before maintainer
review, not a discrepancy in the primary's completion claim.
