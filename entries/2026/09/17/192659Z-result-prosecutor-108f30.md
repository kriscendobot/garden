---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-09-17T19:27:05Z
---
# Retro: endojs/endo-but-for-bots#1125 review 5147840355 (prosecutor)

refs: endojs/endo-but-for-bots#1125:review:5147840355:retro

Verdict: **miss** (test-gap). The maintainer's CHANGES_REQUESTED review asked for
an `endo.test.js` integration test that creates a guest from within a guest and
validates they can communicate — the headline capability of the "guest-owned
invitation primitive" PR. At the reviewed head the PR carried only unit-level
`formula-record.test.js` coverage; no end-to-end test exercised the primitive's
own user path. A six-round gauntlet plus many review loops never required it.
Coverage seats (`fast-checker`, `coverage-auditor`) are equipped to sense
"reachable new public behavior without a test," so this was a review miss, not a
requirement first introduced by the comment. The primary landed the requested
coverage (nested guest invitation + bidirectional mail in `endo.test.js`),
confirming the gap was real and the test practical.

Recorded → `review-misses/misses/endojs-endo-but-for-bots-pr1125-review-b4f3aac8.md`,
joined cluster `behavior-change-without-regression-test` (count=2, prs=66,1125,
status=open, recurrence=0).

Threshold: **held below the floor.** K=2 across 2 distinct PRs is under the K≥3
dispatch floor; severity is minor (a coverage gap, no correctness/data-loss), so
no severity bypass. No `review-improve-*` job dispatched. A third matching
test-gap miss should re-evaluate this cluster at the tail of that retro.

Self-improvement: none warranted this pass — the discriminator, clustering, and
threshold path ran clean.
