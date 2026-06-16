---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §three-failure-modes
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

The §JSDoc names three ways the operation can fail to settle in
the expected way:

1. **Reject** — *If any of the promises reject, then the promise
   for the replacement rejects.* Standard Promise.all
   short-circuit behavior.

2. **Never settle** — *If any of the promises never settle, then
   the promise for the replacement never settles.* No timeout;
   the operation waits forever for the slowest promise.

3. **Not-Passable** — *If the replacement would not be Passable,
   i.e., if `val` is not Passable, or if any of the transitive
   promises fulfill to something that is not Passable, then the
   returned promise rejects.* The §reject-on-non-passable-leaf
   discipline catches errors where promises resolve to values
   that *can't* travel through pass-style.
