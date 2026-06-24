---
title: §the-`if (!fields)` early-return-vs-throw distinction (first-explicit-observation)
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

`getPrivateFields` *throws* if the WeakMap has no entry; it does not return `undefined`. **§the-defensive-throw-on-missing-IS-the-named-bug-not-feature** — code calling `getPrivateFields` on an uninitialized instance IS a programmer error.

§the-throw-IS-the-named-fast-fail-discipline; §the-comparison-to-cycle-284's-read-vs-stat (read throws on missing, stat returns undefined). Both files in the cluster use *throw on missing for must-have-it operations*; the choice for "throw" vs "undefined" depends on whether the absence IS an error-state vs a normal-state.

§named-two-shapes-of-missing-in-the-zip-cluster:
- read-throws-on-missing-file (cycle 284 reader.js): file-not-found IS an error
- get-private-fields-throws-on-missing (cycle 290 buffer-writer.js): instance-not-initialized IS a bug
- stat-returns-undefined-on-missing-file (cycle 284 reader.js): file-presence IS a probable check
