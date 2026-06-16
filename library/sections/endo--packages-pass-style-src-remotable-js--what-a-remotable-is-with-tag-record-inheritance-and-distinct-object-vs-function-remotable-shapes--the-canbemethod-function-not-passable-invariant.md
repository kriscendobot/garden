---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §canBeMethod = function-not-passable invariant
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §opening predicate defines the *function-not-passable*
distinction:

```js
export const canBeMethod = func =>
  typeof func === 'function' && !(PASS_STYLE in func);
```

A method must be a *function without the PASS_STYLE marker*. If
the function carries PASS_STYLE, it's already a *Far function* —
itself a remotable, not a method on another remotable. The
§rationale:

> *we risk confusing pass-by-copy data carrying far functions with
> attempts at far objects with methods.*

The discipline: methods are *inert function values* that live
*on* a remotable; Far functions are *remotables themselves*. The
two cannot coexist on the same object — a Far function cannot
have methods, and an object's properties cannot be Far functions.
