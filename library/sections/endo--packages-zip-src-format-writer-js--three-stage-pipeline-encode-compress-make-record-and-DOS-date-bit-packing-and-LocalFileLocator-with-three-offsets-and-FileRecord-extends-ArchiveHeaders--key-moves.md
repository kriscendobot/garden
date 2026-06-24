---
title: Key moves
section-slug: endo--packages-zip-src-format-writer-js--three-stage-pipeline-encode-compress-make-record-and-DOS-date-bit-packing-and-LocalFileLocator-with-three-offsets-and-FileRecord-extends-ArchiveHeaders
source-slug: endo--packages-zip-src-format-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/format-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/format-writer.js
total-lines: 264
ingest-cycle: 294
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-format-writer-js--three-stage-pipeline-encode-compress-make-record-and-DOS-date-bit-packing-and-LocalFileLocator-with-three-offsets-and-FileRecord-extends-ArchiveHeaders
---

- **§the-three-stage-pipeline-encode-compress-make-record** (first-explicit-observation):

```javascript
export function writeZip(writer, files, comment = '') {
  const encodedFiles = files.map(encodeFile);
  const compressedFiles = encodedFiles.map(compressFileWithStore);
  const fileRecords = compressedFiles.map(makeFileRecord);
  writeZipRecords(writer, fileRecords, comment);
}
```

