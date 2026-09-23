---
title: Implications
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

- **Reviewers of new exo method signatures should ask whether the
  method's throw points are throwable.** The contract the comment
  names is a code-review heuristic: a method whose declared
  throws are not throwables is a more expensive review than one
  whose throws are. The discipline of using `toThrowable` (or
  equivalent assertions in the method body) is what makes the
  heuristic load-bearing.
- **`toPassableError` is the canonical answer to "this error
  failed to serialize."** Code that catches a `Fail` from
  marshal's passable check on an error value should reach for
  `toPassableError` rather than wrapping the error in a generic
  "encoding failed" message. The former preserves diagnostic
  information; the latter destroys it.
- **The host-supplied-error special case is what motivates the
  copy rule.** A `TypeError` thrown by a host-builtin
  (`Array.prototype.push` on a frozen array, etc.) is not passable
  by default; the implementation has no opportunity to make it
  passable at its origin. `toPassableError` is the mechanism for
  retroactively making it passable at the boundary that needs to
  cross it. Without this mechanism, exo methods would have to
  individually catch and rewrite every potential host-thrown
  error, which would be both verbose and error-prone (and
  ironically lose the diagnostic information the comment is
  designed to preserve).
- **`isErrorLike` is the cheap pre-check.** Both `toPassableError`
  and `toThrowable` route through `isErrorLike` before doing the
  expensive recursive validation. The cheap check covers the
  common case ("this is an Error instance with a name and a
  message"); the expensive path handles the rest.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
