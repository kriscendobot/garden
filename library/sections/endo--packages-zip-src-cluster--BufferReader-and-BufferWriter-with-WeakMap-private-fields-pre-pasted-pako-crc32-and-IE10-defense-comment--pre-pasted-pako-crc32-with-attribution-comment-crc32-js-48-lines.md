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
title: §Pre-pasted-pako-crc32-with-attribution-comment (crc32.js, 48 lines)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
/**
 * The following functions `makeTable` and `crc32` come from `pako`, from
 * pako/lib/zlib/crc32.js released under the MIT license, see pako
 * https://github.com/nodeca/pako/
 */

// Use ordinary array, since untyped makes no boost here
function makeTable() {
  let c;
  const table = [];
  for (let n = 0; n < 256; n += 1) {
    c = n;
    for (let k = 0; k < 8; k += 1) {
      c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    }
    table[n] = c;
  }
  return table;
}

const table = makeTable();

export function crc32(bytes, length = bytes.length, index = 0, crc = 0) {
  const end = index + length;
  crc ^= -1;
  for (let i = index; i < end; i += 1) {
    crc = (crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xff];
  }
  return (crc ^ -1) >>> 0;
}
```

§The-pre-pasted-pako-discipline: §explicit-attribution-in-
source for borrowed code. §Names-the-source-file (pako/lib/
zlib/crc32.js), §names-the-license (MIT), §names-the-URL
(github.com/nodeca/pako). §A-future-auditor can verify
provenance without spelunking.

§Compare-to-cycle-181-base64's §monodu-etymology-as-comment
("If an alphabet is named for alpha and beta then clearly a
monodu is named for the corresponding Greek numbers mono and
duo"). §Both-are-§code-comment-as-attribution patterns at
different scales; cycle 181 attributes a naming-choice; cycle
191 attributes an entire-function-borrowing.

§The-§"Use ordinary array, since untyped makes no boost here"
comment explains why `makeTable()` returns `Array<number>`
rather than `Uint32Array`. §Benchmarked-decision-named-in-
comment (sibling to cycle 181 base64's "string concatenation
is about 25% faster than building an array and joining it in
v8").

§The-§polynomial-0xedb88320 is the §IEEE-802.3-CRC-32
polynomial reflected. §Module-load-time-table-construction
(256 entries × 8 iterations = 2048 operations once, then
constant-time lookup per byte forever).

§Tier-1-borrowing: §pre-pasted-pako-with-attribution-comment
applies wherever a §reference-implementation is copied from
upstream. §The-comment-block-is-the-audit-trail.
