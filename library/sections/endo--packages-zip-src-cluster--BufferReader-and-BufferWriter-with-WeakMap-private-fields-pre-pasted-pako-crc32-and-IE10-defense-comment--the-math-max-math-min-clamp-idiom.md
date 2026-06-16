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
title: §The-§Math.max-Math.min-clamp-idiom
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
size = Math.max(0, Math.min(fields.length - fields.index, size));
```

§Clamps-`size`-to-`[0, remaining-bytes]`. §Without-the-clamp,
a caller asking for `read(1000)` when only 100 bytes remain
would either read undefined-territory or throw.

§The-clamp-then-special-case-zero pattern: clamp first; if
the result is zero, return empty (with IE10 defense). §The-
canonical-no-data-no-empty-array pattern.

§Compare-to-cycle-178-snapshot's §SHA-256-computed-on-the-fly
+ §atomic-rename-after-write. §Both-are-§streaming-discipline
patterns; cycle 191-zip-buffer-reader's clamp lets §back-
pressure-cooperatively rather than throw.
