---
title: §three-named-stops-in-the-`makeTable`-inner-loop (first-explicit-observation)
section-slug: endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters
source-slug: endo--packages-zip-src-crc32-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/crc32.js
authors: [Endo project (collective, pre-pasted from pako)]
repo: endojs/endo
path: packages/zip/src/crc32.js
total-lines: 48
ingest-cycle: 286
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters
---

`makeTable`'s inner loop:
```javascript
for (let k = 0; k < 8; k += 1) {
  c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
}
```

Eight iterations per byte — *one iteration per bit*. The ternary `c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1` is **the CRC-32 polynomial division step in compact ternary form**. This is the **named bit-by-bit form** that the table replaces at runtime — `makeTable` runs the slow algorithm 256 times at startup so that `crc32` doesn't have to run it ever.

§the-startup-runs-the-slow-form-once-to-precompute-the-fast-form pattern. **§the-trade-IS-module-load-time-cost-for-runtime-savings** as named scope-of-optimization decision.
