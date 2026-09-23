---
title: Body
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "369-401"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "isSafePromise: the safety predicate, its relationship to marshal's passable-promise classification, and the residual reentrancy gap the check cannot close"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, capability-security, marshal]
status: current
parent: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise
---

### The check, line by line

The `isSafePromise(p)` body is five conjunctions:

```js
isFrozen(p) &&
  getPrototypeOf(p) === Promise.prototype &&
  Promise.resolve(p) === p &&
  getOwnPropertyDescriptor(p, 'then') === undefined &&
  getOwnPropertyDescriptor(p, 'constructor') === undefined
```

Each conjunct names a category of attack the shim refuses to be
exposed to:

1. **`isFrozen(p)`.** A non-frozen `p` could have its prototype
   chain or own properties mutated between the safety check and any
   subsequent use; the freeze is the temporal anchor that lets the
   remaining four conjuncts be persistent.
2. **`getPrototypeOf(p) === Promise.prototype`.** The intrinsic
   `Promise.prototype` is the only prototype `lockdown` permits to
   carry the genuine `then` implementation. Any other prototype is
   a custom subclass and might override `then`.
3. **`Promise.resolve(p) === p`.** The fixpoint check certifies
   that `p` is in fact a JS promise (not a thenable masquerading
   as one) and that the host's `Promise.resolve` machinery agrees
   it is *its own* resolved form. A thenable that returns a
   different object from `Promise.resolve` is not safe.
4. **No own `then` descriptor.** Inherited `then` from
   `Promise.prototype` is the genuine one; an own `then` would
   shadow it and run before the genuine implementation gets called.
5. **No own `constructor` descriptor.** `await p` calls into
   `p.constructor[Symbol.species]` for the result-promise's
   construction. An own `constructor` would let `p` substitute a
   subclass whose `then` is custom.

When all five hold, the comment-blessed conclusion is that the
shim "can use the `resolvedPromise` directly, since it is
guaranteed to have a `then` which is actually
`Promise.prototype.then`." When any one fails, the shim does not
trust `p` to behave under `.then`; instead it wraps `p` in a fresh
`HandledPromise` whose executor invokes `p.then` only inside the
new promise's controlled construction context.

### Safe vs passable: marshal's stricter requirement

The longform comment is explicit that *safe* is a strictly weaker
notion than *passable*:

> The `@endo/marshal` package defines a related notion of a
> *passable* promise, i.e., one for which `passStyleOf(p) === 'promise'`.
> All passable promises are also safe. But not vice versa because
> the requirements for a promise to be passable are slightly
> greater. A safe promise must not override `then` or `constructor`.
> A passable promise must not have any own properties. The
> requirements are otherwise identical.

The two-axis difference matters because:

- `HandledPromise.resolve` needs *safety* to defend its own
  control flow. It is a local operation; the promise stays in
  the current vat.
- Marshal needs *passability* because the promise is about to
  cross a vat boundary. Wire serialization classifies promises by
  pass style; an own property on a promise has no canonical
  marshal encoding and would silently drop on the wire (or worse,
  re-emerge with a different identity on the receiving side).

The asymmetry is a soft invariant for handler authors: if your
handler is going to forward a promise to a CapTP or OCapN
transport, you need *passability*; if you only need to receive a
promise into local resolution, *safety* suffices.

### The residual gap

The comment acknowledges a limit it cannot close:

> Unfortunately, due to limitations of the current JavaScript
> standard, it seems impossible to prevent `p` from mounting a
> reentrancy attack during the evaluation of `isSafePromise(p)`,
> and therefore during operations like `HandledPromise.resolve(p)`
> that call `isSafePromise(p)` synchronously.

The residual attack surface is that `getOwnPropertyDescriptor`
and `getPrototypeOf` call into Proxy traps (if `p` is a Proxy),
and `Promise.resolve(p)` calls `p.then`. A malicious `p` can
observe the safety-check's read pattern and adversarially time
side effects to occur during the check. The shim cannot prevent
this in the current standard because there is no host primitive
for "structural inspection that bypasses all traps and getters."
The mitigation is **upstream**: any code that hands the shim an
untrusted `p` should harden it first, or wrap it in a presence
proxy that does not pass-through. This is what the shim's
`harden(handleArgs)` line near the top of `handle()` is doing
for the operation arguments; the comment does not extend the
same hardening to `p` because the caller's contract is to pass
already-trusted promises into `HandledPromise.resolve`.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
