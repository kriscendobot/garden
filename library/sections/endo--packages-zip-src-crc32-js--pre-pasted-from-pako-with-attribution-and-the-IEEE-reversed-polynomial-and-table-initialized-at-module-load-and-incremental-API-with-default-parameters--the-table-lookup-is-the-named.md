---
title: §the-table-lookup-IS-the-named-optimization-vs-bit-by-bit (first-explicit-observation)
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

The naive CRC-32 computes one bit at a time (32 iterations per byte). The table-lookup approach computes one *byte* at a time using a precomputed 256-entry lookup table. **`makeTable` builds the table; `crc32` uses it.** This is the canonical *speed/space tradeoff* for CRC: 1 KiB of table (256 × 4 bytes signed) buys 8× speedup.

§the-1KB-table-IS-the-named-canonical-CRC-32-optimization. **§the-makeTable-and-crc32-pair-IS-a-named-shape**: a precomputation function + a per-call function, with the table cached at module-scope.
