---
title: How toPassableError mediates between the two layers
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

`toPassableError` is the bridge between *passable* and *throwable*:
some errors are already passable, but throwable-on-arrival rules
out errors that carry PassableCaps in their cause/errors chain
(e.g., a `cause` that is a remotable from another vat). The
function:

- Returns the input unchanged when it is *both* passable *and*
  the cause/errors chain is throwable.
- Coerces the input by copy-with-cause when it is missing one or
  more passable-error-property-descriptor invariants, preserving
  the diagnostic info that *is* throwable and dropping (with an
  annotation) the parts that are not.

The result is always throwable: the new error's properties are a
filtered subset of the original's, each filtered for throwability.
Code at the boundary can call `toThrowable(err)` and trust the
result will not contain PassableCaps even if `err` arrived
carrying some.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
