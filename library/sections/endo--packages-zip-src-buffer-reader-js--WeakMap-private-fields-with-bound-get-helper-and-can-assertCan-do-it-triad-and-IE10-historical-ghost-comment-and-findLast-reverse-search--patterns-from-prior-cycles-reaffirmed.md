---
title: Patterns from prior cycles, reaffirmed
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

- **§the-WeakMap-private-fields-pattern** (cycle 191 cluster ingest; cycle 290 buffer-writer per-file deep; cycle 292 buffer-reader per-file deep).
- **§the-bytes-vs-data-view-pair** (cycle 191 cluster ingest; cycle 290 + 292 per-file deep).
- **§the-getter-and-setter-pair-for-`index`** — same shape as cycle 290's buffer-writer.
- **§the-default-IS-big-endian** (`littleEndian` parameter optional) — same shape as cycle 290.
- **§the-class-method-IS-a-thin-wrapper-around-private-fields** — same shape as cycle 290.
- **§the-no-`harden`-on-private-fields** — same shape as cycle 290.
