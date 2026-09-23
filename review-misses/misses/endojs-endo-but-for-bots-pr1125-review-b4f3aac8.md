---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1125-review-b4f3aac8
verdict: miss
category: test-gap
pr: 1125
cluster: behavior-change-without-regression-test
cluster_pattern: A source PR changes an end-to-end user path without a regression test exercising the new behavior, and the coverage stage or coverage-auditor does not require one before maintainer review.
review_at: 2026-09-08T22:54:41Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5147840355
identity: endojs/endo-but-for-bots#1125:review:5147840355
producing_role: builder
missed_by: fast-checker/coverage-auditor (coverage seats)
severity: minor
grounds: A feature PR whose headline capability is a guest-owned invitation primitive (a guest creating/inviting another guest that can then communicate) reached maintainer review carrying only unit-level formula-record.test.js coverage; no endo.test.js integration test exercised the primitive's own end-to-end path. The maintainer's review (CHANGES_REQUESTED) had to ask for exactly that test. Coverage seats' standing lens is "reachable new public behavior without a test," so the missing headline-path integration test was a known review concern, and the primary's fix (nested guest invitation + bidirectional mail coverage in endo.test.js) shows it was practical.
---

The maintainer's CHANGES_REQUESTED review carried an inline request (on the PR's
unit-test file) to add a test in the form of `endo.test.js` that creates a guest
from within a guest and validates that the two can communicate. The PR is titled
"feat(daemon): guest-owned invitation primitive" — its entire purpose is a guest
minting/inviting another guest that then exchanges messages. So the requested test
is not an exotic edge case: it is the end-to-end demonstration that the feature
does the one thing it exists to do.

At the reviewed head the PR carried unit coverage (`formula-record.test.js`) but no
`endo.test.js` integration test exercising the headline guest-from-guest path. The
primary feedback job closed by adding nested guest-invitation and bidirectional
mail coverage to `endo.test.js` and pushing it, confirming the gap was real and the
integration test was practical to write — this retro did not dismiss on the
primary's word alone; the request maps to a concrete diff the primary landed.

**Grounds.** The PR ran a long gauntlet (`...-guest-restart-durable-integration-test-gauntlet`,
six panel/fix rounds, exhausted on review budget) plus many comment-watcher review
loops, yet none required an end-to-end integration test of the invitation
primitive's own user path before it reached the maintainer. The garden owns a
`coverage-driven-testing` skill and coverage seats (`fast-checker`,
`coverage-auditor`) whose lens is precisely "reachable new public behavior without
a test," so a new-capability primitive shipping to review without its headline
integration test is a pattern the review cycle is equipped to sense — a miss, not a
requirement first introduced by the comment. The review-body verb ("rsvp") is just
the directive trigger and is not itself part of the miss.
