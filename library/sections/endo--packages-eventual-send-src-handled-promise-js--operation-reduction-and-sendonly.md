---
title: Operation reduction in dispatchToHandler — SendOnly substitution, applyMethod via get+applyFunction, and the minimal handler surface
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "122-194"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "How dispatchToHandler reduces the six-operation API to a three-method minimum, and why SendOnly is a wrapper around the corresponding non-SendOnly operation"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, captp]
status: current
---

## Abstract

The handler protocol exposes six operations to a `HandledPromise`
handler: `get`, `applyFunction`, `applyMethod`, and a `SendOnly`
variant of each (`getSendOnly`, `applyFunctionSendOnly`,
`applyMethodSendOnly`). A naive handler implementation would need
to write all six, with most of the SendOnly bodies trivially
identical to their non-SendOnly counterparts. The shim collapses
this surface in two ways, documented inline in `dispatchToHandler`:
(1) a SendOnly operation that the handler does not implement
substitutes the non-SendOnly version and discards the returned
promise, so a handler only needs to implement the SendOnly variant
when there is a genuine optimisation to exploit (no remote return
trip, no causality token); (2) `applyMethod` decomposes into
`get` followed by `applyFunction` when the handler omits
`applyMethod`, and `applyFunction` bottoms out into `applyMethod`
with an `undefined` method name when the handler omits
`applyFunction`. The net consequence is that a handler with only
`get` and `applyMethod` can correctly serve all six operations;
the shim composes the rest. This is the contract a CapTP or
OCapN handler implementation relies on, and it is why the
upstream interface table in handled-promise's `Handler` typedef
marks every field optional.

## Body

### The SendOnly substitution

The `dispatchToHandler` body opens with a regex against the
operation name:

```js
const matchSendOnly = SEND_ONLY_RE.exec(actualOp);
```

When the match succeeds (the operation name ends in `SendOnly`)
and the handler does not implement that specific method, the
shim rewrites `actualOp` to the base operation name (the regex's
capture group) and continues:

```js
if (matchSendOnly && typeof handler[actualOp] !== 'function') {
  actualOp = /** @type {'get' | 'applyMethod' | 'applyFunction'} */ (
    matchSendOnly[1]
  );
}
```

The result of the base call is then discarded (the `makeResult`
wrapper returns `undefined` when `matchSendOnly` is truthy). The
*meaning* of this substitution is: "if the handler did not
specialise the no-return-trip variant, fall through to the
return-trip variant and throw away the trip." A remote handler
that wanted to avoid the return trip would implement the
SendOnly variant explicitly; a local handler typically does not
specialise, because the local call is cheap and the SendOnly
optimisation only pays off when the round-trip is observable.

### The applyMethod-as-get-plus-applyFunction reduction

When the operation is `applyMethod` (after any SendOnly
substitution) and the handler does not implement `applyMethod`,
the shim composes the missing operation:

```js
if (actualOp === 'applyMethod') {
  // Compose a missing applyMethod by get followed by applyFunction.
  const [prop, args] = opArgs;
  const getResultP = handle(
    o,
    'get',
    [coerceToObjectProperty(prop)],
    undefined,
  );
  return makeResult(handle(getResultP, 'applyFunction', [args], returnedP));
}
```

The shim re-enters `handle` twice: once to fetch the property
value (`get`), and once to apply the resulting function to the
argument list (`applyFunction`). The `returnedP` is threaded
through to the second sub-operation only, because that is the
operation whose result is observable. The intermediate
`getResultP` is itself a `HandledPromise`, so the second
sub-operation is a *pipelined* call on a not-yet-resolved
target — this is the data-flow point at which promise pipelining
emerges from the shim's reductions, even when the handler does
not know it is being pipelined.

### The applyFunction-as-applyMethod fallback

The final reduction handles handlers that implement only
`applyMethod` (a method-call interface) but want to support
function-call semantics too:

```js
if (actualOp === 'applyFunction') {
  const amfn = handler.applyMethod;
  if (typeof amfn === 'function') {
    // Downlevel a missing applyFunction to applyMethod with undefined name.
    const [args] = opArgs;
    const result = apply(amfn, handler, [o, undefined, [args], returnedP]);
    return makeResult(result);
  }
}
```

