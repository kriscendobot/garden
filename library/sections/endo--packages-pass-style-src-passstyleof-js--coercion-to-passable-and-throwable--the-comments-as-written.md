---
title: The comments as written
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

Lines 287-298 on `toPassableError`:

> After hardening, if `err` is a passable error, return it.
>
> Otherwise, return a new passable error that propagates the
> diagnostic info of the original, and is linked to the original
> as a note.
>
> TODO Adopt a more flexible notion of passable error, in which
> a passable error can contain other own data properties with
> throwable values.

Lines 335-353 on `toThrowable`:

> After hardening, if `specimen` is throwable, return it.
> A specimen is throwable iff it is Passable and contains no
> PassableCaps, i.e., no Remotables or Promises.
> IOW, if it contains only copy-data and passable errors.
>
> Otherwise, if `specimen` is *almost* throwable, for example, it
> is an error that can be made throwable by `toPassableError`,
> then return `specimen` converted to a throwable.
>
> Otherwise, throw a diagnostic indicating a failure to coerce.
>
> This is in support of the exo boundary throwing only throwables,
> to ease security review.
>
> TODO Adopt a more flexitble notion of throwable, in which
> data containers containing non-passable errors can themselves
> be coerced to throwable by coercing to a similar containers
> containing the results of coercing those errors to passable
> errors.

The comments together name the three-layer design: throwable
(strictest: passable + no PassableCaps), passable (looser: classifiable
under one of the pass-styles), and coercible-to-throwable
(looser still: includes errors that are not directly passable but
whose diagnostic information can be preserved on a copy).

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
