---
title: §the-loop-variable-`i`-vs-named-`k`-and-`n` (first-explicit-observation)
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

The outer loop in `makeTable` uses `n` (the byte being precomputed); the inner uses `k` (the bit position); `crc32` uses `i` (the buffer index). **Three named loop variables in two functions**, each with a *narrow scope*. §the-loop-variable-IS-named-by-the-domain-of-its-iteration (n=byte, k=bit, i=buffer-position).

§the-tradition-IS-mathematical-letters-NOT-`x, y, z`-or-`a, b, c`: `n` for natural-number byte, `k` for index, `i` for iteration. Inherited from the upstream pako attribution, but consistent with the C-style numerical-code tradition.
