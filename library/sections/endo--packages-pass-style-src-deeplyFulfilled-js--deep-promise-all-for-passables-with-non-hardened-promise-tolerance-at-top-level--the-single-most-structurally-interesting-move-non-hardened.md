---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The single most structurally interesting move — §non-hardened-
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

promise tolerance at top level

The §opening branches handle two pre-passStyle cases before the
main switch:

```js
if (isAtom(val)) {
  return val;
}
if (isPromise(val)) {
  return E.when(val, nonp => deeplyFulfilled(nonp));
}
const passStyle = passStyleOf(val);
```

The §inline comment names the *non-passable-promise-tolerance*
behavior:

> *if `val` is a promise but not a passable promise, for
> example, because it is not hardened, `isPromise` will return
> true, which is ok here because we unwrap it to its settlement
> and dispense with the promise*

The §discipline: `passStyleOf` *throws* on non-hardened (non-
Passable) promises; `isPromise` does *not*. By checking
`isPromise` *before* `passStyleOf`, the function handles
non-hardened top-level promises gracefully — *we unwrap it to
its settlement and dispense with the promise*.

The §continuation:

> *If `val` is any other non-Passable, the `passStyleOf(val)`
> will throw. So this exemption for non-Passable promises is
> only for the top-level.*

The §exemption-is-top-level-only discipline: a non-hardened
promise *as the input* is tolerated; non-hardened promises
*nested inside* a Passable would fail (because their containing
`copyRecord`/`copyArray`/etc. would fail `passStyleOf`). The
exception is *narrow* and *intentional*.
