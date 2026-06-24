---
title: "`@endo/zip/src/buffer-writer.js` (full file)"
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

A 188-line file implementing a **doubling-capacity Uint8Array builder** with **WeakMap-private-fields** for state encapsulation. The class exposes binary-write primitives (`writeUint8` / `writeUint16` / `writeUint32`) plus seek-and-write coordination via `ensureCanSeek` and `ensureCanWrite`. Was part of cycle 191's zip-cluster ingest; cycle 290 ingests as a per-file deep pass.
