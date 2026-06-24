---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §two-level metaReason error handling for promises
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §promise case has a *defensive* error chain:

```js
E.when(
  mine,
  myFulfillment => yourResolve(pass(myFulfillment)),
  myReason => yourReject(pass(myReason)),
)
  .catch(metaReason =>
    // This can happen if myFulfillment or myReason is not passable.
    // TODO verify that metaReason must be my-side-safe, or rather,
    // that the passing of it is your-side-safe.
    yourReject(pass(metaReason)),
  )
  .catch(metaMetaReason =>
    // In case metaReason itself doesn't pass
    yourReject(metaMetaReason),
  );
```

The §three-level-fallback discipline:

1. **Normal path**: fulfillment or rejection passes through
   `pass()` and resolves/rejects the mirror promise.
2. **`pass()` itself fails** (e.g., myFulfillment isn't passable):
   catch with `pass(metaReason)` — try to pass the *reason for
   the failure*.
3. **`pass(metaReason)` also fails**: catch with the raw
   metaMetaReason — give up on passing and reject with whatever
   we've got.

The §each-level-might-throw discipline acknowledges that *every*
membrane-crossing can fail; the three-level chain ensures the
mirror promise *always* settles, even if every passable check
fails.

The §TODO note:

> *TODO verify that metaReason must be my-side-safe, or rather,
> that the passing of it is your-side-safe.*

The §verify-side-safety-of-error-paths discipline: errors from
the membrane machinery might *themselves* contain references that
shouldn't cross. The current code rejects without that
verification; future work would tighten.
