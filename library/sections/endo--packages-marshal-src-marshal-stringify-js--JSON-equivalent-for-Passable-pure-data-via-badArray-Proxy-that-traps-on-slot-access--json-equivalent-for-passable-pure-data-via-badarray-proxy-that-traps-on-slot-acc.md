---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: JSON-equivalent for Passable pure-data via `badArray` Proxy that traps on slot access
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

> *Marshal's stringify rejects presences and promises [val].
> Marshal's parse must not encode any slots [slot].
> Marshal's parse must not encode any slot positions [name].*
>
> — `packages/marshal/src/marshal-stringify.js` lines 11, 15, 23

`marshal-stringify.js` (69 lines) is the **§JSON-equivalent-
for-pure-data-Passable surface**. Exports `stringify` and
`parse` — symmetric to `JSON.stringify` and `JSON.parse` but
operating on *Passable* values (cycle 71's pass-style
classification) rather than on raw JSON-compatible values.

Last touched 2025-10-09 by Kris Kowal in cycle 108's
coordinated-update commit `e56bf00f` (@endo/harden migration).
Cycle 160 is a **milestone tick**: 25 cycles of design+comment
alternation since the daemon-observability-pair landed at
cycle 145+147, with §runtime-introspection-trio completed by
cycle 159.