The shim invokes the handler's `applyMethod` with an `undefined`
method name, signalling "apply this presence directly, as if it
were a function." A handler that wants to distinguish
function-presence from method-call dispatch can branch on
`prop === undefined`; a handler that does not care can treat both
identically.

### Why this matters for handler implementers

Putting the three reductions together, the **minimum viable
handler** is:

- `get(target, prop, returnedP?)` to fetch a property as an
  eventual-reference.
- `applyMethod(target, prop, args, returnedP?)` to invoke a
  method (`prop` may be `undefined`, in which case the target
  itself is treated as the callable).

The shim composes the four remaining operations (`getSendOnly`,
`applyFunction`, `applyFunctionSendOnly`, `applyMethodSendOnly`)
from these two. The default `forwardingHandler` near the end of
the file is more aggressive — it implements all six against the
local fallback functions in `local.js` — but that is a
specialisation choice, not a requirement of the protocol.

The terminal failure case is the `throw assert.fail(...)` after
the reductions: if the handler implements *none* of the methods
needed to serve the current operation (after all reductions have
been tried), the shim throws a `TypeError` quoting the handler's
method names. This is a programmer-error case; production
handlers should not reach it.

## Implications

- A **CapTP author** implementing a remote presence's handler
  typically writes `get` and `applyMethod` against the wire
  protocol's question/answer ops, and lets the shim derive the
  rest. The optimisation lever is the SendOnly variants: a
  CapTP handler implements them explicitly when the wire protocol
  has a fire-and-forget primitive that skips the answer slot
  allocation.
- **Promise pipelining emerges from the reductions, not from a
  separate primitive.** When `applyMethod` decomposes into `get`
  followed by `applyFunction`, the intermediate `getResultP` is
  a `HandledPromise` that the shim will route through its own
  pending handler. If the handler has not yet resolved the
  target, the subsequent `applyFunction` queues against the same
  pending state, pipelining through the comm layer transparently.
  This is the implementation-side anchor of the user-facing
  `promise-pipelining` story in the @endo/eventual-send README.
- **The pass-through pattern in `dispatchToHandler` is shared with
  the `forwardingHandler` at the bottom of the file**, which
  routes operations from a *presence* (a resolved remote object)
  back into the same `handle` machinery. A reviewer changing the
  reduction logic should expect to touch both call sites; they
  are intentionally parallel.

## Translation

| Shim term | Handler-implementer term |
| --------- | ----------------------- |
| `get` | property access (`E(target).prop` or `E.get(target, prop)`) |
| `applyMethod` | method call (`E(target).method(args)`) |
| `applyFunction` | function call against a callable presence |
| `*SendOnly` | fire-and-forget variant; no answer slot reserved |
| `returnedP` | the promise the *caller* is awaiting; the handler may resolve it directly, or let the shim resolve it from the operation's return value |
| `o` | the resolved (or pending) target the handler is dispatching against |
| `opArgs` | operation-specific argument tuple; for `applyMethod` it is `[prop, args]`, for `applyFunction` it is `[args]`, for `get` it is `[prop]` |

## See also

- [`endo--pkg-eventual-send-readme--e-method-call`](endo--pkg-eventual-send-readme--e-method-call.md) — the
  user-facing description of `E(target).method(args)`; this
  section is the implementation-side rationale for why all six
  surface operations are dispatched through the same reducer.
- [`endo--pkg-eventual-send-readme--promise-pipelining`](endo--pkg-eventual-send-readme--promise-pipelining.md) — the
  user-facing pipelining narrative; this section names the
  reduction step at which pipelining mechanically emerges.
- [`endo--pkg-captp-readme--usage`](endo--pkg-captp-readme--usage.md) — CapTP's
  surface; CapTP handlers implement the minimal `get` /
  `applyMethod` pair plus SendOnly optimisations where the wire
  protocol supports fire-and-forget.
- [`ocapn--draft-specifications-captp--promises`](ocapn--draft-specifications-captp--promises.md) — the
  wire-protocol's promise/answer slot model; the SendOnly
  optimisation maps to the protocol's no-answer-needed encoding.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
