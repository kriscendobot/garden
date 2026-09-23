---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §makeDotMembraneKit one-line export
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

```js
export const makeDotMembraneKit = target => {
  const converter = makeConverter();
  return harden({
    proxy: converter.wrap(target),
    revoke: converter.myRevoke,
  });
};
```

The §two-method-kit shape: `{proxy, revoke}`. The user gets a
*wrapped target* and a *revocation method*. Calling `revoke()`
disables the membrane permanently.

The §`wrap = target => passBack(target)` operation: `target` is
*mine*; `passBack` makes it *yours*; the result is what the
caller hands to the untrusted recipient.
