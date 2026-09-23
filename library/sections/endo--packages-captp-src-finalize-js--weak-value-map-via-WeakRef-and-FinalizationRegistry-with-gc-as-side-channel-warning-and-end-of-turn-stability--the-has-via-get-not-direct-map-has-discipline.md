---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §has-via-get not-direct-Map-has discipline
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

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
