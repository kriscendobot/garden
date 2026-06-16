---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §end-of-turn stability invariant
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

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
