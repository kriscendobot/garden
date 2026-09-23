---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §uses-finalize.js-Weak-Value-Map observation
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

```js
const nonceToRef = makeFinalizingMap();
```

Cycle 156's `makeFinalizingMap()` is called *without
arguments* (no finalizer; default `weakValues = false`).

The §plain-Map-via-fakeFinalizingMap path: with default
options, this *is the §graceful-fallback-via-fakeFinalizingMap
branch* from cycle 156. The loopback's nonce-to-ref map is a
*plain Map* wrapped in `Far('fakeFinalizingMap', ...)`.

Why plain Map (not weak)? Because the §use-once-then-remove
discipline ensures nonces *do* get explicitly removed
(`getRef(nonce)` deletes). The weak-values mode would add
non-determinism (§gc-as-side-channel from cycle 156) — *not
what tests want*.

The §test-utility-doesn't-want-gc-nondeterminism observation:
even where weak-value-map *could* be used, the loopback
chooses *not* to — preserving deterministic test behavior.
