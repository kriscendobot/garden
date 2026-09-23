---
title: The TODO trail and the implementation gap
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

Both comments carry TODO markers naming the next-level coercion
the implementation has not yet reached:

- `toPassableError` TODO: "Adopt a more flexible notion of
  passable error, in which a passable error can contain other own
  data properties with throwable values." The current
  implementation drops own-data-properties that are not in the
  fixed set (cause, errors); the TODO asks whether passable errors
  could carry an arbitrary set of throwable-valued own data
  properties.
- `toThrowable` TODO: "Adopt a more flexible notion of throwable,
  in which data containers containing non-passable errors can
  themselves be coerced to throwable by coercing to a similar
  containers containing the results of coercing those errors to
  passable errors." The current implementation rejects a copyArray
  whose elements include a non-passable error; the TODO asks
  whether the *array* could be coerced by recursively coercing
  each element.

Both TODOs are implementation extensions that would deepen the
diagnostic-preservation discipline. Neither has been picked up
yet; they remain explicit unresolved-question markers in the
code.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
