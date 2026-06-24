---
title: Body
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "98-132, 158-170, 269-321"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "Why marshal sends Errors even if not Passable; deliberate no-stack-sharing with errorId-for-correlation; late-addition tolerance (cause/errors/errorId); descriptor properties use annotateError rather than decodeRecur"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, errors, capability-security]
status: current
parent: endo--packages-marshal-src-marshal-js--error-diagnostic-priority
---

### "Even if an Error is not actually passable"

The encoder's JSDoc above `encodeErrorCommon` and the duplicated
JSDoc above `encodeErrorToCapData` make the same claim twice, in
identical prose:

> Even if an Error is not actually passable, we'd rather send it
> anyway because the diagnostic info carried by the error is more
> valuable than diagnosing why the error isn't passable. See
> comments in isErrorLike.

The duplication is deliberate: `encodeErrorCommon` is shared
between the capdata and smallcaps encoders, and the
`encodeErrorToCapData` wrapper carries the same rationale at its
own definition site so a reader walking the capdata branch does
not have to chase up to the common helper. The
[error-encoding-root-special-case](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md)
section in the sibling `encodeToSmallcaps.js` source covers the
*pre-recursion* `isErrorLike` branch that this rationale points
at; the comment here in `marshal.js` is the upstream rule that the
sibling implements at the root of the encoding tree.

The substantive consequence: when an application throws an Error
that is itself unfrozen, or carries non-passable own properties,
or whose `cause` chain has a non-passable node, the encoder still
produces a wire encoding rather than throwing an
"unencodable Passable" error. The wire encoding loses the
non-passable parts but preserves the `message`, the constructor
`name`, and the optional `errorId` annotation. The peer's
`decodeErrorCommon` reconstructs a usable Error with the surviving
fields. The diagnostic information that *would have been lost* if
the encoder rejected the value is the information that lets the
application discover *why* the operation failed.

### Deliberate no-stack-sharing with errorId-for-correlation

Inside the `errorTagging === 'on'` branch, the comment lays out
the rationale for not putting the stack on the wire:

> We deliberately do not share the stack, but it would be useful
> to log the stack locally so someone who has privileged access to
> the throwing Vat can correlate the problem with the remote Vat
> that gets this summary. If we do that, we could allocate some
> random identifier and include it in the message, to help with
> the correlation.

This passage is dense. Three claims:

1. **The stack is privileged information** that the throwing Vat
   should not push to a counterparty. The stacktrace mentions
   internal symbol names, file paths, and (potentially) credential
   tokens captured in closures the formatter dumps; leaking it
   crosses an authority boundary the Vat boundary is meant to
   uphold.
2. **The stack is still valuable locally.** A privileged operator
   inspecting the throwing Vat (an SRE, an audit log, a panel
   reviewer) wants to be able to correlate the redacted summary
   the peer received with the rich local stack the throwing Vat
   has.
