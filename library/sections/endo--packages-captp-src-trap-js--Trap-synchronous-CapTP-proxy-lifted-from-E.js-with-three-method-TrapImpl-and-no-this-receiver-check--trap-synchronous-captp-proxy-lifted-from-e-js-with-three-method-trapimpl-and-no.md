---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: "`Trap` — synchronous CapTP proxy lifted from `E.js` with three-method TrapImpl and no `this`-receiver check"
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

> *Lifted mostly from `@endo/eventual-send/src/E.js`.*
>
> — `packages/captp/src/trap.js` line 1

`trap.js` (105 lines) is the **synchronous-CapTP proxy
surface**, a sibling to cycle 146's `eventual-send/src/E.js`.
The file's *one-line opening comment* declares its derivation:
*Lifted mostly from `@endo/eventual-send/src/E.js`*. Last
touched 2025-10-09 by Kris Kowal in cycle 108's coordinated-
update commit `e56bf00f` (the @endo/harden migration that
touched many @endo files).

This file is the §synchronous-counterpart-to-eventual-send.
Where cycle 146's `E(x).method()` returns a *promise* that
settles in some future turn, `Trap(x).method()` *blocks* the
current turn until the remote returns — implemented via
SharedArrayBuffer + Atomics.wait under the hood (the related
`atomics.js` file in the same package).
