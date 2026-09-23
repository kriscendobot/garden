---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-5b54f00b
verdict: miss
category: naming
pr: 475
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: erights
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4998347995
identity: endojs/endo-but-for-bots#475:review:4998347995
producing_role: builder/fixer campaign
producing_job: endojs-endo-but-for-bots-pr475 campaign
missed_by: stylist
severity: minor
cluster: name-contradicts-value-type
cluster_pattern: A parameter or variable keeps a name that denotes one type (buffer → ArrayBuffer) while now holding a value of a different, non-matching type (a Uint8Array/TypedArray) — usually a stale remnant after a type-narrowing refactor; no naming seat flags a name whose token contradicts the adjacent JSDoc/inferred type, even though the stylist's own surface already forbids "a name that lies about what the value is."
review_at: 2026-08-22T00:22:56Z
grounds: |
  On #475's immutable-arraybuffer work, erights' inline review flagged a
  parameter named `buffer` that is bound only to a `Uint8Array` (the JSDoc on
  the flagged function reads `@param {Uint8Array} buffer`). He observes the name
  is a remnant of when the variable held an `ArrayBuffer`, and asks for a
  head-wide sweep of every place a `buffer`-named variable holds a value whose
  type name does not contain "Buffer."

  This is a review-process miss, not new direction. The stylist seat's standing
  brief already names this exact failure on its PRIMARY surface — "no name that
  lies about what the value is" — and its SECONDARY surface is precisely the
  narrow "JSDoc name vs. the type it sits next to disagree" slice. The signal was
  reviewable from the diff alone and needed no maintainer-only knowledge: the
  JSDoc type `Uint8Array` sits literally adjacent to the name `buffer`, and the
  package deliberately distinguishes `ArrayBuffer` from `Uint8Array`/bytes, so a
  name that says "buffer" over a value that is bytes is a name that lies about the
  value's type. The 2026-08-19 gauntlet ran a naming/style lens over this PR yet
  let the mismatched name through, and the maintainer had to point at it.

  Severity is minor: a misleading-but-narrow identifier reduces clarity but does
  not change runtime behavior. A standing rule (the stylist "no name that lies
  about the value" surface) existed and did not bind, but because the miss is
  minor rather than a security/correctness-class major, it is NOT eligible for the
  single-major standing-rule severity bypass; it holds under the ordinary floor.
---

# Miss: `buffer` names a `Uint8Array` on #475 — a name that lies about the value's type

erights' COMMENTED review on #475 (empty body; substance in one inline comment,
verbatim untrusted text at `comment_url`) flagged a parameter named `buffer`
that is bound only to a `Uint8Array`. Paraphrase: because this package handles
both `ArrayBuffer` and `TypedArray`, naming a TypedArray-only variable `buffer`
is confusing — it reads as an `ArrayBuffer` — and this name is a leftover from
when the variable actually held an `ArrayBuffer`. He asks for every place where a
`buffer`-named variable holds a value whose type name does not contain "Buffer."

## Grounds (miss — naming)

The flagged function carries `@param {Uint8Array} buffer` in its own JSDoc, so the
name-vs-type contradiction is visible in the diff without any maintainer-only
context. The stylist seat's brief already forbids "a name that lies about what the
value is" (primary surface) and calls out the "JSDoc name and the type it names
disagree" slice (secondary surface). The panel ran a naming lens on this PR (the
2026-08-19 gauntlet) and did not flag it. This is a completeness gap in the naming
review, not a first-stated requirement — hence a miss.

It is distinct from the `avoid-name-abbreviations` cluster: `buffer` is not an
abbreviation but a *misleading* full word (it denotes `ArrayBuffer` yet the value
is a `Uint8Array`). It is also distinct from `stale-identifier-reference-sweep`,
which is docs/comment/changeset prose drift after a removal; this is a live
source identifier whose token contradicts its own adjacent type annotation.

## Disposition

Recorded as a miss and minting the `name-contradicts-value-type` cluster
(count would be 1, prs {475}). Held below dispatch under the ordinary floor (a
single miss on a single PR, minor severity, no major-severity bypass). The
first-loop resolution is owned elsewhere: the primary renamed the two PR-diff
parameters and handed the repo-wide sweep to `endojs-endo-but-for-bots-pr475-c55fb1c4`
(reply-only, completed).