3. **The correlation needs an identifier.** A random per-error
   identifier is allocated, sent to the peer in the `errorId`
   field, and annotated onto the local error via `annotateError(
   err, X`Sent as ${errorId}` )`. The peer's `Remote<Name>(
   errorId )` constructor-name suffix surfaces the identifier on
   the receiving side; a local operator can grep their Vat's logs
   for "Sent as <errorId>" to find the original stack.

The `nextErrorId` function (lines 66-69) implements the allocation
by concatenating the `marshalName` instance label with a
monotonically-bumped counter from the `errorIdNum` option (default
`10000`). The label distinguishes errors from different marshal
instances co-resident in one Vat; the counter ensures uniqueness
within an instance. The `marshalSaveError(err)` call after
annotation is the customer-supplied hook that pushes the locally
annotated error to wherever the customer wants to find it later
(default: `console.log('Temporary logging of sent error', err)`,
with an explicit comment that the *real* answer is for the caller
to log to "somewhere hidden to be revealed when correlating with
the received error").

The annotation pattern is the local counterpart to the wire
`errorId`: both sides see the same identifier, but the sending
side sees the full stack and the receiving side sees only the
summary plus the identifier. The privileged correlator bridges
the two views.

### Late-addition tolerance — `errorId`, `cause`, `errors`

The decoder side (`decodeErrorCommon`, lines 269-321) implements a
three-field optional-decode pattern:

```js
const {
  errorId = undefined,
  message,
  name,
  cause = undefined,
  errors = undefined,
  ...rest
} = errData;
```

`errorId` defaults to `undefined`; `cause` defaults to
`undefined`; `errors` defaults to `undefined`. The
just-before-decode comment explains:

> errorId is a late addition so be tolerant of its absence.

The same rule applies to `cause` and `errors`, which the encoder
side flags as a TODO:

> Must encode `cause`, `errors`, but only once all possible
> counterparty decoders are tolerant of receiving them.

The decoder is **already tolerant of receiving them**; the
encoder is **not yet emitting them** until counterparty decoders
universally tolerate the fields. The pattern is a two-step ratchet:

1. First, decoders are taught to tolerate the new field (defaults
   to undefined; optional decode; no error if absent). Land this
   step and let it propagate across the deployment fleet.
2. Then, encoders begin emitting the field. By the time an encoder
   sends the field, every decoder it could reach already knows how
   to decode-or-skip it.

The encoder-then-decoder ordering does not work: a fielded encoder
talking to an older decoder would produce a hard error rather than
silently lose the field. The decoder-then-encoder ordering trades
silent-loss-during-transition for forward-compatibility. The
comment names "all possible counterparty decoders" as the gate,
which is operationally the deployment-front-running constraint.

The `errorId` case is the worked example of step 1 already
completed: `errorId` is decoded optionally and used to build the
`Remote<Name>(errorId)` constructor-name suffix; counterparties
that don't send it produce `Remote<Name>` with no suffix and the
decoder works either way.

### Descriptor properties use annotateError, not decodeRecur

The decoder's final pass over rest-bag properties (lines 308-318)
takes own properties that didn't match the `errorId` / `message` /
`name` / `cause` / `errors` recognizer and attaches them as
**non-enumerable, non-writable, non-configurable** descriptor
properties on the rawError, with their values decoded recursively
but their *names* left untransformed. The comment justifies:

> Note that this does not decodeRecur rest's property names. This
> would be inconsistent with smallcaps' expected handling, but is
> fine here since it is only used for `annotateError`, which is
> for diagnostic info that is otherwise unobservable.

Two parts to unpack:

1. **The smallcaps-consistency point.** A smallcaps-encoded
   property name might start with a sigil that needs escaping; a
   strict "decodeRecur both names and values" decoder would unescape
   the names. The marshal `decodeErrorCommon` skips that step
   because the names are not part of the user-observable error
   shape; they're an internal vehicle for `annotateError`'s
   diagnostic metadata.
2. **The unobservability assertion.** `annotateError` writes
   properties whose primary use is being inspected by audit code
   or a debugger, not by the application that catches the error.
   The Error's `.message`, `.name`, `.cause`, `.errors`,
   `.stack`, and constructor identity are the user-visible
   surface; the rest is annotation. Skipping `decodeRecur` on
   names is a small cost to a non-observable surface, in exchange
   for not having to re-implement the smallcaps name-unescape on
   the marshal side.

This is a worked example of "*observable* vs *unobservable*"
informing serialization decisions. The unobservable annotations
get a relaxed contract; the observable error surface (`message`,
`name`, `cause`, `errors`) gets the strict round-trip-through-
`decodeRecur` discipline.

### Why this matters beyond marshal

The four decisions in this section thread into a broader Endo
discipline: **diagnostic information is a first-class authority
that the system spends real complexity to preserve**, and the
preservation is not free. Choices that other serialization
libraries make implicitly (drop the value; throw on the failure
to encode) marshal makes explicitly the other way (send the
salvage; preserve the diagnostic). The cost is the comment-cluster
the decoder side has to maintain: every error decoding becomes a
tolerance-and-correlation problem rather than a pure structural
decode.

For the system architect this means: when a remote operation
fails in production, the message a user sees is
`Remote<Name>(errorId)`; the developer's path to root-cause is to
look up `errorId` in the throwing Vat's marshalSaveError sink.
That sink is the back-channel the marshal designers built into
the wire contract — it's not an accident.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L98-L321) at commit `da16a78e`.
