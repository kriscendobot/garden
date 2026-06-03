---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
---

# Weak-Value-Map via `WeakRef` + `FinalizationRegistry` with gc-as-side-channel warning and end-of-turn stability

> *Both the ability to create one, as well as each created
> one, must be treated as dangerous capabilities that must be
> closely held. A program with access to these can read side
> channels though gc that do not rely on the ability to
> measure duration. This is a separate, and bad, timing-
> independent side channel.*
>
> — `packages/captp/src/finalize.js` lines 31-34

`finalize.js` (141 lines) is the **Weak-Value-Map primitive**
for `@endo/captp`. Single export `makeFinalizingMap(finalizer,
opts)`. Authored by Mark S. Miller; last-touched 2025-06-23
(commit `5efcf7dd0` — *refactor(pass-style): faster `isObject`
(#2860)*).

This file is the **second @endo/captp source file** ingested
after cycle 154's trap.js. Where trap.js is the *user-facing
synchronous-CapTP proxy*, finalize.js is the *slot-table
substrate* that lets CapTP release export-side entries when
the JS values they point to are garbage-collected.

## The §load-bearing-definition — §weak-on-values-not-on-keys

> *Elsewhere this is known as a "Weak Value Map". Whereas a
> std JS WeakMap is weak on its keys, this map is weak on its
> values. It does not retain these values strongly. If a
> given value disappears, then the entries for it disappear
> from every weak-value-map that holds it as a value.*

The §weak-on-values-not-on-keys distinction. Standard JS
WeakMap allows GC of *keys*; this map allows GC of *values*.
The §dual-of-WeakMap framing.

The §keys-stay-but-entries-disappear semantic: when a value is
collected, the entry vanishes from *every* weak-value-map
holding it. The §multi-map-coordinated-removal property
emerges from `FinalizationRegistry`'s broadcast nature: one GC
event fires the finalization callback in every map that
registered the value.

The §typedef-as-Pick-with-additions: the JSDoc *types* the
returned object as `Pick<Map<K,V>, 'get'|'has'|'delete'> & {
set, clearWithoutFinalizing, getSize }`. The §narrowed-Map-
interface discipline names only the methods the consumer
actually needs.

## The §single most structurally interesting move — §gc-as-side-channel warning

The JSDoc explicitly warns about the security hazard:

> *Unlike a WeakMap, a weak-value-map unavoidably exposes the
> non-determinism of gc to its clients. Thus, both the ability
> to create one, as well as each created one, must be treated
> as dangerous capabilities that must be closely held. A
> program with access to these can read side channels though
> gc that do not rely on the ability to measure duration. This
> is a separate, and bad, timing-independent side channel.*

The §timing-independent-side-channel observation: most side
channels need a clock (you measure *how long* something takes;
that reveals state). The §gc-side-channel is different — you
just *observe whether an entry still exists*; gc decisions
flow into program state without a clock at all.

The §closely-held-capability discipline: both the *factory*
(`makeFinalizingMap`) and each *map instance* are dangerous
capabilities. Distribute access narrowly.

The §blockchain-replay hazard escalation:

> *This non-determinism also enables code to escape
> deterministic replay. In a blockchain context, this could
> cause validators to differ from each other, preventing
> consensus, and thus preventing chain progress.*

The §nondeterminism-breaks-consensus observation: blockchain
validators *must* compute identical state transitions. If
their gc fires differently, their weak-value-maps differ, and
their state transitions diverge. The §gc-as-consensus-blocker
warning. The §deterministic-replay-as-consensus-requirement
property.

This warning is *load-bearing for the whole @endo/captp
package*: CapTP needs this primitive but the Agoric blockchain
context cannot afford it. The §primitive-exists-but-must-not-
be-used-in-some-contexts discipline: the file *provides* the
mechanism but *warns away* one class of consumer.

## The §two-mode design — §graceful-fallback-via-fakeFinalizingMap

```js
const { weakValues = false } = opts || {};
if (!weakValues || !WeakRef || !FinalizationRegistry) {
  /** @type Map<K, V> */
  const keyToVal = new Map();
  return Far('fakeFinalizingMap', {
    clearWithoutFinalizing: keyToVal.clear.bind(keyToVal),
    ...
  });
}
```

The §three-fallback-conditions: when `weakValues = false`
*or* `WeakRef` unavailable *or* `FinalizationRegistry`
unavailable, fall back to a plain `Map`. The §degrade-to-
strong-map discipline: the same surface (get/has/set/delete/
clearWithoutFinalizing/getSize) works whether the map is
actually weak.

The §far-tagged-`fakeFinalizingMap` shape: the Far tag
*explicitly says fake*. The §honest-tagging-when-degraded
discipline: a future debugger sees the *fake* tag and knows
the underlying map is strong. The §tag-tells-the-truth
property.

The §opt-in-via-`weakValues` defaulting to `false`: the
*dangerous* mode requires explicit opt-in. The §dangerous-
mode-not-default discipline (parallel to cycle 145's read-
only-default-edit-toggle and cycle 138's safe-promise's
*default-safe*).

## The §FinalizationRegistry callback with §unregister-immediately-suppresses-finalization assumption

```js
const registry = new FinalizationRegistry(key => {
  // Because this will delete the current binding of `key`, we need to
  // be sure that it is not called because a previous binding was collected.
  // We do this with the `unregister` in `set` below, assuming that
  // `unregister` *immediately* suppresses the finalization of the thing
  // it unregisters. TODO If this is not actually guaranteed, i.e., if
  // finalizations that have, say, already been scheduled might still
  // happen after they've been unregistered, we will need to revisit this.
  finalizingMap.delete(key);
});
```

The §registry-callback-routes-through-delete pattern: gc
fires the registry callback; the callback calls
`finalizingMap.delete(key)`; which calls the user-supplied
finalizer. The §unified-finalize-path: gc / explicit delete /
set-overwrite all converge on `delete`.

The §unregister-immediately-suppresses-finalization
assumption is explicitly named:

> *assuming that `unregister` immediately suppresses the
> finalization of the thing it unregisters. TODO If this is
> not actually guaranteed, i.e., if finalizations that have,
> say, already been scheduled might still happen after
> they've been unregistered, we will need to revisit this.*

The §honest-acknowledgment-of-spec-uncertainty discipline.
The author *names* the assumption *they're relying on* and
flags that *if the spec is more permissive*, this code needs
revisiting. The §explicit-assumption-as-TODO pattern.

## The §end-of-turn stability invariant

> *JS standards weakrefs have been carefully designed so that
> operations which `deref()` a weakref cause that weakref to
> remain stable for the remainder of that turn. The operations
> below guaranteed to do this derefing are `has`, `get`,
> `set`, `delete`. Note that neither `clearWithoutFinalizing`
> nor `getSize` are guaranteed to deref. Thus, a call to
> `map.getSize()` may reflect values that might still be
> collected later in the same turn.*

The §JS-standards-WeakRef-end-of-turn-stability invariant.
The spec is designed so that *touching* a weakref via
`deref()` *prevents* the referenced object from being
collected for the rest of that turn. Within a synchronous
turn, multiple `deref()` calls on the same WeakRef must return
the same result.

The §method-by-method derefing classification:

| Method | Derefs? | Stability guarantee |
|--------|---------|---------------------|
| `get(key)` | yes | weakly-pointed value pinned for turn |
| `has(key)` | yes (delegates to `get`) | same |
| `set(key, ref)` | yes (deletes old first) | both old + new values pinned for turn |
| `delete(key)` | yes | weakly-pointed value pinned for turn (and finalizer runs) |
| `clearWithoutFinalizing()` | **no** | values may be collected mid-turn |
| `getSize()` | **no** | size may reflect values that get collected later in the turn |

The §clearWithoutFinalizing-and-getSize-are-the-exceptions
observation: these *don't* deref. The §atomicity-within-a-
turn-via-deref property holds only for the four "primary"
methods.

The §`map.getSize()` may lie observation is explicitly named:
*may reflect values that might still be collected later in the
same turn*. The §honest-acknowledgment-of-getSize-imprecision.

## The §has-via-get not-direct-Map-has discipline

```js
has: key => finalizingMap.get(key) !== undefined,
```

The §has-must-deref-or-it-lies discipline. A naive
`has: key => keyToRef.has(key)` would *lie*: the inner `Map`
might *have* the key (the WeakRef is there) but the WeakRef's
referent might already be collected. Routing through `get`
forces a `deref()`, which returns `undefined` for a collected
referent.

The §define-has-via-get-not-via-Map-has pattern: when an
internal structure stores *indirections to possibly-dead
objects*, the predicate must *follow the indirection* to
verify liveness.

## The §set-deletes-old-first replacement contract

```js
set: (key, ref) => {
  assert(!isPrimitive(ref));
  finalizingMap.delete(key);   // ← unregisters old WeakRef + fires finalizer
  const newWR = new WeakRef(ref);
  keyToRef.set(key, newWR);
  registry.register(ref, key, newWR);
},
```

The §replace-finalizes-old discipline. Setting a new value at
an existing key:

1. **`finalizingMap.delete(key)`**: unregisters the old
   WeakRef from the FinalizationRegistry + runs the user's
   finalizer for the old value.
2. **`new WeakRef(ref)`**: wraps the new value weakly.
3. **`keyToRef.set(key, newWR)`**: stores the new WeakRef.
4. **`registry.register(ref, key, newWR)`**: registers the new
   value with the FinalizationRegistry. The third argument
   `newWR` is the *unregister token*; the registry callback
   uses this to identify which WeakRef is being unregistered
   on `delete`.

The §`!isPrimitive(ref)` assert: primitives can't be WeakRef'd
(WeakRef requires a non-primitive). Imports `isPrimitive` from
`@endo/pass-style` (cycle 142's passStyle-helpers.js).

The §unregister-token-is-the-WeakRef shape: a unique token per
registration that the registry callback receives via
`registry.unregister(token)`. The §token-as-private-handle
discipline ensures only the map can request unregistration.

## The §clearWithoutFinalizing-exempt semantics

```js
clearWithoutFinalizing: () => {
  for (const ref of keyToRef.values()) {
    registry.unregister(ref);
  }
  keyToRef.clear();
},
```

The §unregister-first-then-clear order: unregister every
WeakRef from the FinalizationRegistry *before* clearing the
map. This prevents the FinalizationRegistry from later firing
its callbacks (which would call `finalizingMap.delete(key)`)
on entries already removed.

The §explicit-exemption-from-finalizer discipline:

> *Our semantics are to finalize upon explicit `delete`, `set`
> (which calls `delete`) or garbage collection (which also
> calls `delete`). `clearWithoutFinalizing` is exempt.*

The §named-exemption-not-implicit move: the consumer who
wants to clear *without* invoking finalizers must opt-in by
calling this specifically-named method.

The §clear-without-finalize-because-mass-cleanup use case: at
session teardown the consumer doesn't want N user-finalizers
to run; it wants the table empty. The §teardown-bypass
discipline.

## The §issue-#1514 TODO

```js
// UNTIL https://github.com/endojs/endo/issues/1514
// Prefer: get: key => keyToRef.get(key)?.deref(),
get: key => {
  const wr = keyToRef.get(key);
  if (!wr) {
    return wr;
  }
  return wr.deref();
},
```

The §TODO-with-issue-link discipline: the cleaner *preferred*
form is named, blocked on a tracked issue. The §commented-out-
preferred-form pattern keeps the future-cleanup visible at the
site.

The §`if (!wr) return wr` shape: returns `undefined` when the
key isn't in the map. Returning `wr` (which is `undefined`)
instead of `return undefined` is a §TypeScript-narrowing
nudge — the inferred return type is *the type of `wr`*, not
*the type of `wr.deref()`*. The §preserve-the-undefined-not-
the-typeof-deref-result discipline (the workaround the TODO
points to).

## The §Far-as-the-protective-wrapper

Both branches wrap the returned map in `Far('finalizingMap',
...)` or `Far('fakeFinalizingMap', ...)`. The §remotable-not-
bare-object discipline. The map can be passed via @endo/captp
to remote peers; without `Far`, it would not be transferable.

The §RemotableBrand-typing: the JSDoc return type includes
`& import('@endo/eventual-send').RemotableBrand<{}, FinalizingMap<K, V>>`.
The §typed-as-remotable-brand makes TypeScript know this is
also passable via E().

## How this file fits the @endo/captp cluster

- **`captp.js`** (1012 lines) — the wire-protocol implementation
  uses `makeFinalizingMap` for its export-table slot
  management: when a remote-held value's local export goes out
  of scope, the finalizer fires and the corresponding slot is
  released over the wire.
- **`trap.js`** (cycle 154) — the synchronous-CapTP proxy that
  rides on captp.js's slot-table mechanism.
- **`atomics.js`** (170 lines, not yet ingested) — the
  SharedArrayBuffer + Atomics.wait substrate underneath trap.

The §captp-cluster-mapping growing: 2 of 6 substantial captp
source files now ingested.

## Related sections

- cycle 100
  [[endo--packages-ses-src-error-unhandled-rejection-js--SES-rejection-tracking-via-GC-driven-finalization]]
  — sibling §GC-driven-finalization design (SES's unhandled-
  rejection tracker also uses FinalizationRegistry). Both
  files name the §unregister-immediately-suppresses-
  finalization assumption (cycle 100's tracker has the same
  hazard with explicit `rejectionHandledHandler` cancel).
- cycle 142
  [[endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records]]
  — provides the `isPrimitive` that this file's `set` method
  asserts.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — defines what `Far` produces; this file uses it to wrap
  both real and fake finalizing maps.
- cycle 154
  [[endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check]]
  — sibling first @endo/captp source file. Both touch CapTP's
  slot machinery from different angles (user-facing proxy vs
  GC-driven release).
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — daemon-side §pattern of cross-process slot tables; this
  file's §multi-map-coordinated-removal is the in-process
  cousin.
