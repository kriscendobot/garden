---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §pass + passBack symmetric pair
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §pass function (defined on this converter) does *mine →
serialize → unserialize as yours*:

```js
const pass = mine => {
  const myCapData = mySerialize(mine);
  const yours = yourUnserialize(myCapData);
  return yours;
};
```

The §`passBack` is the mirror's `pass` — it goes *yours → mine*.

Inside the §remotable case's method wrappers:

```js
const myMethodToYours = (optVerb) => (...yourArgs) => {
  const mineIf = passBack(yours);  // yours → mine
  const myArgs = passBack(harden(yourArgs));  // yours → mine
  let myResult;
  try {
    myResult = optVerb === undefined ? mineIf(...myArgs) : mineIf[optVerb](...myArgs);
  } catch (myReason) {
    throw pass(myReason);  // mine → yours
  }
  return pass(myResult);  // mine → yours
};
```

The §args-cross-back / §result-crosses-forward pattern: when
the other side calls a wrapped method, the arguments are *theirs*
(need to come back as *mine* for the actual call); the result and
exceptions are *mine* (need to go *forward* as *theirs*).
