---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: The §ToFarFunction — *for functions from elsewhere*
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

The §`ToFarFunction(farName, func)` function:

```js
export const ToFarFunction = (farName, func) => {
  if (getInterfaceOf(func) !== undefined) {
    return func;
  }
  return Far(farName, (...args) => func(...args));
};
```

The §JSDoc names the use case:

> *Coerce `func` to a far function that preserves its call
> behavior. If it is already a far function, return it. Otherwise
> make and return a new far function that wraps `func` and
> forwards calls to it. This works even if `func` is already
> frozen. `ToFarFunction` is to be used when the function comes
> from elsewhere under less control. For functions you author in
> place, better to use `Far` on their function literal directly.*

Two structurally interesting disciplines:

1. **§Wrap-only-when-needed**: if `func` is already a far
   function (`getInterfaceOf(func) !== undefined`), return it
   directly. *No double-wrapping*. The check uses cycle 134's
   `getInterfaceOf` to detect existing remotability.

2. **§Works-even-if-func-is-already-frozen**: *Remotable*
   requires the object to be mutable; a frozen `func` can't be
   marked. The wrapping arrow function `(...args) => func(...args)`
   is *a fresh function* (mutable, not yet remotable) that
   forwards calls to the original. The original `func` doesn't
   need to be mutated.

The §better-Far-when-you-can advice:

> *For functions you author in place, better to use `Far` on
> their function literal directly.*

ToFarFunction's wrap adds *one indirection* (the forwarding
arrow). For functions the author controls, applying `Far()`
directly avoids the indirection.
