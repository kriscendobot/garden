---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr388-review-37754f3b
verdict: not-a-miss
category: new-direction
pr: 388
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/388#pullrequestreview-5037468519
identity: endojs/endo-but-for-bots#388:review:5037468519:retro
review_at: 2026-08-27T05:19:26Z
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr388-review-37754f3b
missed_by: n/a
severity: none
grounds: >
  The maintainer's COMMENTED review is a future integration and workflow
  directive, not a criticism of the reviewed work: in paraphrase, after the
  separately developed passable-byte-array change in PR #475 lands, schedule a
  rebase of draft PR #388 and migrate its gateway byte idioms to the newly
  available convention. The live GitHub history establishes that temporal
  dependency independently of the primary report: review 5037468519 was
  submitted on 2026-08-27, carried no inline comments, and explicitly conditioned
  work on PR #475; PR #475 did not merge until 2026-08-30. Thus the requested
  idiom was not yet part of #388's base when the directive was issued. PR #388's
  actual board history contains no gauntlet or panel job, but that is not
  avoidance: #388 remained a draft and no manual gauntlet was requested. Its
  preceding maintainer review had already been addressed on head 32ce72b71, and
  this review names no extant bug, style or spec violation, missed edge case, or
  standing convention that a juror could have enforced before #475 landed. A
  review panel cannot anticipate a maintainer's choice to sequence one draft
  behind another evolving PR or require a future API before it exists on the
  base. The world also confirms the directive deliverable exists rather than
  relying on the primary's claim: the named successor board job
  endojs-endo-but-for-bots-pr388-passable-byte-arrays-after-pr475-37754f3b is in
  jobs/tada, and GitHub shows #388 later rebased onto a base containing #475 with
  passable frozen Uint8Array changes at commits 146ab2c33 and 386866c09. This is
  first-stated sequencing and scope direction, so there is no review-process miss
  to cluster or improve.
---

# Dismissal: endo-but-for-bots #388 review 5037468519

The maintainer directed a conditional follow-up: once the separate passable-byte-
array PR landed, schedule a rebase of this draft and adopt that new byte idiom.
The review predates the dependency's merge and carries no inline comments or
work-product defect. The draft had no gauntlet, but no gauntlet had been requested;
there was consequently no evaluator avoidance. The successor board artifact and
the eventual rebased implementation both exist in the world. This is operational
sequencing and newly available integration direction, not a convention the panel
failed to enforce. See `comment_url` for the verbatim review.
