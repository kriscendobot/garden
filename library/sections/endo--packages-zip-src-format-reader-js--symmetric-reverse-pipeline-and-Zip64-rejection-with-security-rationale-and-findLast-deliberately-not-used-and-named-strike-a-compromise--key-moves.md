---
title: Key moves
section-slug: endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise
source-slug: endo--packages-zip-src-format-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/format-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/format-reader.js
total-lines: 479
ingest-cycle: 296
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise
---

- **§the-symmetric-reverse-pipeline** (first-explicit-observation): the reader's pipeline reverses cycle 294's writer pipeline:

| Stage | Writer (cycle 294) | Reader (cycle 296) |
|---|---|---|
| 1 | `encodeFile` (ArchivedFile → UncompressedFile) | `recordToFile` (CentralRecord+LocalRecord → CompressedFile) |
| 2 | `compressFileWithStore` (UncompressedFile → CompressedFile) | `decompressFile` (CompressedFile → UncompressedFile) |
| 3 | `makeFileRecord` (CompressedFile → FileRecord) | `decodeFile` (UncompressedFile → ArchivedFile) |
| Public entry | `writeZip(files, comment)` | `readZip(reader, name)` |

**§the-named-three-named-reverse-stages**: each forward stage has a *named reverse*. **§the-named-pipeline-IS-bidirectional-with-named-inverses** — extends cycle 294's §the-named-four-staged-record-progression to **§the-four-staged-record-progression-IS-bidirectional**.

- **§the-reverse-DOS-date-time-bit-extraction** (first-explicit-observation): cycle 294 named the bit-packing; this file names the inverse extraction:

```javascript
return new Date(
  Date.UTC(
    ((dosTime >> 25) & 0x7f) + 1980, // year
    ((dosTime >> 21) & 0x0f) - 1, // month
    (dosTime >> 16) & 0x1f, // day
    (dosTime >> 11) & 0x1f, // hour
    (dosTime >> 5) & 0x3f, // minute
    (dosTime & 0x1f) << 1, // second
  ),
);
```

**§the-named-inverse-bit-extraction with-named-`>>`-and-mask-for-each-field**. The mask widths (`0x7f` + `0x0f` + `0x1f` + `0x1f` + `0x3f` + `0x1f`) IS the exact width of each bit field. **§the-bit-mask-width-matches-the-bit-field-width**.

§the-second-shift-IS-back-by-one: `(dosTime & 0x1f) << 1` reverses cycle 294's `>> 1` (the 2-second-resolution loss).

§two-cycles-with-DOS-date-time-bit-handling (294 packing + 296 extraction). **§the-two-cycles-IS-the-symmetric-pair**.

- **§the-Zip64-rejection-with-named-security-rationale** (first-explicit-observation): the file detects Zip64 indicators (via MAX_VALUE_16BITS or MAX_VALUE_32BITS in size/offset fields) and *throws rather than support*:

```javascript
if (headers.uncompressedLength === MAX_VALUE_32BITS) {
  throw Error('Cannot read Zip64');
}
// ... four more named MAX_VALUE checks ...

const zip64 =
  locator.diskNumber === MAX_VALUE_16BITS ||
  locator.diskWithCentralDirStart === MAX_VALUE_16BITS ||
  locator.centralDirectoryRecordsOnThisDisk === MAX_VALUE_16BITS ||
  locator.centralDirectoryRecords === MAX_VALUE_16BITS ||
  locator.centralDirectorySize === MAX_VALUE_32BITS ||
  locator.centralDirectoryOffset === MAX_VALUE_32BITS;

if (zip64) {
  throw Error('Cannot read Zip64');
}
```

**§the-named-six-named-Zip64-trigger-fields**: six named fields that, when they equal MAX_VALUE, signal Zip64 (the format version that handles >4GB archives). **§the-`MAX_VALUE` IS-the-named-Zip64-sentinel**.

§the-named-rejection-with-named-reason-shape: **the file IS named-explicitly-not-supporting-Zip64**. §the-named-rejected-feature-with-named-reason (sibling-pattern to cycle 287's §Eschewed-Alternatives-section and cycle 283's §three-named-rejected-alternatives-with-reasons).

