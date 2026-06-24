---
title: Borrowing tiers
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

- **Tier 1 (direct, exact-shape)**: §the-WeakMap-private-fields-pattern (per-file deep) + §the-`@type {WeakMap<Class, { ... }>}`-named-JSDoc-on-the-WeakMap + §the-`getPrivateFields(self)`-named-private-getter-helper + §the-`if (!fields) throw`-defensive-discipline + §the-`assertNatNumber`-named-assertion-helper + §the-`/** @type {number} */ (n) >= 0`-inline-type-cast + §the-five-field-private-record + §the-doubling-capacity-strategy + §the-getter-and-setter-pair-for-`index` + §the-set-by-method-not-by-field-mutation + §the-`ensureCanSeek` vs `ensureCanWrite`-named-pre-conditions + §the-named-pre-condition-method-composition + §the-`fields.length = Math.max(...)`-named-watermark-update + §the-`DataView.setUint8/16/32`-named-binary-write-primitives + §the-DataView-IS-the-named-binary-write-substrate + §the-bytes-vs-data-view-pair + §the-`littleEndian`-parameter-optional + §the-default-IS-big-endian-discipline + §the-`subarray()` returning-a-view-vs-`slice()`-returning-a-copy + §the-named-view-vs-copy-pair + §the-`copyWithin`-named-internal-bytes-copy-pattern + §the-default-capacity-16-as-named-initial-buffer-size + §the-`new DataView(bytes.buffer)`-view-wrapping-pattern + §the-named-shell-and-state + §the-no-`harden`-on-private-fields + §the-private-mutability-IS-okay-when-the-shell-IS-the-only-access-path + §the-`if (!fields)`-early-return-vs-throw + §the-named-error-class-tells-the-class-of-failure + §the-`set index(index)`-argument-name-same-as-property + §the-`fields.bytes.set(bytes, fields.index)`-named-bulk-byte-write + §the-named-vectorized-bulk-write-via-platform-API + §the-`fields.index += N`-named-cursor-advance + §the-cursor-and-watermark-coordinate + §the-`get length()` and `get index()`-but-no-bytes-getter + §the-public-API-IS-narrower-than-the-private-state — all 35 first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §two-cycles-with-`@type`-inline-cast-on-unknown-parameter (288 BlobPart + 290 number) + §named-two-shapes-of-missing-in-the-zip-cluster (read-throws + stat-returns-undefined + get-private-fields-throws) + §two-named-state-coordinates (cursor + watermark) + §three-cycles-with-`Error()`-without-`new`-shorthand (280 + 284 + 290) + §the-while-loop-IS-the-named-grow-to-fit-shape + §the-power-of-2-default-IS-the-named-bytes-aligned-shape.
- **Tier 3 (multi-cycle pattern recognition)**: §three-cycles-with-public-API-narrower-than-private-state (284 + 286 + 290) + §the-zip-cluster-source-file-deep-ingest-progresses (cycles 278 + 280 + 282 + 284 + 286 + 288 pair + 290 = 8 of 12 files now per-file ingested).
