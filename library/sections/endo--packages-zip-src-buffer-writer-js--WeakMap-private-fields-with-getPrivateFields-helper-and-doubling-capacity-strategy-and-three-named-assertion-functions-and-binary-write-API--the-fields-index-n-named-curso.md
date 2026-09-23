---
title: §the-`fields.index += N` named-cursor-advance pattern (first-explicit-observation)
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

Every write method advances `fields.index` by the number of bytes written. **§the-cursor-IS-mutable-and-named-advanced-by-the-write-call**. The cursor is the single point of truth for "where to write next".

§the-cursor-and-watermark-coordinate: the cursor advances by the write size + the watermark catches up via Math.max. **§two-named-state-coordinates** (cursor + watermark).
