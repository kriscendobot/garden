---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
---

# Two CapTP instances cross-wired with shared bootstrap and synchronous trap-bridge

> *Create an async-isolated channel to an object.*
>
> — `packages/captp/src/loopback.js` line 12

`loopback.js` (117 lines) is the **async-isolated-channel
primitive** for `@endo/captp`. Exports `makeLoopback(ourId,
nearOptions, farOptions)` which creates an in-process
*loopback CapTP session* — two CapTP instances bound to each
other so an object on either side travels through the *full
CapTP wire path* (serialize → unserialize) even though no
network is involved.

Last touched 2025-10-09 by Kris Kowal in cycle 108's
coordinated-update commit `e56bf00f`. **Third @endo/captp
source file ingested** after cycle 154's trap.js and cycle
156's finalize.js — the captp cluster's surface continues to
fill in.

The file is the *load-bearing test utility* for CapTP itself.
@endo/captp's own tests use it to exercise CapTP semantics
(including the §synchronous trap from cycle 154) without
ever opening a socket.

## The §single most structurally interesting move — §two-CapTP-instances-cross-wired

```js
const {
  Trap,
  dispatch: nearDispatch,
  getBootstrap: getFarBootstrap,
  // ...
} = makeCapTP(`near-${ourId}`, o => farDispatch(o), bootstrap, { ... });

const {
  makeTrapHandler,
  dispatch: farDispatch,
  getBootstrap: getNearBootstrap,
  // ...
} = makeCapTP(`far-${ourId}`, nearDispatch, bootstrap, farOptions);
```

The §two-CapTP-instances-cross-wired architecture: each side
receives *the other side's* dispatch function as its
*send* hook. When `near` wants to send a message to `far`, it
calls *the function that was passed as its second arg* —
which is `farDispatch` — which the `far` side received as its
*receive* hook.

