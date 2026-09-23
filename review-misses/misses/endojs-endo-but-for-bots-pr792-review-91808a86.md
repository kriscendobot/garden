---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr792-review-91808a86
verdict: miss
category: style-convention
pr: 792
cluster: inline-import-jsdoc
cluster_pattern: A recurring pattern the review keeps missing.
review_at: 2026-07-22T06:09:24Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/792#pullrequestreview-4751416266
identity: endojs/endo-but-for-bots#792:review:4751416266
missed_by: typist
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

Maintainer: "Prefer @import. Should have been caught in review." This review (2026-07-22) POSTDATES the inline-import-jsdoc gate+typist fix (2026-07-16). Deploy lag is plausible, but it is a recurrence of a closed cluster. (Same review also flags factoring guest.js/manager.js and an ad-hoc exo-tar — refactor direction, secondary.)
