---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: The §Node-async_hooks-explicit-allowlist
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

The §checkSafeOwnKey function has a *Node-specific* branch for
non-toStringTag keys:

```js
const val = pr[key];
if (val === undefined || typeof val === 'number') {
  return true;
}
if (
  typeof val === 'object' &&
  val !== null &&
  isFrozen(val) &&
  getPrototypeOf(val) === Object.prototype
) {
  const subKeys = ownKeys(val);
  if (subKeys.length === 0) {
    return true;
  }
  if (
    subKeys.length === 1 &&
    subKeys[0] === 'destroyed' &&
    val.destroyed === false
  ) {
    return true;
  }
}
return reject && reject`Unexpected Node async_hooks additions to promise: ...`;
```

The §inline-comment cites Node's source verbatim:

```js
function destroyTracking(promise, parent) {
  trackPromise(promise, parent);
  const asyncId = promise[async_id_symbol];
  const destroyed = { destroyed: false };
  promise[destroyedSymbol] = destroyed;
  registerDestroyHook(promise, asyncId, destroyed);
}
```

The §three-allowed-shapes:

1. **`undefined` or `number`** — the `async_id_symbol` value is
   a number (the asyncId).
2. **Frozen `Object`-prototype object with no own keys** — an
   empty `{}` sentinel.
3. **Frozen `Object`-prototype object with exactly one key
   `destroyed: false`** — the literal `{ destroyed: false }`
   shape from Node's code.

The §exact-shape-match discipline: each Node-async_hooks
addition has a *specific* expected shape; deviations fail.

The §cite-Node-source-verbatim-in-comment discipline is
structurally interesting: when the safety check has to *tolerate
host-specific quirks*, the host's exact source code becomes
*part of the safety surface*. If Node's async_hooks changes the
shape, this file must update.

The §destroyed-must-be-false sub-invariant: a freshly-tracked
promise has `destroyed === false`. The check allows that
specific value (not `true`); a *destroyed* promise's marker
would fail this branch. This *probably* doesn't matter
operationally (the destroyed marker is set asynchronously, on
GC), but the strict check catches any unexpected mutation.
