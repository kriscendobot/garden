---
title: §the-double-XOR-with-`-1` as named CRC32-finalization pattern (first-explicit-observation)
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

The function performs **`crc ^= -1`** *before* the loop and **`(crc ^ -1) >>> 0`** *after* the loop. This double XOR with the bitmask `-1` (= `0xFFFFFFFF` in 32-bit signed-vs-unsigned) IS the standard CRC-32 finalization sequence. **§the-pre-and-post-XOR-mask-IS-the-named-standard-shape** for the IEEE 802.3 polynomial.

§the-`-1`-as-bitmask-IS-JS-specific-shorthand: in JavaScript, `-1` in a bitwise context is `0xFFFFFFFF` (all 1s in 32-bit two's complement). Using `-1` instead of `0xFFFFFFFF` is a *terser* idiom but means **the same thing** — the XOR mask flips every bit. §the-`-1`-IS-the-named-all-ones-mask-in-JS-bitwise-context.
