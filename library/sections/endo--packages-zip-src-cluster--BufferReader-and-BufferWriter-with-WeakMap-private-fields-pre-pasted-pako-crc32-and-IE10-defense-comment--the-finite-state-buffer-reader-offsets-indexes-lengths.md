---
source: packages/zip/src/{buffer-reader,buffer-writer,crc32,signature,compression,reader,writer}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/zip/src
source_path: packages/zip/index.js, packages/zip/src/buffer-reader.js, packages/zip/src/buffer-writer.js, packages/zip/src/crc32.js, packages/zip/src/signature.js, packages/zip/src/compression.js, packages/zip/src/reader.js, packages/zip/src/writer.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - bundles
  - tooling
genre: §endo-source-comment-fragment §canonical-byte-format-package
cycle: 191
lane: chat
status: current
title: §The-finite-state-Buffer Reader (offsets, indexes, lengths)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
/**
 * @typedef {object} BufferReaderState
 * @property {Uint8Array} bytes
 * @property {DataView} data
 * @property {number} length
 * @property {number} index
 * @property {number} offset
 */
```

§Five-state-fields: bytes + data + length + index + offset.

§bytes: the underlying Uint8Array.
§data: the DataView over the same buffer (for getUint16/32
endianness).
§length: usable byte count.
§index: current read position (relative to offset).
§offset: base offset within bytes (for sliced readers).

§The-§offset+index-pair lets a parent ZipReader pass a §sub-
window-of-bytes to a sub-parser without copying. §`setter
offset(offset)` updates both `offset` and `length`
atomically: `fields.length = fields.data.byteLength -
fields.offset`.

§Compare-to-cycle-179-lp32's §single-growing-buffer + §`copyWithin(0,
envelopeLength)` shift. §Cycle-179-uses-an-explicit-shift to
free buffer space; §cycle-191-uses-offset-pointer to read
windows-of-a-buffer-without-shifting. §Different-tradeoffs
for §streaming vs §random-access.

§The-`assertCanSeek` / `assertCanRead` pair are §two-flavors-
of-bound-check: absolute (index) + relative (current + offset).
§Both-named-explicitly-with-Error-messages.
