---
title: §The cache staleness caveat as explicit warning
source-slug: endo--packages-exo-src-get-interface
source-url: https://github.com/endojs/endo/blob/master/packages/exo/src/get-interface.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/exo/src/get-interface.js
total-lines: 28
ingest-cycle: 239
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat
---

```text
Beware that an exo's interface can change across an upgrade,
so remotes that cache it can become stale.
```

§The-warning-IS-the-protocol-contract — §when-a-protocol-permits-caching, §the-protocol-MUST-name-the-staleness-condition-that-invalidates-the-cache. §The-`Beware`-prefix-marks-the-comment-as-an-actionable-warning-not-a-passive-note. §When-an-interface-can-change-across-upgrades, §the-cache-can-become-stale + §remotes-that-cache-it-must-handle-staleness; §the-protocol-doesn't-promise-stability + §the-protocol-names-the-instability-as-known.

§Sibling-to-cycle-235's-cache-the-traversal-context-by-source (cycle 235 was a single-source-shortest-path cache that's always fresh because the algorithm is deterministic; cycle 239 is a protocol cache that can become stale because the underlying state can change). §Two-different-cache-shapes: §deterministic-algorithm-cache (always fresh given inputs) + §protocol-state-cache (can become stale across upgrades).
