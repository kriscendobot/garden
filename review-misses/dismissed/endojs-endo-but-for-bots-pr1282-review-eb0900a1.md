---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1282-review-eb0900a1
verdict: not-a-miss
category: new-direction
pr: 1282
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1282#pullrequestreview-5252957728
identity: endojs/endo-but-for-bots#1282:review:5252957728:retro
review_at: 2026-09-18T21:53:06Z
producing_role: builder
producing_job: ironhorse-demolish-xs-computron-parity-myth
missed_by: none-new-direction
severity: minor
grounds: >
  The maintainer's review changed the required disposition of superseded
  doctrine from visibly fenced historical material to deletion. The producer's
  governing brief explicitly permitted keeping a historical section when it
  was unmistakably fenced as superseded and required two named obsolete work
  orders to be retired explicitly rather than silently dropped. Commit
  9715d0cbbb14 implemented that permitted shape with warning banners and dated
  retirement explanations, so a panel applying the brief had no prior basis to
  require deletion. The journal and GitHub contain no gauntlet or panel review
  before the maintainer review, despite the then-current automatic-gauntlet
  regime, but that independent process gap would not have made this newly
  stated content preference anticipatable. The primary's deliverable exists in
  the world: current PR head 8aad7086a966 deletes the retained stage-2 doctrine,
  the retired parity work-order narratives, the snapshot parity history, the
  changelog banner, and the architecture-review alternatives; a repository
  search at that head finds none of the superseded-doctrine markers at issue,
  and PR completion comment 5850375641 reports the same head. This is a scope
  refinement, not a review miss, so no cluster or improvement job is warranted.
---

# Dismissal: PR #1282 review 5252957728

The maintainer asked that obsolete metering doctrine be removed rather than
retained with warnings. This is a bot-authored paraphrase; the linked review is
the only source for the untrusted original text.

The producing brief had expressly authorized conspicuous supersession fences
for historical material and explicit retirement explanations for obsolete work
orders. The initial PR head followed that instruction. A review panel could not
be expected to replace an allowed retention strategy with deletion before the
maintainer made that preference explicit.

Direct inspection confirms the primary loop did not merely report a no-op. PR
head `8aad7086a966` contains a dedicated deletion commit affecting six doctrine
documents, and the former fenced stage records and retired-work-order prose no
longer appear at that head. Dismissed as new direction; no cluster or
review-improvement job was created.
