---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §temporal-dead-zone hack
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

```js
const convertSlotToVal = (
  slot,
  optIface = /** @type {string | undefined} */ (undefined),
) => convertYoursToMine(slot, optIface);
const { serialize: mySerialize, unserialize: myUnserialize } = makeMarshal(
  convertMineToYours,
  convertSlotToVal,
);
// ...
const { ..., convertMineToYours: convertYoursToMine, ... } = mirrorConverter;
```

The §inline comment:

> *We need to pass this while convertYoursToMine is still in
> temporal dead zone, so we wrap it in convertSlotToVal.*

`convertYoursToMine` is destructured *after* `makeMarshal` is
called. The §temporal-dead-zone-wrapper indirection lets us
*reference* `convertYoursToMine` in a function that's *defined
before* `convertYoursToMine` is bound. When the wrapper is
*called*, the binding is set.

The §arrow-function-captures-the-binding-not-the-value pattern:
JS arrow functions don't evaluate body expressions until invoked,
so `() => convertYoursToMine(...)` works even when defined
before the binding exists.
