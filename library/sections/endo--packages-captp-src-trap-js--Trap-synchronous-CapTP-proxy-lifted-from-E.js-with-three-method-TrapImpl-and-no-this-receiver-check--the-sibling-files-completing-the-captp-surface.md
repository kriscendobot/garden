---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §sibling-files-completing-the-CapTP-surface
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

The relationship to cycle 146:

| Property | `E.js` (cycle 146) | `trap.js` (this file) |
|----------|-------------------|----------------------|
| Semantics | Eventual (returns promise) | Synchronous (blocks current turn) |
| Underlying mechanism | HandledPromise dispatch | Atomics.wait + SharedArrayBuffer |
| API surfaces | 5 (E + E.get + E.resolve + E.sendOnly + E.when) | 2 (Trap + Trap.get) |
| Receiver-check | Yes (cycle 146's §this-receiver-check) | No (arrow functions are detach-safe by construction) |
| Method dispatch shape | Concise-method-syntax + computed property | Arrow function returning `trapImpl.applyMethod(x, p, args)` |
| `has` trap | Returns true (no TODO) | Returns true *with TODO about wire transferrability* |
| TrapImpl/Handler injection | HandledPromise constructor | `trapImpl` parameter to `makeTrap` |

The §two-files-one-CapTP-experience observation: together
these files describe the full CapTP application interface.
The captp.js file (the wire protocol) sits below them; both
operate on the same captp slot tables but expose different
*caller-facing* semantics.
