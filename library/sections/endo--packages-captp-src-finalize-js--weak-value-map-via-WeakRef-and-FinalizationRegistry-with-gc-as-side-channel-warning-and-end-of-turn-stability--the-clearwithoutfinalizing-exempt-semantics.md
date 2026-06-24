---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §clearWithoutFinalizing-exempt semantics
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

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
