---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1125-review-35c43da7
verdict: not-a-miss
category: new-direction
pr: 1125
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1125:review:5187053398:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5187053398
review_at: 2026-09-12T16:13:34Z
severity: minor
grounds: |
  Not a review-miss. kriskowal's CHANGES_REQUESTED review 5187053398 on PR #1125
  (guest invitation / pins-retention primitive) carries a one-line convergence
  body ("this is converging") plus five inline comments, each the project owner's
  evolving design intent on his own daemon architecture, not a bug, spec
  violation, missed edge, or breached standing convention the panel demonstrably
  knows. Enumerated from the world (the review's five review-comments, paraphrased
  from untrusted text):

  (1) formula-record.js — decide whether to migrate from a prior formula version
  based on what exists on master; no deployed guest formula carries pins/heldPins,
  those fields are artifacts of the in-flight work. A scope/data-model call by the
  owner about his own deployed state; the panel does not know master's deployed
  formula shape and no standing rule binds "strip speculative migration code."
  New-direction.

  (2) formula-record.js — a newly-appeared `planes` field "suggests a latent
  defect; please ensure we have coverage." This is design-anomaly review (the
  owner reading his own data model and flagging that the field's presence is
  itself suspect), with a coverage ask attached. The PR already carried
  formula-record.test.js unit coverage; this is a fine-grained one-field ask, not
  the "headline feature reached review with no test" shape. Considered against the
  OPEN `behavior-change-without-regression-test` cluster (whose pattern is an
  end-to-end USER PATH without a regression test — PRs 66 and #1125/b4f3aac8) and
  DECLINED: field-serialization coverage is a distinct shape, and force-fitting it
  there would trip the K>=3/2-PR floor on a member that is 2-of-3 from this one PR
  — exactly the single-PR-masquerade the skill warns against. Left as
  new-direction rather than minting a count=1 coverage micro-cluster.

  (3) formula-type.js — rename the formula type to `readable-directory` to match
  the sibling set `readable-tree`/`readable-blob`. The owner's preferred
  type-taxonomy naming for his own capability set; no seat brief or
  rename-discipline line binds the prior name as wrong. Mirrors the earlier
  4e1469ed dismissal of the guestPins/hostPins rename as owner naming preference.
  New-direction.

  (4) formula-type.js — dispatch a design job proposing a mutable variant of
  readable-blob (blob/file/block-storage) threading ranged read/write filesystem
  powers. An explicit request for NEW design work, authored in the comment.
  New-direction.

  (5) manager.js — readOnly is not snapshot; post a job to flesh out the matrix of
  readable/snapshot/mutable across files, blobs, trees, directories. An explicit
  request for NEW design work. New-direction.

  Ruled out evaluator-gaming on every item: nothing routed around a gate or moved
  a measurement; these are the owner iterating architecture, consistent with the
  two prior #1125 review retros (4e1469ed dismissed, b4f3aac8 a genuine end-to-end
  coverage miss — the discriminator separated them and separates again here).

  Grounded in the world, not the primary's report (checked the false-resolution
  trap): every directive deliverable genuinely EXISTS. The rename landed —
  formula-type.js at the reviewed head lists readable-blob/readable-directory/
  readable-tree consistently; both requested design jobs,
  design-endo-daemon-mutable-blob-block-storage and
  design-endo-daemon-storage-capability-matrix, are in jobs/tada/ (completed); the
  PR is open/draft/mergeable with head advanced past the primary's push. No hollow
  no-op, no discrepancy to report. Mints no cluster.
---

Retrospective on endojs/endo-but-for-bots PR #1125 review 5187053398 (kriskowal,
CHANGES_REQUESTED, "this is converging" + five inline comments). Dismissed as
not-a-miss / new-direction: five maintainer design directives on his own project
— base the pins/heldPins migration on master's deployed state, ensure coverage of
a newly-appeared `planes` field the owner reads as a latent-defect smell, rename
to `readable-directory` for sibling consistency, and two explicit new-design-job
requests (a mutable blob/block-storage variant, and a readable/snapshot/mutable
matrix). None is encoded by a standing rule, seat, or skill. The one coverage
angle (#2 planes) was weighed against the open
behavior-change-without-regression-test cluster and declined as a distinct,
finer-grained shape whose inclusion would trip the floor on a single-PR-dominated
member. All directive deliverables were verified to exist (rename landed, both
designer jobs completed in tada/), so there is no false-resolution discrepancy.