The §forward-reference-via-arrow observation: the first
`makeCapTP` call wraps `farDispatch` in an arrow function
`o => farDispatch(o)` because `farDispatch` *doesn't exist
yet* at the call site (it's bound by the *second*
`makeCapTP`'s destructure later). The arrow captures the
*binding*, not the value; resolved at *invocation* time when
near actually sends a message. The §closure-captures-binding-
not-value JS-language fact made load-bearing here.

The §eslint-disable-no-use-before-define explicit comments:
*the only way to read this code* is to know that *the
forward references are intentional and necessary*.

```js
// eslint-disable-next-line no-use-before-define
} = makeCapTP(`near-${ourId}`, o => farDispatch(o), bootstrap, {
```

The §eslint-as-design-discipline: the linter would *normally*
flag this; the explicit disable tells future readers (and the
linter) that *this is the load-bearing pattern, not a bug*.

## The §single-bootstrap-shared-by-both-sides shape

```js
const bootstrap = Far('refGetter', {
  getRef(nonce) {
    const xFar = nonceToRef.get(nonce);
    nonceToRef.delete(nonce);
    return xFar;
  },
});
```

The §single-bootstrap-shared-by-both-sides: *the same*
`bootstrap` `Far('refGetter', ...)` is passed to *both*
`makeCapTP` calls. CapTP's `bootstrap` is the *root object*
that the peer side gets when it asks `getBootstrap()`. Here,
both sides expose the *same* root — a one-method exo for
nonce-keyed lookup.

The §getRef-also-deletes pattern: `getRef(nonce)` is *not*
just a read; it *consumes* the entry. The §use-once-then-
remove discipline: nonces are transient. Once `near`'s
`makeFar(x)` registers `x` under nonce `42`, exactly one
`getRef(42)` call returns it; subsequent calls return
`undefined`.

The §nonce-as-handshake-key observation: the *number* `42`
travels over CapTP (it's a passable integer); the *value*
behind it stays local. The receiver uses the nonce to *fetch
the value* back over the wire. The two-trip pattern: send
nonce → receive ref-back.

## The §makeFar / makeNear via §makeRefMaker closure factory

```js
const makeRefMaker =
  refGetter =>
  async x => {
    lastNonce += 1;
    const myNonce = lastNonce;
    const val = await x;
    nonceToRef.set(myNonce, harden(val));
    return E(refGetter).getRef(myNonce);
  };

return {
  makeFar: makeRefMaker(farGetter),
  makeNear: makeRefMaker(nearGetter),
  // ...
};
```

The §two-callers-one-pattern-via-closure discipline:
`makeFar` and `makeNear` differ only in *which bootstrap they
ask*. `makeRefMaker` captures the bootstrap and returns the
per-call function.

The §uniform-async-shape: both `makeFar` and `makeNear` are
*async*, even though only `makeFar` truly *needs* to be (you
might think `makeNear` could be synchronous since it just
hands back its own ref). But the round-trip through `E(refGetter).
getRef(...)` is *eventual* in both cases — the §uniform-shape-
even-when-asymmetry-is-tempting discipline.

The §harden-the-value-before-set: `nonceToRef.set(myNonce,
harden(val))`. The value is hardened *immediately* on the
near side so the §far side cannot affect mutability across
the loopback (it shouldn't be able to anyway, but defense-in-
depth).

## The §uses-finalize.js-Weak-Value-Map observation

```js
const nonceToRef = makeFinalizingMap();
```

Cycle 156's `makeFinalizingMap()` is called *without
arguments* (no finalizer; default `weakValues = false`).

The §plain-Map-via-fakeFinalizingMap path: with default
options, this *is the §graceful-fallback-via-fakeFinalizingMap
branch* from cycle 156. The loopback's nonce-to-ref map is a
*plain Map* wrapped in `Far('fakeFinalizingMap', ...)`.

Why plain Map (not weak)? Because the §use-once-then-remove
discipline ensures nonces *do* get explicitly removed
(`getRef(nonce)` deletes). The weak-values mode would add
non-determinism (§gc-as-side-channel from cycle 156) — *not
what tests want*.

The §test-utility-doesn't-want-gc-nondeterminism observation:
even where weak-value-map *could* be used, the loopback
chooses *not* to — preserving deterministic test behavior.

## The §synchronous-trap-bridge via `trapGuest`

The §single most subtle move is the `trapGuest` option:

```js
const { Trap, dispatch: nearDispatch, ... } = makeCapTP(
  `near-${ourId}`,
  o => farDispatch(o),
  bootstrap,
  {
    trapGuest: ({ trapMethod, slot, trapArgs }) => {
      let value;
      let isException = false;
      try {
        const far = farUnserialize({ body: slotBody, slots: [slot] });
        value = nearTrapImpl[trapMethod](far, trapArgs[0], trapArgs[1]);
      } catch (e) {
        isException = true;
        value = e;
      }
      harden(value);
      return [isException, farSerialize(value)];
    },
    ...nearOptions,
  },
);
```

The §sync-trap-by-crossing-the-boundary-immediately pattern:

1. The near side calls `Trap(x).method(...)` — synchronous-
   blocking semantics from cycle 154.
2. CapTP gives `trapGuest` the message components (method,
   slot, args).
3. `trapGuest` uses *the far side's* `farUnserialize` to
   reconstruct the actual JS object *synchronously*.
4. `nearTrapImpl[trapMethod](far, ...)` is invoked — cycle
   154's trivial local dispatch.
5. Result hardened, serialized back via `farSerialize`,
   returned as `[isException, serializedResult]`.

The §use-the-far-side's-marshal-functions discipline: instead
of going *through* CapTP for the trap, this *reaches across*
to the far side's marshal tables synchronously. The
§trap-bypasses-the-async-protocol property.

The §isException-tagged-tuple-result for the synchronous
return: `[isException: boolean, serialized: capdata]`. The
caller (CapTP's Trap implementation) decodes the tuple and
either throws or returns. The §tagged-tuple-because-no-
Promise-rejection-channel observation: sync calls don't have
a rejection-channel; the tuple replaces it.

The §slotBody-hardcoded-as-canonical-marshal-form: the JSON
literal `{ "@qclass": "slot", "index": 0 }` is precomputed and
shared. It's the *minimal valid marshal body* representing
"the single slot in this message." §canonical-single-slot-
marshal-string discipline.

## The §two-marshal-tables in the loopback

The loopback creates *two CapTP instances*, each with its
*own* slot tables. The `slot`-arg crossing in `trapGuest`
*uses the far side's* marshal tables (`farUnserialize`,
`farSerialize`) because:

- The near side received the message *via near's marshal* —
  the slot-numbers are in *near's* table.
- But the value being passed is *actually a far-side object*
  — to deref it, you must go through *far's* unserialize.

The §which-side's-marshal-tables-do-we-use? question is
answered by *which side owns the object* — not *which side
sent the message*. The §marshal-side-tracks-object-ownership
discipline.

## The §re-export-E-from-captp convenience

```js
import { E, makeCapTP } from './captp.js';
// ...
export { E };
```

The §re-export-E-from-captp convenience: callers `import
{ makeLoopback, E }` from one file rather than two. The §single-
entry-point-for-test-fixtures pattern.

## How loopback fits the @endo/captp picture

The captp cluster now at **three ingested files**:

| File | Role | Cycle |
|------|------|-------|
| `trap.js` | Synchronous user-facing proxy | 154 |
| `finalize.js` | Weak-Value-Map for slot tables | 156 |
| `loopback.js` | In-process test fixture | 158 (this) |

`captp.js` (1012 lines, the wire protocol itself) and
`atomics.js` (170 lines, SharedArrayBuffer substrate) remain
candidates. `loopback.js` is the simplest of the three
ingested because it *composes* the other two — its complexity
is in *how it wires them*, not in *what they each do*.

The §test-utility-composes-substrate pattern: the test
fixture *exercises* the production code; it sits *one layer
up* from the substrate. Reading the loopback teaches the
production code by *seeing how it's used*.

## The §canonical pattern: two-process simulation via shared-bootstrap

The loopback's architecture is reusable beyond CapTP testing:
the *shared-bootstrap + nonce-keyed ref-table + cross-wired
dispatch* pattern is the standard way to *test a distributed
protocol in-process*. The §test-the-distributed-protocol-in-
process discipline names:

- **Two endpoints** that *believe* they're remote (so they
  exercise the wire format).
- **Cross-wired dispatch** so messages flow between them.
- **Shared bootstrap** for handshake / introductory refs.
- **Nonce-based ref-passing** so test code can hand specific
  values to specific sides.

§distributed-protocol-test-fixture-as-genre.

## Related sections

- cycle 154
  [[endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check]]
  — this file uses `nearTrapImpl` from cycle 154's trap.js
  inside the `trapGuest` synchronous bridge.
- cycle 156
  [[endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability]]
  — this file uses `makeFinalizingMap()` from cycle 156 (in
  the §plain-Map-via-fakeFinalizingMap default branch);
  illustrates cycle 156's §test-utility-doesn't-want-gc-
  nondeterminism observation.
- cycle 146
  [[endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets]]
  — the re-exported `E` originates here.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — the `Far('refGetter', ...)` factory consumed in the
  bootstrap.
