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
title: §STORE-only-zip (the §scope-limitation discipline)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
// compression.js — full file
// @ts-check

// STORE is the magic number for "not compressed".
export const STORE = 0;
```

§Four-lines-and-a-comment. §The-comment-is-§the-scope-
limitation-named-explicitly: this package only supports
uncompressed zip files (STORE = 0). §No-DEFLATE (8), no-
DEFLATE64, no-BZIP2, no-LZMA, no-Zstd.

§Why: §the-§dependency-cost. §DEFLATE-needs-zlib-or-equivalent
which is significant code. §Endo-uses-zip-as-a-bundle-format
where the bundle's own compression discipline (via
compartment-mapper's encoding choices) is separate from the
zip-container's compression. §An-uncompressed-zip is just a
manifest + concatenated files.

§Compare-to-cycle-180-hex-package's §six-non-goals (and cycle
190 endo-posix-sandbox's §six-non-goals). §STORE-only is §the-
§implicit-non-goal in the smallest possible file: four lines
that document what the package §isn't.

§Tier-1-borrowing: §scope-limitation-named-explicitly-in-tiny-
file. §A-four-line-file whose comment-name explains the
limitation can be referenced from elsewhere as §the-canonical-
location-of-this-decision.
