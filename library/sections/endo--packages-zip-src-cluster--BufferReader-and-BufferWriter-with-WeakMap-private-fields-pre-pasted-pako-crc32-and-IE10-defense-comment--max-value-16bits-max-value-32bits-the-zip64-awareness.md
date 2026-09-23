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
title: §MAX_VALUE_16BITS + MAX_VALUE_32BITS (the ZIP64 awareness)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
const MAX_VALUE_16BITS = 65535;
const MAX_VALUE_32BITS = 4294967295;
```

§Two-named-constants for §ZIP64-format-detection. §ZIP64-is-
needed when a value would overflow 16 or 32 bits in the
classic-zip-format. §`format-reader.js` uses these to detect
when ZIP64-extensions are required.

§The-package-supports-reading-ZIP64 (via the two locator
signatures); §the-package-does-not-support-writing-ZIP64
(format-writer.js doesn't emit the ZIP64 records). §Asymmetric-
support is a §read-tolerant-write-strict pattern (sibling to
Postel's law).
