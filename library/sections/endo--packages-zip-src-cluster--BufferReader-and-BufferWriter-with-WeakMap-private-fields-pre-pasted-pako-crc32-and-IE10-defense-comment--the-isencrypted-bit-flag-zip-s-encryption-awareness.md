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
title: §The-`isEncrypted` bit-flag (zip's encryption awareness)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
function isEncrypted(bitFlag) {
  return (bitFlag & 0x0001) === 0x0001;
}
```

§One-bit-check. §Zip-bit-0 is "encrypted." §The-package-
detects-but-doesn't-decrypt: format-reader.js can identify an
encrypted entry and §refuse-it (the package is §STORE-only +
§unencrypted; encryption is an §implicit-non-goal).
