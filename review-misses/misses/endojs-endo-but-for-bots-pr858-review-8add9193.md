---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr858-review-8add9193
verdict: miss
category: process
pr: 858
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head, leaving newly introduced state invariants for the maintainer to reconstruct.
review_at: 2026-08-29T19:56:41Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/858#pullrequestreview-5058295396
identity: endojs/endo-but-for-bots#858:review:5058295396
producing_role: shepherd
producing_job: endojs-endo-but-for-bots-pr858-shepherd
missed_by: post-fix review process; the purist minimum-viable-abstraction lens never ran on the shepherd head
severity: minor
grounds: |
  The shepherd's commit 1ec375e2 changed the CI workflow after the completed
  gauntlet. It kept `24.x` as matrix data, then added a conditional expression
  at the setup-node boundary to select 24.18.1. The maintainer's review asked
  whether the same pin could live directly in the matrix. Commit c4462d82 then
  replaced the matrix entry with 24.18.1 and restored setup-node's direct use
  of the matrix value. The correction removed an unnecessary policy/mechanism
  split while preserving the workaround, so this was reviewable from the diff
  rather than a new product requirement.

  The durable gauntlet report records its final panel over head 7d23bf082,
  before the shepherd introduced 1ec375e2. The shepherd report and PR history
  show CI verification of 1ec375e2, but no fresh panel pass over that workflow
  delta before the maintainer reviewed it. The purist seat's standing minimum-
  viable-abstraction inquiry and the shepherd's smallest-fix norm should have
  challenged the extra conditional and preferred changing the matrix source
  directly. This is the same control gap as the existing cluster's PR #475
  member: a substantive fix after the last gauntlet reached maintainer review
  without a fresh review of the introducing head. Here the producer was a
  shepherd rather than a maintainer-feedback fixer, which shows the gap crosses
  post-gauntlet repair roles.

  This is not evaluator gaming: the change did not alter a check to evade its
  purpose. The primary later delivered c4462d82, all GitHub checks passed, and
  the maintainer approved the corrected head, so there is no false no-op
  discrepancy.
---

The review feedback is paraphrased as a request to put the temporary Node patch
pin in the CI matrix itself instead of conditionally translating a broad matrix
label inside setup-node. See `comment_url` for the untrusted original text.

The miss is the absent post-gauntlet review of the shepherd's substantive
workflow edit, not the Node runtime diagnosis or the need for a temporary pin.
