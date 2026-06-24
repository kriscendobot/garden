---
title: §the-eight-bit-shift-and-XOR-pattern as named CRC-32-update step (first-explicit-observation)
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

```javascript
crc = (crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xff];
```

This single statement IS the CRC-32 update step: shift the running CRC right by 8 bits, XOR with the table entry indexed by the low-byte of `(crc XOR current-byte)`. **§the-three-operations-in-one-statement**: shift + table-lookup + XOR. Compact, correct, and standard.

§the-pattern-IS-named-`(crc >> 8) ^ table[(crc ^ byte) & 0xff]` in every CRC-32 implementation; §the-form-IS-not-original-to-this-file-but-IS-the-canonical-shape.
