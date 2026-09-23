---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: How this file fits the @endo/marshal cluster
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

The marshal cluster grows:

| File | Ingest cycle | Role |
|------|--------------|------|
| `marshal.js` | cycle 74 | makeMarshal factory |
| `encodeToSmallcaps.js` | cycle 69 | newer body encoder |
| `encodePassable.js` | cycle 81 | rank-order encoder |
| `rankOrder.js` | cycle 84-85 | in-memory rank-order |
| `dot-membrane.js` | cycle 144 | full membrane via marshal |
| **`marshal-stringify.js`** | **cycle 160 (this)** | pure-data JSON-equivalent |

Six @endo/marshal source files now ingested. The §pure-data-
version-of-marshal projection sits *one layer above*
`marshal.js` — uses `makeMarshal` but with deliberately-
restricted configurations.

The §three-faces-of-marshal observation:

- **Full marshal** (cycle 74) — slot-bearing CapTP wire
  format.
- **Membrane marshal** (cycle 144) — slot-bearing but in-
  process across membrane boundary.
- **Stringify marshal** (this) — slot-rejecting pure-data
  JSON-equivalent.

The §same-substrate-three-API-faces discipline: one
`makeMarshal` factory, three quite different end-user APIs
selected by configuration + wrapping.
