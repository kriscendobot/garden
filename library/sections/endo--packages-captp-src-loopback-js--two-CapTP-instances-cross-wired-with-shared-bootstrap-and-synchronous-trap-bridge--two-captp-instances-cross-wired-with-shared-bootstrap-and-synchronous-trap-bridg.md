---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: Two CapTP instances cross-wired with shared bootstrap and synchronous trap-bridge
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

> *Create an async-isolated channel to an object.*
>
> — `packages/captp/src/loopback.js` line 12

`loopback.js` (117 lines) is the **async-isolated-channel
primitive** for `@endo/captp`. Exports `makeLoopback(ourId,
nearOptions, farOptions)` which creates an in-process
*loopback CapTP session* — two CapTP instances bound to each
other so an object on either side travels through the *full
CapTP wire path* (serialize → unserialize) even though no
network is involved.

Last touched 2025-10-09 by Kris Kowal in cycle 108's
coordinated-update commit `e56bf00f`. **Third @endo/captp
source file ingested** after cycle 154's trap.js and cycle
156's finalize.js — the captp cluster's surface continues to
fill in.

The file is the *load-bearing test utility* for CapTP itself.
@endo/captp's own tests use it to exercise CapTP semantics
(including the §synchronous trap from cycle 154) without
ever opening a socket.