- **§the-explicit-comment-against-`reader.findLast(signature.CENTRAL_DIRECTORY_END)`** (first-explicit-observation):

```javascript
// Zip files are permitted to have a variable-width comment at the end of the
// "end of central directory record" and may have subsequent Zip64 headers.
// The prescribed method of finding the beginning of the "end of central
// directory record" is to seek the magic number:
//
//   reader.findLast(signature.CENTRAL_DIRECTORY_END);
//
// This introduces a number of undesirable, attackable ambiguities
// Agoric is not comfortable supporting, so we forbid the comment
// and 64 bit zip support so we can seek a predictable length
// from the end.
const centralDirectoryEnd = reader.length - 22;
```

**§the-named-tool-IS-available-but-deliberately-not-used**: cycle 292's buffer-reader.js EXPOSES `findLast` as a public method (which IS noted as named "for zip's end-of-central-directory record"). But format-reader.js **deliberately doesn't use it** because the variable-length-search introduces "**undesirable, attackable ambiguities**". Instead, the code seeks to a fixed position (`reader.length - 22`).

§the-named-attackable-ambiguity-IS-the-named-design-driver: the named threat-model rules out the spec-compliant approach. **§the-named-strict-implementation-IS-narrower-than-the-spec-permits**.

**§two-cycles-with-named-tool-vs-deliberate-non-use** (cycle 292 declared findLast for zip + cycle 296 declared not-using-findLast for security).

§the-named-non-spec-compliance-with-named-security-rationale: the file IS *deliberately narrower than the spec* to eliminate attack vectors. **§the-named-narrower-implementation-IS-the-named-security-discipline**.

- **§the-named-`Agoric is not comfortable supporting`-as-named-organizational-trust-claim** (first-explicit-observation): the code comment names *the named organization* (Agoric) as the entity making the security judgment. **§the-named-attribution-of-the-design-judgment**.

§the-named-organizational-name-in-the-code-comment-IS-the-named-warning: future maintainers IS warned that this isn't a casual choice; it's a *deliberate organizational position*.

- **§the-named-Windows-vs-spec-filename-quirk** (first-explicit-observation):

```javascript
// In some zip files created on Windows, the filename stored in the central
// dir contains "\" instead of "/".  Strangely, the file name in the local
// directory uses "/" as specified:
// http://www.info-zip.org/FAQ.html#backslashes or APPNOTE#4.4.17.1, "All
// slashes MUST be forward slashes '/'") but there are a lot of bad zip
// generators...  Search "unzip mismatching "local" filename continuing with
// "central" filename version".
```

**§the-named-format-deviation-by-a-named-population-of-generators**: Windows zip-creators violate the spec by using backslashes in the central directory name. **§the-named-spec-deviation-in-the-wild**.

§the-named-search-string-IS-the-named-googleable-shorthand: "Search 'unzip mismatching ...'" — the comment offers a Google search query as a named reference. **§the-named-search-query-IS-the-named-external-anchor**.

- **§the-named-spoofing-attack-reference** (first-explicit-observation):

```javascript
// The reasoning appears to be that the central directory is for
// user display and may differ, though this opens the possibility
// for spoofing attacks.
// http://seclists.org/fulldisclosure/2009/Sep/394
```

**§the-named-CVE-style-link-as-named-vulnerability-anchor**: a link to the seclists full-disclosure mailing list for a 2009 vulnerability about zip-filename mismatches. **§the-named-prior-vulnerability-IS-named-explicitly**.

§the-named-historical-vulnerability-IS-the-named-threat-model-driver: the choice of how to handle Windows-mismatched-zip-filenames IS *driven by a named historical attack*.

- **§the-named-strike-a-compromise-discipline** (first-explicit-observation):

> "We strike a compromise: the central directory name may vary from the local name exactly and only by different slashes."

**§the-named-strike-a-compromise IS-the-named-design-decision-language**: the doc uses the phrase "We strike a compromise" to introduce the design choice. **§the-named-compromise-IS-named-explicitly-with-its-rationale**.

