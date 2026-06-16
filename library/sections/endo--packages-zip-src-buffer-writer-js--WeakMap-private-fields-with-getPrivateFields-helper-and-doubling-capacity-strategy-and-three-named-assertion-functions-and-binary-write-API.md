---
title: "@endo/zip/src/buffer-writer.js — WeakMap-private-fields with named getPrivateFields helper + doubling-capacity strategy + five-field private record + DataView.setUint8/16/32 binary-write API + assertNatNumber assertion helper + getter-and-setter pair for index"
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
kind: index
section_count: 12
---

Sections:

- [`@endo/zip/src/buffer-writer.js` (full file)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--endo-zip-src-buffer-writer-js-full-file.md)
- [Key moves](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--key-moves.md)
- [§the-`if (!fields)` early-return-vs-throw distinction (first-explicit-observation)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--the-if-fields-early-return-vs.md)
- [§the-`Error()` vs `TypeError()` distinction (first-explicit-observation in this context)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--the-error-vs-typeerror-distinc.md)
- [§the-`set index(index)` argument-name-same-as-property pattern (first-explicit-observation)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--the-set-index-index-argument-n.md)
- [§the-`fields.bytes.set(bytes, fields.index)` named-bulk-byte-write (first-explicit-observation)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--the-fields-bytes-set-bytes-fie.md)
- [§the-`fields.index += N` named-cursor-advance pattern (first-explicit-observation)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--the-fields-index-n-named-curso.md)
- [§the-`get length()` and-`get index()`-but-no-bytes-getter (first-explicit-observation)](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--the-get-length-and-get-index-b.md)
- [Patterns from prior cycles, reaffirmed](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--patterns-from-prior-cycles-reaffirmed.md)
- [Borrowing tiers](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--borrowing-tiers.md)
- [Synthesis target](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--synthesis-target.md)
- [Single most structurally interesting move](endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API--single-most-structurally-interesting-move.md)
