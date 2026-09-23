---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-f55c1aef
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T20:01:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965245381
identity: endojs/endo-but-for-bots#475:review:4965245381
---

erights' review left an empty top-level body and one inline comment on
`packages/bytes/src/compare.js` quoting an earlier kriscendobot reply whose inline-code
spans had been silently deleted, leaving one-space gaps. The maintainer asked what the
missing text was, why it went missing, whether other comments suffer the same omission
(enumerate and fix), and whether the bot can prevent it in future.

Grounds: this indicts the fleet's comment-*posting machinery*, not the review of #475's
code. The root cause the primary confirmed is shell **backtick command substitution** —
the reply body was interpolated onto a `gh` command line, so `bash` executed every
`` `identifier` `` span (command-not-found → empty) and deleted it, backticks and all.
That is a tooling-reliability defect in how the garden emits outgoing comments, squarely
the mentor loop's domain ("the machinery misbehaved"), not the prosecutor's ("the work
was wrong and review missed it"). The corrupted artifact is a *reply to the reviewer*
produced during the review cycle, not a hunk in #475's diff: no juror seat, panel stage,
or gauntlet check reviews the byte-content of outgoing bot comment bodies, so nothing in
the review process could have — or should have — caught it. It is not an avoidance-shape
evaluator-gaming case either: #475's review process itself ran in full (dozens of
gauntlet/panel/review jobs for this PR live in journal/jobs/tada/); the machinery bug was
orthogonal to whether the panel ran.

Verified against the world, not the primary report: the review (4965245381, COMMENTED,
empty body, submitted 2026-08-18T20:01Z) and its lone inline comment 3807489882 are as
described; the primary's deterministic prevention — `scripts/jobs/comment-body-guard.sh`
wired into the fleet `gh` chokepoint, committed as `c7a979c618` ("fix(gh-wrapper): refuse
comments whose inline-code was eaten by shell backticks") — exists on origin/main2 (file
present; commit present). So the exact durable, mechanized check a review-improve job
would otherwise be asked to add already landed, at the correct authoring-time chokepoint,
fail-closed on the strip signature. There is no review-cycle gap for this loop to close.
