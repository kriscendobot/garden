---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §sender-side — §encode Error reasons before stringify
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

The diff in `packages/daemon/src/connection.js`'s
`messageToBytes`:

```js
export const messageToBytes = message => {
  let outgoing = message;
  if (message?.type === 'CTP_DISCONNECT' && message.reason instanceof Error) {
    const { name, message: errMessage, stack } = message.reason;
    outgoing = {
      ...message,
      reason: { '@@error': true, name, message: errMessage, stack },
    };
  }
  const text = JSON.stringify(outgoing);
  const bytes = textEncoder.encode(text);
  return bytes;
};
```

The §three-property-extraction (name + message + stack)
matches what cycle 87's `pass-style/error.js` defines as the
four-property error allowlist (`message`/`stack`/`cause`/
`errors`); the design takes the three single-Error properties
and leaves `cause` aside (deferred to future work).

The §sentinel-not-duck-typing discipline:

> *The `'@@error': true` sentinel marks the encoded shape so
> the receiver can decide whether to reconstruct an `Error`
> instance or just render the fields. The sentinel is
> preferable to duck-typing on `'message' in reason && 'stack'
> in reason` because nothing prevents an application from
> sending a plain object with those field names.*

The §unique-sentinel-not-presence-of-fields discipline: a
plain object `{ name, message, stack }` *could be the
intended payload*. The `'@@error': true` sentinel
*unambiguously* signals "this was an Error instance on the
sender side". The §`@@`-prefix-convention propagates the
cycle 148 (symbol.js Hilbert-Hotel) discipline that `@@`-
prefixed names are *reserved* for system-level encoding.

The §narrow-guard-keeps-out-of-hot-path discipline: *The
narrow guard on `message.type === 'CTP_DISCONNECT'` keeps the
change out of the hot path for `CTP_CALL` and friends, which
already serialize Error fulfilments through `@endo/marshal`*.

§Hot-path-vs-cold-path partition: the disconnect path is
*cold* (fires once at session end). Adding logic there is
free. The call path (`CTP_CALL`/`CTP_RETURN`/`CTP_RESOLVE`)
is *hot* (every method invocation). Touching `messageToBytes`
*generally* would impose per-call cost. The §narrow-guard
keeps the cost on the cold path only.
