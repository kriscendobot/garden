---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: How this file fits the broader @endo/captp + @endo/eventual-send picture
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

- **Cycle 146** (`E.js`) provides the *eventual* user-facing
  surface. This file is the *synchronous* mirror.
- **`captp.js`** (1012 lines, not yet ingested) — the wire
  protocol below both.
- **`atomics.js`** (170 lines, not yet ingested) — the
  SharedArrayBuffer + Atomics.wait substrate for synchronous
  CapTP. Without that substrate, `Trap` can't block.
- **`loopback.js`** (117 lines, not yet ingested) — the
  in-process CapTP connection used for testing/dev.

The §captp-cluster-mapping: 6 substantial source files in
`@endo/captp`; this is the *first* ingested. The other
captp.* files remain candidates for future cycles.
