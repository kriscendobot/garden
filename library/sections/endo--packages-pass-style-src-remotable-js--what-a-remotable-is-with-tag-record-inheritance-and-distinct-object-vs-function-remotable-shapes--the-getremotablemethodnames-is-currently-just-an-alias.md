---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §getRemotableMethodNames is currently just an alias
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §`getRemotableMethodNames` re-exports cycle 132's
`getMethodNames` from `@endo/eventual-send/utils.js`:

```js
export const getRemotableMethodNames = behaviorMethods =>
  getMethodNames(behaviorMethods);
```

The §JSDoc names the *abstraction-for-a-future-PR* rationale:

> *Currently, just alias `getMethodNames` but this abstraction
> exists so a future PR can enforce restrictions on method names
> of remotables.*

The §abstraction-anticipating-restriction discipline: today the
two notions coincide; the indirection layer lets one diverge
later without breaking callers.

Cycle 132's `getMethodNames` is in `@endo/eventual-send` at *the
eventual-send level of abstraction that does not know anything
about remotables*. This file's `getRemotableMethodNames` is the
*remotable-aware* surface. The §layering-stepwise discipline:
eventual-send doesn't know about remotables, pass-style doesn't
know about eventual-send dispatch — they compose at the
introspection-helper boundary.
