---
title: Safe promises versus passable promises and the reentrancy attack the distinction defends against
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
---

## Abstract

`HandledPromise.resolve(p)` must be safe to call on an *untrusted*
promise `p` without `p` getting a synchronous attack window. The
attack surface is the call to `p.then` (or to `await p`, which
desugars to `p.then`): if `p` overrides `then` or `constructor`, it
can run attacker-controlled code during what looks to the caller
like a passive resolution step. The shim defends with the
`isSafePromise(p)` predicate, which checks that `p` is frozen, has
the genuine `Promise.prototype`, is the canonical
`Promise.resolve(p)` fixpoint, and has no own `then` or
`constructor` descriptors. When the predicate holds, the shim
short-circuits and treats `p` as the answer directly; when it does
not, the shim assimilates `p` as if it were a non-promise thenable
and re-wraps it in a fresh `HandledPromise`. The comment
acknowledges a residual gap: the predicate itself reads `p`'s
properties synchronously, so a sufficiently malicious `p` could
mount a reentrancy attack *during the predicate evaluation*. This
gap is a known limitation of the current JS standard that the shim
cannot close locally. The related but stricter notion of a
*passable* promise (`passStyleOf(p) === 'promise'`) adds the
no-own-properties requirement that marshal needs for wire
serialization; every passable promise is also safe, but not every
safe promise is passable.

## Body

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

## Implications

- The two-tier (safe / passable) classification is the canonical
  rationale for marshal's `passStyleOf(p) === 'promise'` being
  *more restrictive* than what the eventual-send shim requires.
  A new-pass-style proposal that loosened passability to match
  safety would re-introduce the same own-property hazard marshal
  is defending against on the wire.
- The `await p` call inside `HandledPromise.resolve` is the
  reason the `constructor` descriptor must be missing. A
  reviewer reading the body without the comment might think the
  `constructor` check is paranoid; it is in fact load-bearing
  for the `await` semantics.
- The reentrancy gap is the kind of limitation that motivates
  *capability hygiene at the boundary*: a daemon receiving a
  promise from an outside source should treat it as untrusted
  until it has been laundered through `HandledPromise.resolve`,
  and even then it should treat the resolved value as untrusted
  until the daemon's own validators have passed it.

## Common confusions

- **"`isFrozen` is the same as `harden`."** No.
  `Object.isFrozen` is the host's structural test; `harden` is
  the SES recursive transitive freeze. The shim uses `isFrozen`
  because the predicate is run on a promise the shim itself
  cannot harden (it does not own `p`). A locally-constructed
  promise that the shim *can* harden gets the deeper guarantee.
- **"Why not call `harden(p)` before the check?"** Hardening
  would mutate the promise's metadata in a way the caller did
  not consent to. The shim's contract is to read `p` without
  side-effecting on it.

## See also

- [[object-capability]] — the safety check is one of Endo's
  trust-boundary discipline points; the residual gap is a
  reminder that pure JS without language-level integrity
  primitives cannot fully close every reentrancy hazard.
- [`endo--pkg-marshal-readme--overview`](endo--pkg-marshal-readme--overview.md) — marshal's
  pass-style framework; this section explains the safety-vs-passability gap from the eventual-send side.
- [`endo--pkg-pass-style-readme--overview`](endo--pkg-pass-style-readme--overview.md) — pass-style's
  side of the same invariant: a passable promise is also safe by
  construction.
- [`endo--docs-lockdown--unhandled-rejection-trapping`](endo--docs-lockdown--unhandled-rejection-trapping.md) — adjacent
  lockdown concern: untrusted promises that are never awaited.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
