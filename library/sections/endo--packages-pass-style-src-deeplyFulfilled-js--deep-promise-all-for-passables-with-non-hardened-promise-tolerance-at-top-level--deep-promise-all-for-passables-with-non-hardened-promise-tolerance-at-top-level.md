---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: Deep Promise.all for Passables with non-hardened-promise tolerance at top level
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

> *This is a deep form of `Promise.all` specialized for Passables.
> For each encountered promise, replace it with the deeply
> fulfilled form of its fulfillment.*
>
> — `packages/pass-style/src/deeplyFulfilled.js` §JSDoc

`deeplyFulfilled.js` (153 lines, Kris Kowal-last-touched
2026-02-24 in commit `e56bf00f` — same coordinated-update
cluster as cycles 108/110/115/118/123/125/132/134/136/138) is the
*deep Promise.all for Passables* primitive. Single export
`deeplyFulfilled(val)` that recursively replaces every promise
in a Passable's pass-by-copy structure with its fulfillment
value.
