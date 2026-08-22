---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-6bff44d0
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T21:59:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5334566218
identity: endojs/endo-but-for-bots#475:comment:5334566218
---

Maintainer design decision on an open, unmerged PR, in answer to a question the
bot had explicitly deferred to him. The bot offered to land a byte-thawing
helper it proposed calling `toMutableUint8` (concat + to-string) plus a shared
predicate; kriskowal returned the design ruling: name the helper `toThawed`,
compose `ArrayBuffer.isView` with `toThawed` across `@endo/bytes`, `@endo/hex`,
`@endo/base64` &c to handle emulated immutable ArrayBuffers (defensive mutable
copy only when necessary), and settle the `view.at(index)` vs `toThawed`-copy
choice by benchmark — noting XS is immaterial (native immutable ArrayBuffer +
native base64 codec, no shim) while Node.js needs measurement that depends on
subject size.

This is taste (the name), architecture (the composition strategy), and a
first-stated requirement (benchmark-driven decision), all originated by the
maintainer in the comment itself and explicitly deferred to him ("I defer this
question to @kriskowal"). No seat brief, skill, or standing instruction could
have anticipated which name he would pick or that he would mandate a benchmark;
nobody was positioned to catch this pre-review. The review process operated
correctly — this is an ongoing design conversation on an open PR, not a defect
that slipped a gate. No process-avoidance either: PR #475 has an extensive
recorded review history including a gauntlet
(`endojs-endo-but-for-bots-pr475-gauntlet-20260819`).

Primary deliverable confirmed to EXIST in the world (not an asserted no-op):
the primary posted designer job `endojs-endo-but-for-bots-pr475-design-tothawed`,
which delivered a real design note to PR #475
(https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5336280364)
specifying the `toThawed` API/home (`@endo/immutable-arraybuffer`), the
`isView`+`toThawed` composition, per-site recommendations, and a Node
micro-benchmark with the reported crossover — exactly the direction the comment
requested.
