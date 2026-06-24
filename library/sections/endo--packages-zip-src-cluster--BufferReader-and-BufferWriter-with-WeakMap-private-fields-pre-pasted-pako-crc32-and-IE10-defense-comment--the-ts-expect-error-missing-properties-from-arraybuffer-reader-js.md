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
title: §The-`@ts-expect-error missing properties from ArrayBuffer` (reader.js)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
constructor(data, options = {}) {
  const { name = '<unknown>' } = options;
  // @ts-expect-error missing properties from ArrayBuffer
  const reader = new BufferReader(data);
  // ...
}
```

§The-comment names that ZipReader's constructor accepts
`Uint8Array` (the API surface) but BufferReader's constructor
declares `ArrayBuffer` (the actual storage). §A-Uint8Array-is-
a-view-of-an-ArrayBuffer-but-has-different-typescript-
properties.

§The-`@ts-expect-error` discipline: explicit narrow
suppression with named reason. §Sibling-to-cycle-188-perf's
`@ts-expect-error 2454` + cycle 181-base64's `/** @type {any}
*/` casts + cycle 189-marshal-justin's `@ts-expect-error 2454`.
§The-`@ts-expect-error N` (with named TS-error-code) is the
§canonical-Endo-pattern; cycle 191 omits the code here (just
"missing properties").
