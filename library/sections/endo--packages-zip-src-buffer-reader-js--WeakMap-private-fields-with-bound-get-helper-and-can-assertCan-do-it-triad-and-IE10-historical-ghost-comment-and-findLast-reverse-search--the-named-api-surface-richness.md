---
title: §the-named-API-surface-richness reader-vs-writer (first-explicit-observation)
section-slug: endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search
source-slug: endo--packages-zip-src-buffer-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-reader.js
total-lines: 274
ingest-cycle: 292
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search
---

| Operation | BufferWriter (cycle 290) | BufferReader (cycle 292) |
|---|---|---|
| Pre-condition predicate | (absent) | `canSeek` + `canRead` |
| Pre-condition assertion | `ensureCanSeek` + `ensureCanWrite` | `assertCanSeek` + `assertCanRead` |
| Primary op | `write` + `writeUint8/16/32` | `read` + `readUint8/16/32` |
| Non-mutating op | `subarray` + `slice` | `peek` + `byteAt` |
| Pattern op | `writeCopy` (intra-buffer) | `expect` + `matchAt` + `assert` + `findLast` |
| Cursor op | (only via seek/index setter) | `skip` + `seek` (which returns prior) |
| Lines | 188 | 274 |

**§the-reader-API-IS-richer-than-the-writer-API** by a factor of ~1.5× lines. The asymmetry IS *task-asymmetry*: parsers need richer inspection primitives than emitters. **§the-named-task-asymmetry-shape**.
