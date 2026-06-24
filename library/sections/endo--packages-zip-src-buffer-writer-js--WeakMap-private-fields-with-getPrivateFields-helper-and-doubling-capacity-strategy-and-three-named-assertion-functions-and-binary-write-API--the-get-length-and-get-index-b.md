---
title: §the-`get length()` and-`get index()`-but-no-bytes-getter (first-explicit-observation)
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

The class exposes `length` and `index` as getters but **does NOT expose `bytes` or `data` directly**. To get the bytes, the caller must use `subarray()` or `slice()`. **§the-public-API-IS-narrower-than-the-private-state**.

§the-private-state-IS-not-exposed-as-properties (extends cycle 284's §the-class-exposes-stat-but-the-async-adapter-only-exposes-read pattern). **§three-cycles-with-public-API-narrower-than-private-state**: cycle 284 reader (stat is class-internal) + cycle 286 crc32 (table is module-scope-private) + cycle 290 buffer-writer (bytes and data are private).
