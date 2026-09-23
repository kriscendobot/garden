---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr684-review-67f8b51a
verdict: miss
category: naming
pr: 684
cluster: avoid-name-abbreviations
cluster_pattern: A recurring pattern the review keeps missing.
review_at: 2026-07-29T02:05:51Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/684#pullrequestreview-4803347200
identity: endojs/endo-but-for-bots#684:review:4803347200
missed_by: stylist
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

"Avoid abbreviation. Addr is Address." in a daemon test module. This review (2026-07-29) POSTDATES the spell-out-identifiers gate (2026-07-11); the gate's dictionary/scope missed `Addr` (test file), a recurrence.
