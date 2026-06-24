---
title: The diagnostic-preservation rule
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

The body of `toPassableError` is the canonical implementation of
the rule. When the input error is not a valid passable, the
function:

1. Reads the input's `name` and `message` (both must be present
   and stringable; the implementation calls `String(name)` and
   `String(message)` to be defensive).
2. Reads the `cause` and `errors` property descriptors. If each
   one's value is itself a passable error property descriptor
   (recursive check), the value is preserved.
3. Constructs a new error of the same constructor class (or
   `Error` if the name doesn't match a known constructor), with
   the message, cause, and errors carried in.
4. Hardens the copy and *annotates* it with a note linking back
   to the original: `X\`copied from error ${err}\``.

The note step is what implements the *diagnostic-preservation*
rule. The annotation makes the original error available to the
console-redaction layer (per the `tame-console.js` family) even
though it is not passable. A reader of the console output sees:

- The new passable error's name + message (passes the wire).
- The annotation: "copied from error ${original}", where
  `${original}` is redacted to a quoted-fragment-with-stack but
  whose hidden diagnostic information is still available to a
  trusted observer.

The encoder's bias is therefore: **report whatever information
you can, even if some of it cannot cross the boundary**. The
alternative bias — *reject any error that is not passable* — would
hide information at the moment the user most needs to see it (the
moment of failure). The comment's emphasis on "propagates the
diagnostic info of the original" is a deliberate inversion of
the validate-then-encode discipline the rest of marshal follows.

This same priority shows up at the smallcaps layer in the
[`encodeToSmallcaps.js error-encoding-root-special-case`](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md)
section: there, the encoder pulls error-like values out of the
recursion at the root precisely so that an invalid error can
still emit *some* diagnostic on the wire rather than being
rejected outright. The two patterns are aspects of one rule: the
encoder favors diagnostic information over strict validation
when errors are at stake.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
