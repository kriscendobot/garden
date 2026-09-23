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
title: §The-u-helper-for-ASCII-Uint8Array (signature.js)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
/**
 * @param {string} string
 * @returns {Uint8Array}
 */
function u(string) {
  const array = new Uint8Array(string.length);
  for (let i = 0; i < string.length; i += 1) {
    array[i] = string.charCodeAt(i) & 0xff;
  }
  return array;
}

export const LOCAL_FILE_HEADER = u('PK\x03\x04');
export const CENTRAL_FILE_HEADER = u('PK\x01\x02');
export const CENTRAL_DIRECTORY_END = u('PK\x05\x06');
export const ZIP64_CENTRAL_DIRECTORY_LOCATOR = u('PK\x06\x07');
export const ZIP64_CENTRAL_DIRECTORY_END = u('PK\x06\x06');
export const DATA_DESCRIPTOR = u('PK\x07\x08');
```

§Six-magic-number-constants for the zip format's §six-
canonical-signatures (LOCAL_FILE_HEADER + CENTRAL_FILE_HEADER
+ CENTRAL_DIRECTORY_END + ZIP64_CENTRAL_DIRECTORY_LOCATOR +
ZIP64_CENTRAL_DIRECTORY_END + DATA_DESCRIPTOR).

§The-`u`-helper compresses 4-line-Uint8Array-construction
into a one-call expression. §`charCodeAt(i) & 0xff` truncates
to ASCII range — the §& 0xff is §defensive-against-non-ASCII
even though the input strings are all `'PK\x??\x??'`.

§Compare-to-cycle-152-pass-style/symbol.js' §Hilbert-Hotel-
encoding for "namespaces-that-could-collide". §Both-are-
§factory-functions-for-canonical-constants but at different
abstraction levels.

§The-§string-as-byte-literal-shorthand idiom: `'PK\x03\x04'`
is a 4-character string where two characters are explicit
ASCII (`P`, `K`) and two are escaped bytes (`\x03`, `\x04`).
§More-readable-than `new Uint8Array([0x50, 0x4b, 0x03, 0x04])`
because the `PK` prefix is visible.

§Six-magic-numbers documents the zip-format's §sub-record-
families. §ZIP64-extensions (the last two) are partially
supported in read-direction (format-reader.js).
