---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1125-aff3b059
verdict: miss
category: correctness-bug
pr: 1125
cluster: incomplete-sibling-transformation
review_at: 2026-09-12T16:07:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r3996775288
identity: endojs/endo-but-for-bots#1125:comment:3996775288:retro
producing_role: builder
missed_by: breaker (sibling-family enumeration); coverage seats for the record-shape pin
severity: minor
grounds: |
  PR #1125 repaired drift in packages/daemon/src/formula-record.js: the host and
  guest inspector-record branches were missing the `networks`/`planes` references
  that the formulas carry and retain. The maintainer's inline comment (paraphrased)
  read the newly added `planes` reference as evidence of a latent defect class and
  asked for coverage. The primary job checked the world and confirmed the defect:
  the host formula's `registry` slot, added with the @registry capability in #671
  and listed in the manager.js dependency graph, was STILL missing from the host
  inspector branch. That is a sibling of the exact drift this PR fixed, and it went
  unfixed. The primary landed commit 4ca79d80d (the registry reference plus
  formula-record.test.js tests that pin the full host/guest record shapes); I
  verified that registry is now present in llm's formula-record.js. Six gauntlet
  panel rounds cleared the PR without enumerating the sibling slots of the repaired
  family and without asking for a test pinning the whole record shape. This
  re-judges the same inline comment that the review-level retro 35c43da7 dismissed
  as design-anomaly/new-direction. That dismissal predates, and does not account
  for, the primary's confirmation of a real sibling defect. It is judged on the
  world here and not on the comment text alone.
---

A PR fixed some members of a family (formula slots missing from the inspector
record: `planes`/`networks`) and left a sibling (`registry`) broken. The maintainer
guessed there was a latent defect, and the primary confirmed and fixed it. This is
the incomplete-sibling-transformation shape. The review predates that cluster's
2026-09-17 improvement (8107ace005, sibling-family-sweep + B-sibling-family probe),
so it is a backlog-drain member and not a failure of the improvement.
