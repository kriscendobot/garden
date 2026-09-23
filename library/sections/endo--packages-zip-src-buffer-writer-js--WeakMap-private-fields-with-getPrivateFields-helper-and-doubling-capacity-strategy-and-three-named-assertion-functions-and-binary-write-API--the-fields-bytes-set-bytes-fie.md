---
title: §the-`fields.bytes.set(bytes, fields.index)` named-bulk-byte-write (first-explicit-observation)
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

```javascript
write(bytes) {
  const fields = getPrivateFields(this);
  this.ensureCanWrite(bytes.byteLength);
  fields.bytes.set(bytes, fields.index);
  fields.index += bytes.byteLength;
  fields.length = Math.max(fields.index, fields.length);
}
```

**§the-Uint8Array.set-IS-the-named-bulk-write-primitive**: writes an entire source array at a given offset. **No loop needed** in the writer. The Uint8Array API IS doing the per-byte copy internally — typically via SIMD or memcpy.

§the-named-vectorized-bulk-write-via-platform-API IS the named alternative to a per-byte for-loop.
