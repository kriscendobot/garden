---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §key-status-deferred-to-patterns observation
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

The §JSDoc names the *key-status* question:

> *If `val` or its parts are non-key Passables only *because*
> they contain promises, the deeply fulfilled forms of val or
> its parts may be keys. This is for the higher "@endo/patterns"
> level of abstraction to determine, because it defines the
> `Key` notion in question.*

The §layering-discipline: this file *doesn't* know about Keys
(cycles 102/104/110/115/120/123/125). The result of
`deeplyFulfilled` is a *Passable*; whether that Passable is a
*Key* is determined by the @endo/patterns layer above.

The §observation: a Passable containing a Promise is *not* a
Key (Keys are leaf-free); but its deeply-fulfilled form *might*
be (no more promises, so all leaves are concrete). The
*possibility-of-becoming-a-Key-after-deep-fulfillment* is
what the JSDoc names.
