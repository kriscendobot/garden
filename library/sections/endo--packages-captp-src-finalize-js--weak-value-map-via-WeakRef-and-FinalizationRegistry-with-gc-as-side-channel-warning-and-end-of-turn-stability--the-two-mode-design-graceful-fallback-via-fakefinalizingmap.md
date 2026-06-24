---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §two-mode design — §graceful-fallback-via-fakeFinalizingMap
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

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
