---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: The §makeRemotableProto helper — *inherits from the original
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

prototype*

The private §`makeRemotableProto(remotable, iface)` function
creates a new prototype object with `PASS_STYLE = 'remotable'`
and `@@toStringTag = iface` as own properties, inheriting from
the *original* prototype of the input:

```js
return harden(
  create(oldProto, {
    [PASS_STYLE]: { value: 'remotable' },
    [Symbol.toStringTag]: { value: iface },
  }),
);
```

The §discipline: *ensure it always inherits from something. The
original prototype of `remotable` if there was one, or
`Object.prototype` otherwise.* The §strict-original-prototype
invariant:

- **Object remotables**: original proto must be `objectPrototype`
  (or null, normalized to `objectPrototype`). *For now,
  remotables cannot inherit from anything unusual.*
- **Far functions**: original proto must be `functionPrototype`
  OR `getPrototypeOf(oldProto) === functionPrototype` (allowing
  one level of class-prototype inheritance). *Far functions must
  originally inherit from Function.prototype.*

The §narrowness-of-allowed-prototype-chains discipline. Future
PRs may relax this; today the discipline is strict.
