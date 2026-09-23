---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: How this file fits into the pass-style / eventual-send picture
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

`deeplyFulfilled` is the *bridge* between pass-style's leaf-
oriented validation and eventual-send's promise-routing
mechanics:

- Pass-style says: *a copyRecord must contain only Passables;
  promises are not Passables; deeply-fulfilled forms are
  Passables*.
- Eventual-send says: *promises route through E() to local-
  delivery or remote-CapTP*.

`deeplyFulfilled` *resolves* the embedded promises so the
result is a *fully-Passable structure* ready to cross a
serialization boundary. Without `deeplyFulfilled`, a `marshal()`
call on a structure containing promises would fail; with it, the
caller can *await the deeply-fulfilled form* and then marshal
the result.
