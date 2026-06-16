---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: How this file integrates the marshal + pass-style + eventual-
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

send substrate

`dot-membrane.js` is the *crown jewel* of the @endo/marshal
package — it shows that marshal's serialization machinery, when
*paired with itself*, becomes a full membrane:

- **Marshal** (cycles 67/68/69 et al.) — the serialize /
  unserialize foundation
- **Pass-style** (cycles 71/87/134/136/138/140/142) — the
  classification + Far + remotable construction
- **Eventual-send** (cycles 66/130/132) — `E.when` for promise
  bridging

Together they give a *full-capability-passing membrane* with
*revocation*. The §full-membrane-from-serialization observation
is the structural delight of the design: *the same machinery that
sends capabilities over a network suffices to wrap capabilities
in a local revocable proxy*.
