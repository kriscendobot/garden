---
title: toPassableError and toThrowable — diagnostic-information preservation and the exo-boundary throwable contract
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
---

## Abstract

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

## The comments as written

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

## The diagnostic-preservation rule

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

## The throwable layer above passable

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

## How toPassableError mediates between the two layers

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

## The TODO trail and the implementation gap

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

## Implications

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

## See also

- [`endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case`](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md)
  — the smallcaps-layer companion to this rule. The same
  diagnostic-preservation bias shapes the wire format's choice
  to pull errors out of recursion at the root.
- [`endo--docs-errors--hiding-revealing-local-diagnostic`](endo--docs-errors--hiding-revealing-local-diagnostic.md)
  — the canonical Endo errors framework. The
  diagnostic-information / redacted-message split is the
  architectural choice that makes `toPassableError`'s
  copy-with-annotation pattern useful: the original error's
  hidden diagnostic flows into the redaction layer while the
  copy is what crosses the wire.
- [[principle-of-least-authority]] — `toThrowable`'s
  no-PassableCap rule is POLA at the failure-path boundary. A
  throw that contains a remotable is a delegation of authority on
  a path the reviewer most likely overlooks; making throws
  authority-free narrows the surface that demands per-method
  review.
- [[security-as-extreme-modularity]] — the exo-boundary
  throwables-only contract enacts Table 1's "say what you mean /
  mean only what you say" row: the throw type is the contract,
  and constraining it makes the contract enforceable.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
