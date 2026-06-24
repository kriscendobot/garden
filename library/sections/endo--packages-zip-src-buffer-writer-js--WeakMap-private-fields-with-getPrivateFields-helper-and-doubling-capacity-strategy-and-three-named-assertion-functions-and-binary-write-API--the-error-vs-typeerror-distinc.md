---
title: §the-`Error()` vs `TypeError()` distinction (first-explicit-observation in this context)
section-slug: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
---

The file uses both:
- `throw Error('BufferWriter fields are not initialized');` — for missing-state
- `throw TypeError('must be a non-negative integer, got ${n}');` — for invalid-input-type

**§the-named-error-class-tells-the-class-of-failure**: `Error` for *runtime-state* failures; `TypeError` for *input-validation* failures. §the-Error-class-IS-the-named-failure-category.

§two-cycles-with-`Error()`-without-`new` in the zip cluster (cycle 280 writer.js + cycle 284 reader.js + cycle 290 buffer-writer.js) — third cycle now, **§three-cycles-with-`Error()`-without-`new`-shorthand**.
