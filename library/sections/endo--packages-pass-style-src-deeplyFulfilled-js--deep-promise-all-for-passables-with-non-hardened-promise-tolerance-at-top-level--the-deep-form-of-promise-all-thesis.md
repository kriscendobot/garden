---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §deep-form-of-Promise.all thesis
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

The §JSDoc:

> *Given a Passable `val` whose pass-by-copy structure may
> contain leaf promises, return a promise for a replacement
> Passable, where that replacement is *deeply fulfilled*, i.e.,
> its pass-by-copy structure does not contain any promises.*
>
> *This is a deep form of `Promise.all` specialized for
> Passables. For each encountered promise, replace it with the
> deeply fulfilled form of its fulfillment.*

The §recursive-shape: `deeplyFulfilled` is the fixed point of
*for each promise, await + recurse*. The result is a *Passable
without any embedded promises*.
