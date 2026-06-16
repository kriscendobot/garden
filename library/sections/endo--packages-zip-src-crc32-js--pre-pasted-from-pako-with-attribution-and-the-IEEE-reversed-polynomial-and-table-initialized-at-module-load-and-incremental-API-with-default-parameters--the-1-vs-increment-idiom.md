---
title: §the-`+= 1` vs `++` increment idiom
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

Both loops use `n += 1` and `k += 1` instead of `n++` and `k++`. **§the-`+= 1` IS the ESLint-friendly idiom** (some ESLint configs disallow `++` because of subtle JS pre-vs-post-increment confusion). The pre-pasted file already conforms to this convention — likely *pako uses the same convention*, or the paste-in adapted it.

§the-`+= 1`-IS-canonical-across-the-zip-cluster (this file + buffer-reader + buffer-writer all use `+= 1`).
