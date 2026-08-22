---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-d34b881a
verdict: miss
category: process
pr: 475
cluster: current-review-comment-reconciliation
cluster_pattern: A review-feedback worker acts on a superseded or misread version of a maintainer comment, implements and summarizes a different technical invariant than the current comment requests, and no current-source reconciliation check catches the mismatch before the follow-up is posted.
review_at: 2026-08-17T22:18:50Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5320916419
identity: endojs/endo-but-for-bots#475:comment:5320916419
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr475-review-6c57250a
missed_by: review-feedback current-source reconciliation / spec-keeper
severity: moderate
grounds: |
  The inline review comment was edited at 2026-08-17T22:08:39Z to request a
  specification and regression pin for the TypedArray prototype toStringTag
  getter fidelity loss. Seven minutes later, the review-feedback job posted a
  summary and had landed a specification and tests for a different mechanism:
  integer-indexed reads. The current REST body already contained the corrected
  getter request before that follow-up was posted, so this was not new direction
  first stated by the later attention comment. It was a current-source
  reconciliation failure. The fixer's standing instruction to read all comments
  before touching code should have bound, and the resulting README/test changes
  could also have been rejected by a spec-keeper comparison of the current review
  request to the proposed contract. The recorded gauntlet ran on 2026-08-19,
  after both the mistaken pass and its correction, and therefore could not catch
  the bad follow-up before the maintainer did. The later attention prompted a
  genuine redo: the PR carries a getter-specific README section, corrected design
  prose, and a shim-owned getter regression test at head 4ec34c159f, with closing
  comment 5321003472. Severity is moderate because the first pass deliberately
  specified and pinned the wrong invariant, but the maintainer caught it on the
  open PR within minutes and no released code was affected. This is the first
  miss in a new cluster on one PR, below the K >= 3 across >= 2 PR floor; no
  severity bypass applies and no improvement job is dispatched.
---

The maintainer corrected a just-posted review follow-up that had implemented and
described the integer-indexed-read fidelity loss instead of the getter-specific
fidelity loss named by the current inline review. The corrected getter-specific
specification and regression pin now exist on the PR. See `comment_url` for the
verbatim untrusted text.
