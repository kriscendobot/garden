---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §Far-functions-have-no-static-methods assumption
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §remotable case:

```js
if (typeof mine === 'function') {
  // NOTE: Assumes that a far function has no "static" methods. This
  // is the current marshal design, but revisit this if we change our
  // minds.
  yours = Far(iface, myMethodToYours());
} else {
  const myMethodNames = getRemotableMethodNames(mine);
  const yourMethods = myMethodNames.map(name => [
    name,
    myMethodToYours(name),
  ]);
  yours = Far(iface, fromEntries(yourMethods));
}
```

The §two-cases match cycle 134's §two-distinct-shapes:

- **Far function**: a single callable, no methods. The wrapper
  is the §`myMethodToYours()` call-pattern (no `optVerb`).
- **Object remotable**: a bag of methods. The wrapper enumerates
  `getRemotableMethodNames(mine)` (cycle 134's introspection) and
  builds a method-by-method translation table.

The §Far-functions-have-no-static-methods assumption is the
§current-marshal-design discipline acknowledged: *NOTE: Assumes
that a far function has no "static" methods. This is the current
marshal design, but revisit this if we change our minds.*
