---
title: Body
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
parent: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly
---

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

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
