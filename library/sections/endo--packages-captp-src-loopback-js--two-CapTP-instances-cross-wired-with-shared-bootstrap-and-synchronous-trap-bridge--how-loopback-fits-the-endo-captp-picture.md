---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: How loopback fits the @endo/captp picture
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

The captp cluster now at **three ingested files**:

| File | Role | Cycle |
|------|------|-------|
| `trap.js` | Synchronous user-facing proxy | 154 |
| `finalize.js` | Weak-Value-Map for slot tables | 156 |
| `loopback.js` | In-process test fixture | 158 (this) |

`captp.js` (1012 lines, the wire protocol itself) and
`atomics.js` (170 lines, SharedArrayBuffer substrate) remain
candidates. `loopback.js` is the simplest of the three
ingested because it *composes* the other two — its complexity
is in *how it wires them*, not in *what they each do*.

The §test-utility-composes-substrate pattern: the test
fixture *exercises* the production code; it sits *one layer
up* from the substrate. Reading the loopback teaches the
production code by *seeing how it's used*.
