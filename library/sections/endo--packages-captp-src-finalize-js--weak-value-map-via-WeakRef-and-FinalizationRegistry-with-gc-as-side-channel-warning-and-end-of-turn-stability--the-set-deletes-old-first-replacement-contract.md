---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §set-deletes-old-first replacement contract
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

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
