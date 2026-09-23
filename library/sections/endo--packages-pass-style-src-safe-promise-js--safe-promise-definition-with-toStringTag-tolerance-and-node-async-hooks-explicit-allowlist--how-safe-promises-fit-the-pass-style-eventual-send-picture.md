---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: How safe-promises fit the pass-style + eventual-send picture
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

The §file-level use case: safe-promises are what
`@endo/eventual-send`'s `E()` and `HandledPromise` *trust to be
non-reentrant*. Cycle 66's `handled-promise.js` §handler-protocol
section describes the dispatcher; cycle 132's `local.js`
defines the local-delivery primitives. Both rely on the
*incoming-promise-must-be-safe* invariant.

The §pass-style relationship: safe-promises are *not themselves*
a pass-style (cycle 71's passStyleOf.js doesn't return a
`'promise'` style). They're a *pre-condition* for safe pass-by-
reference of promises. Cycle 87's `error.js` (passing errors)
has a similar discipline: validate first, *then* pass.
