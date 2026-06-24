---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: How this file fits the @endo/captp cluster
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

- **`captp.js`** (1012 lines) — the wire-protocol implementation
  uses `makeFinalizingMap` for its export-table slot
  management: when a remote-held value's local export goes out
  of scope, the finalizer fires and the corresponding slot is
  released over the wire.
- **`trap.js`** (cycle 154) — the synchronous-CapTP proxy that
  rides on captp.js's slot-table mechanism.
- **`atomics.js`** (170 lines, not yet ingested) — the
  SharedArrayBuffer + Atomics.wait substrate underneath trap.

The §captp-cluster-mapping growing: 2 of 6 substantial captp
source files now ingested.