**§three-named-`.map()`-stages** of the pipeline. Each stage IS a *named typed transformation*: `ArchivedFile → UncompressedFile → CompressedFile → FileRecord`. **§the-named-four-staged-record-progression** (extends cycle 282's three-shapes-of-the-file-typedef into four).

§the-named-pipeline-IS-three-named-typed-transforms: each stage corresponds to a named typedef + a named function. The composition IS explicit; the types IS at the boundaries.

- **§the-DOS-date-time-bit-packing-with-trailing-comments-naming-each-field** (first-explicit-observation):

```javascript
const dosTime =
  date !== undefined && date !== null
    ? (((date.getUTCFullYear() - 1980) & 0x7f) << 25) | // year
      ((date.getUTCMonth() + 1) << 21) | // month
      (date.getUTCDate() << 16) | // day
      (date.getUTCHours() << 11) | // hour
      (date.getUTCMinutes() << 5) | // minute
      (date.getUTCSeconds() >> 1) // second
    : 0; // Epoch origin by default.
```

**§the-named-bit-field-encoding-with-each-bit-range-trailing-comment**: every line of the bit-packed encoding has a trailing comment naming the field. **§the-trailing-comments-IS-the-named-bit-layout-documentation**.

§six-named-fields-packed-into-32-bits with shifts: year (25-31) + month (21-24) + day (16-20) + hour (11-15) + minute (5-10) + second (0-4). **§six-named-bit-fields-in-one-uint32**.

- **§the-DOS-epoch-shift-1980** (first-explicit-observation): `(date.getUTCFullYear() - 1980) & 0x7f`. **§the-named-historical-epoch**: DOS dates count years from 1980, with 7 bits (max 127 years past 1980 = 2107).

§the-`& 0x7f`-mask-IS-the-7-bit-truncation: years beyond 2107 silently wrap. §named-historical-format-limitation.

- **§the-DOS-two-second-resolution** (first-explicit-observation): `date.getUTCSeconds() >> 1`. **§the-named-loss-of-precision**: DOS time only stores 5 bits for seconds (0-31), each representing a 2-second interval. **§the-format-IS-named-low-resolution-historical**.

§the-named-three-historical-format-limitations: 7-bit year + 2-second resolution + month-encoded-as-1-indexed (the `+ 1` on `getUTCMonth()`).

- **§the-`: 0; // Epoch origin by default.`-comment** (first-explicit-observation): when no date IS provided, the dosTime IS `0` — which in DOS encoding IS the *epoch origin*. **§the-named-zero-IS-the-default-encoding-meaning-epoch-origin**. The comment names *what `0` means in the format*, not just that it's the default.

§the-comment-IS-the-named-protocol-interpretation-of-the-zero-value.

- **§the-three-typedef-block-at-the-top** (first-explicit-observation): the file opens with **three named typedefs** before any code:
  - `LocalFileLocator` (three named offsets: fileStart + headerStart + headerEnd)
  - `FileRecord` (extends `ArchiveHeaders` via intersection type)
  - `BufferWriter` (the local interface-shape declaration)

**§the-named-local-interface-shape-declaration**: instead of *importing* `BufferWriter` from buffer-writer.js, the file declares a *structural-typing-version* of the BufferWriter interface inline. **§the-named-duck-typed-local-interface**: any object matching the shape can be passed in.

§the-named-decoupling-via-structural-typing: format-writer.js doesn't depend on the concrete BufferWriter class; it accepts anything with the named methods.

- **§the-`FileRecord = Y & import('./types.js').ArchiveHeaders` intersection-type-extension** (first-explicit-observation): the FileRecord typedef IS a *local addition* (name + centralName + madeBy + version + diskNumberStart + internalFileAttributes + externalFileAttributes + content + comment) **intersected with** the shared `ArchiveHeaders` typedef (from types.js).

```typescript
@typedef {{
  name: Uint8Array,
  centralName: Uint8Array,
  madeBy: number,
  // ...
} & import('./types.js').ArchiveHeaders} FileRecord
```

**§the-named-extension-via-intersection-type-on-imported-typedef**: format-writer.js *extends* the shared shape with format-specific fields. This IS the named composition shape. **§the-named-extension-of-shared-typedef**.

§the-named-two-named-extension-shapes for JSDoc typedefs: cycle 282's `& BaseType` (single intersection from base) vs cycle 294's `& import('X').Y` (single intersection from imported-base). **§three-cycles-with-intersection-type-syntax-in-JSDoc-typedef** (282 + 294).

- **§the-`LocalFileLocator` three-named-offsets** (first-explicit-observation): `{ fileStart, headerStart, headerEnd }`. **§the-named-locator-record-tracks-three-offsets** so the central-directory-header-writer can *re-copy* the header bytes via `writer.writeCopy(locator.headerStart, locator.headerEnd)`.

§the-named-locator-IS-the-named-cross-record-reference-shape.

- **§the-`writer.writeCopy(locator.headerStart, locator.headerEnd)` intra-buffer-byte-reuse** (first-explicit-observation): the central-directory-file-header includes the *same bytes* as the local-file-header (between `headerStart` and `headerEnd`). Rather than re-encode, the writer *copies the bytes within the buffer*. **§the-named-bytes-reused-via-copyWithin** (sibling to cycle 290's §the-`copyWithin`-named-internal-bytes-copy-pattern; **§two-cycles-with-named-intra-buffer-byte-reuse** in the cluster: 290 + 294).

§the-discipline-IS-encode-once-copy-elsewhere: the bit-packed bytes for a file's local header are re-used in the central directory entry, avoiding the double-encoding.

- **§the-`UNIX = 3` + `UNIX_VERSION = 30`-named-constants** (first-explicit-observation):

```javascript
const UNIX = 3;
const UNIX_VERSION = 30;
```

**§two-named-zip-format-constants** for the host-os and version. **§the-named-magic-number-IS-named-explicitly** — instead of inlining `3` and `30`, the file gives them names. §the-named-constant-IS-the-named-documentation.

§named-historical-format-data: the zip spec uses these numbers to encode where the file came from (Unix host) and the spec version.

- **§the-module-scope-`textEncoder = new TextEncoder()` singleton** (first-explicit-observation):

```javascript
const textEncoder = new TextEncoder();
```

**§the-named-module-scope-singleton-encoder**: one `TextEncoder` instance reused across all `encode()` calls. **§the-singleton-IS-the-named-amortization-shape**: TextEncoder creation IS not free; allocating once at module load saves per-call cost.

§the-named-eager-singleton: the encoder IS created at module-load time. Sibling-pattern to cycle 286's `const table = makeTable();` (also a module-load-time amortization). **§three-cycles-with-module-load-time-amortization-shapes** (286 crc32 table + 290 buffer-writer DEFAULT capacity + 294 textEncoder; actually 290's default IS not module-load, so this is just 286 + 294 + earlier).

- **§the-name-with-backslash-to-forward-slash-normalization** (first-explicit-observation):

```javascript
const name = textEncoder.encode(file.name.replace(/\\/g, '/'));
```

**§the-named-Windows-path-separator-normalization**: zip names normalize to forward slashes regardless of host. **§the-named-platform-portability-normalization-at-encode-time**.

§the-named-discipline-IS-canonical-format-at-the-boundary: zip names IS always forward-slashes inside the archive; the platform difference IS resolved at the encode boundary.

- **§the-named-TODO-comments** (first-explicit-observation): multiple `// TODO` comments name *future work*:
  - `// TODO count of extra fields length`
  - `// TODO write extra fields`
  - `// TODO extra fields length`
  - `// TODO extra fields`
  - `// TODO this is probably too lax.` (on `versionNeeded: 0`)
  - `// TODO collate directoryRecords from file bases.`
  - `// TODO Add support for directory records.` (block-commented function)

**§the-named-TODO-IS-the-named-acknowledgment-of-incomplete-implementation**. The TODOs IS not random reminders; they enumerate *specific format features* not yet supported (extra fields + directory records + versionNeeded too lax).

§the-named-incompleteness-discipline (sibling to cycle 291's `## Work in Progress` section + cycle 291's `TBD:` list): the code-level TODO IS the named in-place equivalent of the design-doc-level open-question section.

§three-named-shapes-for-tracking-deferred-work: in-design-doc `## Open Questions` (cycle 283 + 287) + in-design-doc `TBD:` (cycle 291) + in-code `// TODO` (cycle 294).

- **§the-commented-out-named-future-function** (first-explicit-observation):

```javascript
// TODO Add support for directory records.
// /**
//  * @param {number} mode
//  * @return {number}
//  */
// function externalDirectoryAttributes(mode) {
//   // The 0x10 is the DOS directory attribute, which is set regardless of platform.
//   return ((mode & 0o777) | 0o40000) << 16 | 0x10;
// }
```

**§the-named-block-commented-function-as-named-stub-preserving-implementation**: the function IS *written* but *commented out* (with TODO above). This IS a *placeholder with concrete intent*: the next person to add directory-record support has the implementation already drafted; they just need to uncomment and wire it up.

§the-named-comment-out-IS-the-named-deferred-implementation: distinct from a TODO that names *what's missing*; this names *how to do it*. **§two-named-shapes-of-deferred-work-in-code**: in-line-TODO (names the gap) + commented-block (names the gap AND drafts the solution).

§the-named-`// The 0x10 is the DOS directory attribute, which is set regardless of platform.` comment INSIDE the commented-out function: even in deferred code, the format-specific magic-number IS documented.

- **§the-`externalFileAttributes(mode)` Unix-mode-shifted-to-zip-format** (first-explicit-observation):

```javascript
function externalFileAttributes(mode) {
  return ((mode & 0o777) | 0o100000) << 16;
}
```

**§the-named-format-encoding-with-named-bit-positions**: `0o777` mask (Unix permission bits) + `0o100000` (regular-file marker in Unix `st_mode`) + `<< 16` (shift into zip external-attributes-position).

§three-named-bit-operations-in-one-expression: mask + or + shift. §the-named-Unix-mode-IS-shifted-into-zip-encoding pattern.

§the-named-magic-octal-literals: `0o777` IS the Unix permission mask; `0o100000` IS the regular-file `S_IFREG` constant. The code uses octal literals (`0o...`) consistent with Unix tradition; §the-discipline-IS-named-octal-for-Unix-permissions.

- **§the-`compressFileWithStore`-named-for-the-only-supported-compression** (first-explicit-observation): the function name explicitly says "WithStore" — meaning "compress with the STORE method (= no compression)". **§the-named-function-name-IS-explicit-about-the-no-compression-discipline**.

§the-discipline-IS-named-store-only-zip (cycle 191's cluster ingest observation): the format-writer doesn't actually compress; it stores. The function name names this honestly.

§the-named-`compressionMethod: compression.STORE` reaffirms this. The CRC IS still computed (so consumers can verify integrity), but the bytes IS uncompressed.

- **§the-`crc32(file.content)` IS-called-with-only-bytes** (first-explicit-observation):

```javascript
crc32: crc32(file.content),
```

**§the-named-default-parameters-pay-off**: cycle 286 noted `crc32(bytes, length = bytes.length, index = 0, crc = 0)`. Here only the first argument is passed — the defaults cover the rest. **§the-named-incremental-API-supports-the-simple-case-trivially**: the default-parameter shape lets the simple call sites IS one-argument; the streaming case IS four-argument.

§the-named-API-pays-off-at-the-call-site: cycle 286 named the default-parameter shape; cycle 294 names the simple call site that benefits.

- **§the-named-three-public-export-shapes** (first-explicit-observation):

```javascript
export function writeZipRecords(...)  // takes pre-built FileRecord[]
export function writeZip(...)         // takes ArchivedFile[] (the public-API path)
```

**§the-named-low-level-and-high-level-public-API**: `writeZipRecords` IS the low-level path (caller pre-builds records); `writeZip` IS the high-level path (caller passes raw archived-files). **§the-named-two-tier-API**: power-user-and-default-user.

§the-named-three-stage-pipeline-IS-encapsulated-inside-writeZip: the high-level entry point hides the encode → compress → makeFileRecord pipeline from casual callers.

- **§the-named-`@see` external-references** (first-explicit-observation):

```javascript
/**
 * @param {BufferWriter} writer
 * @param {Date?} date
 * @see http://www.delorie.com/djgpp/doc/rbinter/it/65/16.html
 * @see http://www.delorie.com/djgpp/doc/rbinter/it/66/16.html
 */
function writeDosDateTime(writer, date) {
```

**§the-named-`@see`-as-named-external-reference-anchor**: two named external URLs for the DOS date and time encoding spec. **§the-named-vocabulary-deference** (extends cycle 293's tc39-glossary-link pattern).

§three-cycles-with-named-vocabulary-deference (cycle 293 tc39 + cycle 294 DJGPP-DOS-spec).

- **§the-`Date?`-typedef-shape-reaffirmed** (cycle 282 observation now reaffirmed; first per-file instance in this context): `@param {Date?} date` uses the JSDoc-shorthand for nullable. **§two-cycles-with-the-`Date?`-shorthand** (282 types.js + 294 format-writer.js).
