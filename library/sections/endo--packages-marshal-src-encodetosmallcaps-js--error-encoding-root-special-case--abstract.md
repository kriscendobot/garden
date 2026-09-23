---
title: Abstract
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "276-293"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps pulls error-like values out of the recursion at the root: errors that are not valid Passables (e.g., unfrozen errors) should still be encodable, because reporting their diagnostic information trumps reporting the failure to report"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style, errors]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case
---

The `encodeToSmallcaps` wrapper checks `isErrorLike(passable)` at
the **root** of the encode call and routes error-like values
directly through `encodeErrorToSmallcaps` rather than through
`encodeToSmallcapsRecur`. The longform bare-block comment above
the special case explains both *why* the case exists (errors are
often diagnostic objects that may not be valid Passables — they
may not be frozen, they may carry non-passable own properties)
and *why it can only apply at the root* (an error nested inside a
passable structure would have to itself be passable, by
transitive closure, so the only place a non-passable error can
appear is at the very top). The substantive point the comment
makes is a **diagnostic-information priority claim**: when the
caller passes an error to the encoder, the caller's intent is to
*report* whatever the error carries, so the encoder must not
itself fail by raising a "this error is not a valid Passable"
complaint. The comment is the canonical rationale for what
otherwise looks like an awkward special case wedged outside the
recursion.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L276-L293) at commit `e56bf00f`.
