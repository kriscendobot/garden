---
title: "`@endo/zip/src/buffer-reader.js` (full file)"
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

A 274-line file implementing the **symmetric counterpart to cycle 290's `buffer-writer.js`** (188 lines). Reader has *more methods* than writer (12 named operations vs writer's 11) because reading has more variant shapes: `peek`/`read` (non-advance + advance), `expect`/`matchAt` (advance-if-match + non-advance), `assert` (throw if expect fails), `findLast` (reverse search). Per-file deep ingest extending cycle 191's cluster-scope coverage.
