---
title: Abstract
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "287-405"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports two coercion functions (toPassableError, toThrowable) rather than just asserting passability, the diagnostic-preservation rule that motivates the copy-with-cause path, and the exo-boundary security-review framing that motivates throwables-only"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, errors, marshal, capability-security]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable
---

The pass-style package exports two coercion-to-passable functions
alongside `passStyleOf` and `isPassable`: `toPassableError(err)`
returns a passable error preserving the original's diagnostic
information (constructor name, message, cause-chain, errors-array)
even when the input is not directly passable, and
`toThrowable(specimen)` returns the input if it is throwable
(passable with no PassableCaps), coerces it via `toPassableError`
when it is *almost* throwable, and throws otherwise. The longform
comments around these two exports are the canonical source for
three design claims: (1) the diagnostic-preservation rule —
encoders prefer reporting whatever information an error carries
over rejecting the error for being non-passable, because a thrown
error is more useful than a thrown error-about-an-error; (2) the
*almost*-throwable special case for errors — errors are coerced
to passable form rather than rejected because they often arrive
at the boundary as host-supplied values (`TypeError`,
`RangeError`) that did not consent to being passable; and (3) the
exo-boundary contract — `toThrowable` exists *specifically* to let
exos throw only throwables, which the comment names as easing
security review by making the boundary's error surface uniform.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
