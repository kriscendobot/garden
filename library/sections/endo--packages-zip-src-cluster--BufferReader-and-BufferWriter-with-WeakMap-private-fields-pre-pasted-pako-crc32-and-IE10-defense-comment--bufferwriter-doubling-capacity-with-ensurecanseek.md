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
title: §BufferWriter §doubling-capacity-with-ensureCanSeek
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
ensureCanSeek(required) {
  assertNatNumber(required);
  const fields = getPrivateFields(this);
  let capacity = fields.capacity;
  while (capacity < required) {
    capacity *= 2;
  }
  const bytes = new Uint8Array(capacity);
  const data = new DataView(bytes.buffer);
  bytes.set(fields.bytes.subarray(0, fields.length));
  fields.bytes = bytes;
  fields.data = data;
  fields.capacity = capacity;
}
```

§Doubling-growth-strategy (sibling to cycle 179-lp32 §single-
growing-buffer with doubling-capacity). §The-§ensureCanSeek
discipline: called before every write to guarantee capacity.

§The-§DataView-rebuild after capacity-change: DataView is
bound to ArrayBuffer; growing the Uint8Array means a new
ArrayBuffer; the DataView must be replaced.

§Compare-to-cycle-179-lp32's §DataView-replaced-when-buffer-
grows comment. §Both-files-name-this-as-a-known-correctness-
hazard. §Cycle-191-zip-just-replaces; cycle-179-lp32 explains
why ("DataViews are bound to ArrayBuffers, not to
Uint8Arrays").

§The-§assertNatNumber check is at the top of every write:

```js
const assertNatNumber = n => {
  if (Number.isSafeInteger(n) && n >= 0) {
    return;
  }
  throw TypeError(`must be a non-negative integer, got ${n}`);
};
```

§Defense-against-NaN-Infinity-negative-fractional. §Number
.isSafeInteger is the canonical check for "a number that's
also a valid integer index."
