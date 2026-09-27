---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1336-review-38f12d4f
verdict: miss
category: style-convention
pr: 1336
cluster: pattern-shape-over-procedural-validator
cluster_pattern: A tool or Exo boundary describes argument validity with @endo/patterns shapes but adds a local procedural validator for a reusable value kind instead of expressing that kind as a shared matcher in @endo/patterns; review treats the local check as sufficient and misses the abstraction boundary.
review_at: 2026-09-25T05:13:49Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1336#pullrequestreview-5313629709
identity: endojs/endo-but-for-bots#1336:review:5313629709
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr1336-gauntlet-fix-3
missed_by: purist / procurer / spec-keeper in code-panel round 5
severity: moderate
---

The maintainer asked that the integer constraint be represented by a reusable
`@endo/patterns` shape, with a small matcher addition if the package lacked one,
instead of retaining a local post-pattern integer validator. The eventual fix
added `M.safeInteger()` to `@endo/patterns` and composed it with the existing
range matchers.

Grounds: this should have been caught by the review process. The local
`requireIntegers` helper was introduced by gauntlet fix round 3 and explicitly
said that patterns could express the numeric bounds but not integerness. Code
panel round 5 then examined the helper directly: the saboteur called it a
successful mitigation for invalid numeric arguments, while the procurer only
reported an unrelated duplicate and the purist did not question why a generic
value-kind predicate lived as a package-local normalization pass. That panel
therefore reviewed the exact seam and accepted the workaround rather than asking
whether the missing matcher belonged in the repository's pattern vocabulary.
This is not evaluator gaming: the change did not move a measurement or evade a
gate. It is a style and abstraction-placement miss. It is related to, but
narrower than, `prefer-endo-primitives`: no exact safe-integer matcher existed at
the reviewed base, so the issue was not failure to import an existing export but
failure to extend the canonical matcher family instead of creating a local
procedural validator.

The miss is moderate, not major. The garden's existing reuse guidance named
already-exported `@endo/*` utilities, but did not state that a missing reusable
value-kind matcher should be added to `@endo/patterns`. The standing-rule severity
bypass therefore does not apply.
