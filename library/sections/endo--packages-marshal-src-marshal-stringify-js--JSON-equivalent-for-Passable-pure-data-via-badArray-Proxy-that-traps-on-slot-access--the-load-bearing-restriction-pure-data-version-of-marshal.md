---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §load-bearing-restriction — §pure-data-version-of-marshal
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

The whole file is the §pure-data-no-slots projection of
`@endo/marshal`. The marshal package's full surface
(`makeMarshal`) supports *slot-bearing* serialization —
remotables and promises get wire-encoded as slot indices that
the receiver's marshal table dereferences.

`marshal-stringify.js` takes that machinery and *strips it
down* to the no-slots case. The result behaves like
`JSON.stringify`/`JSON.parse` but with the @endo passability
discipline:

- **Accepts**: undefined, null, booleans, numbers, bigints,
  strings, copyArrays, copyRecords, byteArrays, errors (per
  cycle 87 + cycle 144's errorTagging-off mode), tagged
  values (copySet/copyBag/copyMap).
- **Rejects**: remotables, promises, slot-references.

The §JSON-but-Passable distinction: JSON can't encode
bigints or byteArrays; smallcaps (cycle 69) can. JSON has no
copySet/copyBag/copyMap concept; pass-style does. The file
*reuses marshal's encoder* to gain those affordances, then
*forbids* the slot mechanism that JSON also lacks.
