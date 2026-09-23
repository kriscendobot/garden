---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §getMethodNames prototype-walk
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The §`getMethodNames(val)` function walks the prototype chain
collecting all method names:

```js
export const getMethodNames = val => {
  let layer = val;
  const names = new Set(); // Set to deduplicate
  while (layer !== null && layer !== Object.prototype) {
    const descs = getOwnPropertyDescriptors(layer);
    for (const name of ownKeys(descs)) {
      // In case a method is overridden by a non-method,
      // test `val[name]` rather than `layer[name]`
      if (typeof val[name] === 'function') {
        names.add(name);
      }
    }
    if (isPrimitive(val)) {
      break;
    }
    layer = getPrototypeOf(layer);
  }
  return harden([...names].sort(compareStringified));
};
```

Four structurally interesting moves:

1. **§Set-to-deduplicate** — `new Set()` accumulates names across
   prototype layers; duplicates (same name on multiple layers)
   are dropped.

2. **§Test-val-name-rather-than-layer-name** — the inline comment
   says it: *In case a method is overridden by a non-method, test
   `val[name]` rather than `layer[name]`*. If a base class
   declares a method but a subclass overrides it with a string,
   the name *should not appear* in the method list. The lookup
   must go through `val` to respect overrides.

3. **§Stop-at-Object-prototype** — `while (layer !== null && layer
   !== Object.prototype)` doesn't walk into `Object.prototype`'s
   methods (`toString`, `hasOwnProperty`, etc.). The
   §don't-leak-Object-prototype-methods discipline.

4. **§Primitive-early-exit** — `if (isPrimitive(val)) break` —
   stops walking when the value is a primitive (string, number,
   etc.). Primitives have access to their wrapper-object methods,
   but those shouldn't be enumerated as method names of the
   primitive itself.

The §`compareStringified` sort *prioritizes symbols as earlier
than strings* — symbol-keyed methods (like
`Symbol.toStringTag`) sort before string-named methods.
