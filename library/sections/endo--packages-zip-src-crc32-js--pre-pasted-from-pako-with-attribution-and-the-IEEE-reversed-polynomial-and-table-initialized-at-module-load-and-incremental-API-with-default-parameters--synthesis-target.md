---
title: Synthesis target
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

Slot machine library `@game/replay/src/checksum.js`: pre-pasted CRC-32 (or similar checksum algorithm like Fletcher-16 or Adler-32) with explicit attribution comment naming the upstream source and license; `// Use ordinary array, since untyped makes no boost here` explanatory comment justifying data-structure choice; file-scope `/* eslint no-bitwise: ["off"] */` exception; algorithm constant (the polynomial) as named magic number distinct from game-format magic numbers; table-initialized-at-module-load; incremental checksum API via default parameters (`length = bytes.length, index = 0, checksum = 0`) letting the caller stream chunk-by-chunk; `>>> 0` unsigned-coercion for the final result; double-XOR-with-`-1` finalization sequence; `makeTable` + `checksum` pair pattern with `n`-by-byte, `k`-by-bit, `i`-by-buffer-position loop variables. The pre-paste discipline: cite upstream source verbatim, *adapt* to project house style (`+= 1`, JSDoc, `// @ts-check`).
