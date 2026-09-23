---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: The §Far adds GET_METHOD_NAMES only for object remotables
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

The §`Far(farName, remotable)` body:

```js
const r = remotable === undefined ? ({}) : remotable;
if (typeof r === 'object' && !(GET_METHOD_NAMES in r)) {
  // This test excludes far functions, since we currently consider them
  // to only have a call-behavior, with no callable methods.
  Object.defineProperty(r, GET_METHOD_NAMES, getMethodNamesDescriptor);
}
return Remotable(`Alleged: ${farName}`, undefined, r);
```

Two conditions: `typeof r === 'object'` (Far functions excluded)
*and* `!(GET_METHOD_NAMES in r)` (skip if already installed —
inheritance case).

The §far-functions-have-no-methods discipline echoes cycle 134's
§two-distinct-shapes (*Far functions cannot be methods, and
cannot have methods*). Far functions don't need
`__getMethodNames__` because they have no methods to enumerate.
