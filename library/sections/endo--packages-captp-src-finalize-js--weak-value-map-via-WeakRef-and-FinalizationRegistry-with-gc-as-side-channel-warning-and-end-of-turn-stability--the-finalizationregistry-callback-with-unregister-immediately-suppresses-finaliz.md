---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §FinalizationRegistry callback with §unregister-immediately-suppresses-finalization assumption
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

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
