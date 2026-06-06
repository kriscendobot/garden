---
title: '@endo/zip: src/ (BufferReader + BufferWriter + crc32 + signatures + STORE)'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/zip
source_paths:
  - packages/zip/index.js
  - packages/zip/src/buffer-reader.js
  - packages/zip/src/buffer-writer.js
  - packages/zip/src/crc32.js
  - packages/zip/src/signature.js
  - packages/zip/src/compression.js
  - packages/zip/src/reader.js
  - packages/zip/src/writer.js
authors:
  - Kris Kowal (prompted)
ingested: 2026-06-04
ingested_by: scholar
topics:
  - bundles
  - tooling
sections:
  - endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment.md
genre: §endo-source-comment-fragment §canonical-byte-format-package
cycle: 191
lane: chat
---

# @endo/zip: store-only zip read/write substrate

## §Abstract

`@endo/zip` is a small focused 11-file package (1482 lines)
implementing §store-only-zip (no compression) reader/writer.
This ingest covers eight of the eleven files (~663 lines):
the substrate plus the small leaves. The two large files —
`format-reader.js` (479 lines) and `format-writer.js` (264
lines) — are not part of this ingest.

§Four-named-moves:

1. §WeakMap-private-fields-with-bound-get is the Endo
   canonical-discipline for module-private state, an
   alternative to JS class `#private` syntax.
2. §Pre-pasted-pako-crc32-with-attribution-comment names the
   source-file (pako/lib/zlib/crc32.js), license (MIT), and
   URL (github.com/nodeca/pako) in source — audit-trail-in-
   source for borrowed code.
3. §IE10-defense-comment-for-historical-ghost preserves a
   defense for a platform that's been dead since 2016, with
   named-rationale-in-source so the next maintainer can
   decide whether to remove it.
4. §STORE-only-zip in a four-line `compression.js` is the
   §scope-limitation-named-in-tiny-file pattern.

§Cycle-186-Cut-3 deleted vestigial @endo/zip devDeps; this
zip package is the §simplest-leaf-consumer in the broken
13-package SCC.

§Sibling-to-cycle-179-lp32: both are §canonical-byte-format
packages with §doubling-capacity buffers and §DataView-
rebuild-after-capacity-change discipline. §Different-tradeoffs
between §streaming-with-shift (lp32) and §random-access-with-
offset (zip).

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `packages/zip/index.js` | 4 | Re-export barrel |
| `packages/zip/src/buffer-reader.js` | 274 | Uint8Array+DataView+WeakMap |
| `packages/zip/src/buffer-writer.js` | 188 | Doubling-capacity + ensureCanSeek |
| `packages/zip/src/crc32.js` | 48 | Pre-pasted pako with attribution |
| `packages/zip/src/signature.js` | 21 | PK\x03\x04 magic numbers + u-helper |
| `packages/zip/src/compression.js` | 4 | STORE = 0 only |
| `packages/zip/src/reader.js` | 60 | ZipReader class + readZip async wrapper |
| `packages/zip/src/writer.js` | 64 | ZipWriter class + writeZip async wrapper |
| `packages/zip/src/format-reader.js` | 479 | Not ingested this cycle |
| `packages/zip/src/format-writer.js` | 264 | Not ingested this cycle |
| `packages/zip/src/types.js` | 76 | Not ingested this cycle |

## §Provenance and dependencies

- §Pre-pasted-pako-crc32: derived from pako/lib/zlib/crc32.js
  (MIT license; github.com/nodeca/pako).
- §DOS-date-time-spec: Ralph-Brown-Interrupt-List
  (delorie.com docs; cited via two `@see` URLs).
- §ZIP-format-spec: PKWARE APPNOTE (implicit; not cited in
  source).
- §Built-on `crc32.js` for content-hash verification.
- §No-cross-package-dependencies (true §sink-only leaf in
  cycle 186's SCC analysis; Cut 3 deleted vestigial devDeps).
- §Consumers: `@endo/compartment-mapper` (for endoZipBase64
  bundle format), `@endo/daemon` (snapshot archives), §any-
  caller-of-`@endo/check-bundle` (cycle 185 consumer chain).

## §Related sources in the library

- §Cycle 179 (`endo--packages-lp32-reader-writer-js.md`) —
  §sibling-byte-format-package. lp32 is §streaming; zip is
  §random-access; both share §doubling-capacity and §DataView-
  rebuild-after-capacity-change.
- §Cycle 181 (`endo--packages-base64-src-encode-decode-js.md`)
  — §module-load-capture-of-primitive-method sibling
  (Reflect.apply.bind / privateFields.get.bind).
- §Cycle 183 (`endo--packages-init-and-lockdown.md`) —
  §captured-at-module-load sibling for the SES discipline.
- §Cycle 185 (`endo--packages-check-bundle-js.md`) — §sibling-
  consumer of @endo/zip via @endo/compartment-mapper's
  parseArchive for hash-of-hashes verification.
- §Cycle 186 (`endo-but-for-bots--llm-designs-break-dev-
  dependency-cycles.md`) — §Cut-3 deleted @endo/zip's
  vestigial devDeps; this zip package is the §simplest-leaf-
  consumer in cycle 186's SCC analysis.
- §Cycle 188 / 189 (cycle 188's `@ts-expect-error 2454` +
  cycle 189's `@ts-expect-error 2454`) — §`@ts-expect-error`-
  with-named-reason sibling.

## §Comment fragments worth preserving

```
// The following functions `makeTable` and `crc32` come from `pako`, from
// pako/lib/zlib/crc32.js released under the MIT license, see pako
// https://github.com/nodeca/pako/
```

§The-§pre-pasted-with-attribution-comment. §Names-the-source-
file (pako/lib/zlib/crc32.js) + license (MIT) + URL
(github.com/nodeca/pako).

```
// in IE10, when using subarray(idx, idx), we get the array
// [0x00] instead of [].
```

§The-§IE10-defense-comment-for-historical-ghost. §Names-the-
platform-bug (IE10) + the defensive-fix (explicit `new
Uint8Array(0)`). §Don't-silently-remove-defenses-for-dead-
platforms.

```
// Use ordinary array, since untyped makes no boost here
```

§Benchmarked-decision-named-in-comment (sibling to cycle
181-base64's "string concatenation about 25% faster than
building an array and joining in v8"). §Explains-why-not-
Uint32Array for the CRC table.

```
// STORE is the magic number for "not compressed".
```

§The-§scope-limitation-named-in-tiny-file. §Four-lines-and-
this-comment.
