---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr806-review-aebac5fc
verdict: miss
category: naming
pr: 806
cluster: avoid-name-abbreviations
cluster_pattern: A recurring pattern the review keeps missing.
review_at: 2026-07-22T09:09:12Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/806#pullrequestreview-4752810208
identity: endojs/endo-but-for-bots#806:review:4752810208
missed_by: stylist
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

An abbreviated identifier in ocapn-noise/src/network.js drew a bare "No abbreviation". This review (2026-07-22) POSTDATES the spell-out-identifiers gate (landed 2026-07-11) — the deterministic gate under-covered this case.
