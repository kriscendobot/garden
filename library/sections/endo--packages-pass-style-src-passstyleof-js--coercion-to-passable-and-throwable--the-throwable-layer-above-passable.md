---
title: The throwable layer above passable
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

`toThrowable` operates one strictness-level above `passStyleOf`.
A value is *throwable* iff:

- It is passable (`passStyleOf(v)` returns a string without
  throwing).
- It contains no PassableCaps (no Remotables and no Promises).
- Equivalently: it is copy-data (copyArray, copyRecord, primitive,
  byteArray, tagged) or a passable error, recursively.

The recursive check walks each container case (copyArray,
copyRecord, tagged, error) and asserts each contained value is
itself throwable. The error case is the special one: errors that
are *almost* passable (carry a known constructor + message but
are missing the passable-error-property-descriptor check) are
coerced via `toPassableError` rather than rejected.

The comment names the exo-boundary use case explicitly: *to ease
security review*. An exo's method may throw any value; if the
boundary permits only throwables, the reviewer of a new exo can
inspect the throw-set with one heuristic ("all throws are
copy-data or passable errors, all contained values likewise")
rather than carrying a per-method analysis of "what
PassableCap might escape via this throw."

The narrowing has a measurable effect: PassableCaps in thrown
values are the canonical leak path in capability-secure code
review. A `throw remotable` is a delegation of authority disguised
as a failure path; the throwables-only contract makes that
delegation impossible at the exo boundary, so the reviewer can
focus on the success path's authority flow.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
