---
title: "@endo/zip/src/buffer-writer.js — doubling-capacity Uint8Array builder with WeakMap-private-fields"
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
---

# `@endo/zip/src/buffer-writer.js`

A 188-line doubling-capacity Uint8Array builder with WeakMap-private-fields. Exposes binary-write primitives (`writeUint8` + `writeUint16` + `writeUint32`) + seek-and-write coordination via `ensureCanSeek` and `ensureCanWrite`. Per-file deep ingest of file that was part of cycle 191's zip-cluster ingest at cluster-scope.

## Key moves

- **§the-WeakMap-private-fields-pattern** — `new WeakMap()` at module scope; constructor sets the entry; methods use `getPrivateFields(this)` to retrieve.
- **§the-`@type {WeakMap<Class, { ... }>}`-named-JSDoc-on-the-WeakMap** — full private-state shape documented at the WeakMap declaration.
- **§the-`getPrivateFields(self)`-named-private-getter-helper** — module-scoped function that throws if instance was never registered; the-WeakMap-IS-the-capability-discriminator.
- **§the-`assertNatNumber`-named-assertion-helper** — `Number.isSafeInteger(n) && n >= 0`; combines integer-type + non-negative-value checks.
- **§the-`/** @type {number} */ (n) >= 0`-inline-type-cast** — workaround for TypeScript's unknown-parameter inference; §two-cycles-with-`@type`-inline-cast-on-unknown-parameter (288 BlobPart + 290 number).
- **§the-five-field-private-record** — `{ length, index, bytes, data, capacity }`; the-DataView-and-Uint8Array-share-the-same-buffer.
- **§the-doubling-capacity-strategy** — `while (capacity < required) { capacity *= 2; }`; named amortized O(1) append; the-while-loop-IS-the-named-grow-to-fit shape.
- **§the-getter-and-setter-pair-for-`index`** — `set index(index) { this.seek(index); }`; the-setter-IS-a-method-not-a-mutation.
- **§the-`ensureCanSeek` vs `ensureCanWrite`-named-pre-conditions** — two-named-pre-condition methods with one delegating to the other.
- **§the-`fields.length = Math.max(fields.index, fields.length)`-named-watermark-update** — every write extends the watermark; never shrinks.
- **§the-`DataView.setUint8/16/32`-named-binary-write-primitives** — three named methods for 1/2/4-byte writes; the-DataView-IS-the-named-binary-write-substrate.
- **§the-bytes-vs-data-view-pair** — Uint8Array view + DataView view of the same buffer; both stored as private fields.
- **§the-`littleEndian`-parameter-optional** — `writeUint16(value, littleEndian)`; default IS big-endian; the-named-binary-format-discriminator.
- **§the-`subarray()` returning-a-view-vs-`slice()`-returning-a-copy** — view-and-copy pair following Uint8Array convention.
- **§the-double-subarray-call-pattern** — `bytes.subarray(0, length).subarray(begin, end)` for two-step restriction.
- **§the-`copyWithin`-named-internal-bytes-copy-pattern** — intra-buffer copy via Uint8Array.copyWithin.
- **§the-default-capacity-16-as-named-initial-buffer-size** — power of 2 aligning with doubling strategy.
- **§the-named-shell-and-state-shape** — class IS the public API; WeakMap entry IS the state; `getPrivateFields(this)` IS the bridge.
- **§the-class-method-IS-a-thin-wrapper-around-private-fields** — every method starts with `const fields = getPrivateFields(this);`.
- **§the-no-`harden`-on-private-fields** — WeakMap holds mutable JS objects; privacy IS what protects, not freezing.
- **§the-named-error-class-tells-the-class-of-failure** — `Error` for runtime-state + `TypeError` for input-validation.
- **§three-cycles-with-`Error()`-without-`new`-shorthand** (280 + 284 + 290).
- **§the-`set index(index)`-argument-name-same-as-property pattern** — JavaScript allows the syntactic shadowing.
- **§the-`fields.bytes.set(bytes, fields.index)`-named-bulk-byte-write** — Uint8Array.set IS the named bulk-write primitive; no loop needed.
- **§the-`fields.index += N`-named-cursor-advance pattern** — cursor IS mutable and named-advanced-by-the-write-call.
- **§the-cursor-and-watermark-coordinate** — two named state coordinates.
- **§the-`get length()` and `get index()`-but-no-bytes-getter** — public API IS narrower than private state.
- **§three-cycles-with-public-API-narrower-than-private-state** (284 stat-class-internal + 286 table-module-scope-private + 290 bytes-and-data-private).
- **§named-two-shapes-of-missing-in-the-zip-cluster** — read-throws-on-missing-file (cycle 284) vs get-private-fields-throws-on-missing-instance (cycle 290 buffer-writer.js).
- **§the-WeakMap-private-fields-IS-structurally-opaque** — the named pattern predates `#`-fields and IS structurally hidden from `Object.getOwnPropertyNames`.

## Section files

- [§WeakMap-private-fields with getPrivateFields helper + §doubling-capacity-strategy + §five-field-private-record + §DataView.setUint8/16/32 binary-write API + 31 more first-explicit-observations](../sections/endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API.md) — full 188-line file in scope at cycle 290 per-file deep ingest after cluster-scope in cycle 191.

## Ingest scope

Cycle 290 (chat-lane after cycle 289 designs-lane packages/chat/designs/outliner_drag_and_drop.md). Full 188-line file in scope. **First-explicit-observations (thirty-five)** as a per-file deep ingest expanding on cycle 191's cluster-scope coverage.
