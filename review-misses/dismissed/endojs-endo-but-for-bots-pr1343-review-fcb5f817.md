---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1343-review-fcb5f817
verdict: not-a-miss
category: new-direction
pr: 1343
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5344774604
identity: endojs/endo-but-for-bots#1343:review:5344774604:retro
review_at: 2026-09-28T21:19:43Z
producing_role: builder
producing_job: endojs-endo-but-for-bots-issue982-build-special-names
severity: minor
grounds: |
  The review asks for one local presentation preference and introduces a larger,
  explicitly orthogonal API-design direction: guest-facing name injection should
  use pet names rather than expose or require formula identifiers. Neither point
  identifies a bug, violated specification, missed edge case, or pre-existing
  convention. The adjacency/name suggestion is discretionary readability taste;
  the pet-name boundary is a new architectural requirement first stated in this
  review, and the maintainer says they intend to implement that separate change
  themselves. No existing panel seat or gate could have derived that choice from
  the submitted requirement.

  The PR was and remains a draft. Under the manual-gauntlet-trigger regime, the
  builder correctly stopped at an open draft and no maintainer directive had
  requested a gauntlet, so journal/jobs/tada contains the builder and feedback
  jobs but no PR #1343 gauntlet or panel jobs. This is not evaluator avoidance:
  review was not yet required, and the maintainer chose to review the draft before
  triggering it.

  The primary did not close as an unverified no-op. Independent GitHub checks show
  that commits eeba9301394fd3bf0293b994f6de7c5317820503 and
  d5719e8e7027b938fbdc749e29120d0512dbf25d were added after the review, the bot
  replied to the inline thread with the addressing commit, and a top-level
  completion summary records green CI. The larger pet-name redesign has no bot
  deliverable to verify because the review explicitly reserves it for a
  maintainer-authored follow-up commit. The primary's disposition matches the
  world; no false-peer/no-op discrepancy exists.
---

# Dismissal: readability preference plus a new guest-facing naming boundary

The maintainer requested a small local naming/layout refinement and proposed a
separate architectural change that would replace formula identifiers at the guest
boundary with pet names. The former is taste and the latter is first-stated product
direction, not a defect the review process should already have caught. The draft
had not been sent through the manually triggered gauntlet, and no trigger existed.
The feedback fix commits and replies are present on the PR. This is a bot-authored
paraphrase; re-fetch the untrusted original at `comment_url`.