§the-compromise-IS-bounded-with-named-tolerance: only-different-slashes vary; everything else must match exactly. §the-narrow-tolerance-IS-the-named-balance.

§the-named-implementation:

```javascript
if (centralName.replace(/\\/g, '/') !== localName) {
  throw Error(`Zip integrity error: ...`);
}
```

§the-named-normalize-then-compare shape: backslash-to-forward-slash on central, then exact-compare with local.

- **§the-`MAX_VALUE_16BITS` + `MAX_VALUE_32BITS`-named-constants** (first-explicit-observation):

```javascript
const MAX_VALUE_16BITS = 65535;
const MAX_VALUE_32BITS = 4294967295;
```

**§two-named-format-limit-constants** with explicit decimal values (not `0xFFFF` and `0xFFFFFFFF`). §the-named-decimal-IS-the-named-explicit-value (sibling to but inverse of cycle 286's hex `0xedb88320` which IS the named bit-pattern).

§the-named-`16BITS`-and-`32BITS`-suffix IS the named bit-width. §the-name-IS-the-purpose-not-the-shape.

- **§the-`textDecoder = new TextDecoder()` module-scope-singleton** (cycle 294 observation reaffirmed; **§two-cycles-with-named-module-scope-Text-Encoder-Decoder-singletons**: 294 encoder + 296 decoder).

§the-named-encoder-decoder-pair-in-symmetric-cluster-files.

- **§the-named-locale-warning-comment** (first-explicit-observation):

```javascript
// Warning: the encoding depends of the system locale.
// On a Linux machine with LANG=en_US.utf8, this field is utf8 encoded.
// On a Windows machine, this field is encoded with the localized Windows
// code page.
```

**§the-named-locale-dependent-encoding-IS-named-as-warning**: the zip comment field's encoding depends on the *machine that created the archive*. **§the-named-cross-platform-encoding-ambiguity**. The reader uses `TextDecoder` (which defaults to UTF-8) — so non-UTF-8 archives (Windows-locale-created) may decode incorrectly.

§the-comment-IS-the-named-known-limitation: the code IS *not yet handling* the Windows-codepage case, but the comment *acknowledges* it. §the-named-acknowledged-but-not-yet-solved-limitation.

- **§the-named-internal-`check(value, message)`-closure-helper** (first-explicit-observation):

```javascript
function checkRecords(centralRecord, localRecord, archiveName) {
  // ...
  function check(value, message) {
    if (!value) {
      throw Error(
        `Zip integrity error: ${message} for file ${q(localName)} in archive ${q(archiveName)}`,
      );
    }
  }
  // ... uses check() six times ...
}
```

**§the-named-closure-helper-IS-the-named-pattern-for-context-rich-error-messages**: `check` closes over `localName` and `archiveName`, so each call doesn't have to repeat them. **§the-named-context-closure-IS-the-named-DRY-discipline**.

§the-named-helper-IS-internal-not-exported: the `check` function lives inside `checkRecords` and is invisible outside. §the-named-helper-IS-scope-bounded-by-purpose.

- **§six-named-integrity-checks** (first-explicit-observation): the `checkRecords` function performs six named checks between central and local records:

1. **bitFlag**
2. **compressionMethod**
3. **crc32**
4. **compressedLength**
5. **uncompressedLength**
6. **content-checksum** (recomputed crc32 over the actual bytes)

**§the-named-six-fold-integrity-discipline**: each field IS independently checked + the content IS independently re-checksummed. **§the-named-cross-record-consistency-check**.

§the-recomputed-content-crc32-IS-the-named-belt-and-suspenders-discipline: even if the central and local CRCs match each other, the actual content might mismatch both. The recompute catches that.

- **§the-`isEncrypted(bitFlag)`-named-helper** + the-rejection (first-explicit-observation):

```javascript
function isEncrypted(bitFlag) {
  return (bitFlag & 0x0001) === 0x0001;
}
// ...
if (isEncrypted(centralRecord.bitFlag)) {
  throw Error('Encrypted zip are not supported');
}
```

**§the-named-feature-detection-via-bit-flag**: bit 0 of the bitFlag field IS the "encrypted" indicator. **§the-named-bit-0-IS-the-encryption-flag**.

§the-named-rejection-of-encrypted-zip: SES doesn't have the crypto needed to decrypt arbitrary zip encryption. §the-named-feature-rejection-via-explicit-check.

- **§the-named-directory-entry-bit** (first-explicit-observation):

```javascript
const isDir = (centralRecord.externalFileAttributes & 0x0010) !== 0;
if (!isDir) {
  // ... process the file ...
}
// TODO handle explicit directory entries
```

**§the-named-DOS-directory-attribute-bit (0x0010)**: bit 4 of the external file attributes IS the DOS directory marker. §the-named-attribute-bit-extraction (sibling to cycle 294's `((mode & 0o777) | 0o100000) << 16` writer-side).

§the-named-incomplete-directory-support: TODO at the bottom — directories IS detected but skipped.

- **§the-`max-lines: ["off"]`-second-eslint-rule** (first-explicit-observation): line 2 has `/* eslint no-bitwise: ["off"], max-lines: ["off"] */`. The `max-lines` rule (cycle 295's §the-named-code-quality-metrics observed it set to 300) IS *disabled* in this file because the file IS 479 lines.

**§the-named-eslint-disable-of-the-named-code-quality-rule**: the file IS *explicitly opting out* of the project's max-lines-per-module discipline. **§three-cycles-with-named-eslint-disable-as-acknowledged-exception** (245 + 254 + 276 + 278 + 286 + 296). 

§the-named-acknowledged-violation: the comment IS the named acknowledgment that the file exceeds the project standard. §the-named-deliberate-deviation-from-the-project-style.

- **§the-named-`@import` declarations at the top** (first-explicit-observation): the file uses the canonical `@import` JSDoc directive (per project CLAUDE.md preference):

```javascript
/**
 * @import {ArchiveHeaders} from './types.js'
 * @import {CompressedFile} from './types.js'
 * @import {UncompressedFile} from './types.js'
 * @import {ArchivedFile} from './types.js'
 */
```

**§four-named-`@import`-declarations-for-four-imported-typedefs**. §the-named-canonical-`@import`-form (cycle 284 noted reader.js DID NOT use this; cycle 296 confirms format-reader.js DOES). **§the-cluster-uses-both-`@import`-and-inline-`import(...)`-forms**.

§two-named-imports-styles-in-the-zip-cluster: cycle 284's reader.js (inline `import('./types.js').X`) vs cycle 296's format-reader.js (`@import {X} from './types.js'`). §the-same-typedef-referenced-via-two-named-shapes-in-the-same-cluster.

- **§the-`import './types.js'` (without binding)** (first-explicit-observation): line 49 imports `./types.js` for side effect only (since types.js is the §`export {};`-typedef-only file from cycle 282). **§the-named-side-effect-import-of-a-typedef-only-file**.

§the-named-import-for-its-typedef-side-effect: the `@import` directives reference types from this module, so the runtime import IS needed for module-system-level coherence (even though no runtime values flow).

- **§the-named-three-typedef-block-at-the-top** reaffirmed (cycle 294 observation; **§two-cycles-with-the-named-typedef-block-at-the-top in the zip cluster**: 294 + 296). Cycle 296's block has FOUR typedefs (CentralFileRecord + LocalFileRecord + CentralDirectoryLocator + BufferReader) — one more than cycle 294's three.

§the-named-four-typedef-block (CentralFileRecord + LocalFileRecord + CentralDirectoryLocator + BufferReader). **§the-named-block-IS-richer-in-the-reader-than-the-writer**.

- **§the-`reader.findLast` IS-the-spec-prescribed-method comment** (first-explicit-observation): the code names the *spec-prescribed* method (`findLast`) before rejecting it. **§the-named-comparison-to-the-spec-shape**: the comment IS not just "we don't use this"; it IS "here IS what the spec says, here IS why we don't".

§the-named-spec-aware-rejection: the comment cites the spec's prescription AND the reason for deviating.
