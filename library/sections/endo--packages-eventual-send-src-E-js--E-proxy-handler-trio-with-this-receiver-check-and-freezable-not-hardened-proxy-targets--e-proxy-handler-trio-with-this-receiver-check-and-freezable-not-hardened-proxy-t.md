---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: E proxy-handler trio with this-receiver check and freezable-not-hardened proxy targets
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

> *In order to be `this` sensitive it is defined using concise method
> syntax rather than as an arrow function. To ensure the function is
> not constructable, it also avoids the `function` syntax.*
>
> — `packages/eventual-send/src/E.js` line 53-55

`E.js` (501 lines total; substantive code lines 1-273, the rest is
JSDoc typedefs) is the **user-facing surface** of `@endo/eventual-
send`. Exports a single factory `makeE(HandledPromise) → E` that
returns the `E` proxy used as `E(x).method(...)` throughout @endo and
Agoric code. Last touched 2026-04-07 by Turadg Aleahmad in commit
`c88bc8311fee` (a TypeScript any-short-circuit fix); previous
substantive touch by Kris Kowal in cycle 108's coordinated-update
commit `e56bf00f2` (Adopt @endo/harden migration).
