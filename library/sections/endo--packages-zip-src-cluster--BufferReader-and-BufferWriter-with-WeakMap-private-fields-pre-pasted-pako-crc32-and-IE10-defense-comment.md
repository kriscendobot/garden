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
---

# BufferReader and BufferWriter with WeakMap private fields and bound get, pre-pasted pako crc32 with attribution, IE10 defense comment for historical ghost, and STORE-only zip

> §Chat-lane after cycle 190's designs-lane. §The-twenty-
> fifth-consecutive designs/chat alternation cycle (166-191).
> §Cycle-186-break-dev-deps' §Cut-3 (vestigial @endo/zip
> devDeps deleted) made `@endo/zip` a §sink-only leaf
> consumer; §this-cycle-ingests-the-source.

`packages/zip/src/` is a small focused 11-file package
totaling ~1482 lines that implements a §store-only-zip
reader/writer pair. Without `compression.js` (4 lines:
`export const STORE = 0`) and `format-*.js` (the larger
files), the §primitive-substrate is:

| File | Lines | Role |
|------|-------|------|
| `index.js` | 4 | Re-export barrel (ZipReader/readZip/ZipWriter/writeZip) |
| `src/buffer-reader.js` | 274 | Uint8Array+DataView pair with §WeakMap-private-fields |
| `src/buffer-writer.js` | 188 | Doubling-capacity Uint8Array with §ensureCanSeek |
| `src/crc32.js` | 48 | §Pre-pasted-pako with attribution comment |
| `src/signature.js` | 21 | PK\x03\x04 magic numbers + §u-helper |
| `src/compression.js` | 4 | STORE = 0 only |
| `src/reader.js` | 60 | ZipReader class + readZip async wrapper |
| `src/writer.js` | 64 | ZipWriter class + writeZip async wrapper |

§The-single-most-structurally-interesting-move is §WeakMap-
private-fields-with-bound-get + §pre-pasted-pako-crc32-with-
attribution-comment + §IE10-defense-comment-for-historical-
ghost + §store-only-zip-with-named-default. §Four-named-moves
in one byte-format package.

## §WeakMap-private-fields-with-bound-get (buffer-reader.js, the spine)

```js
/** @type {WeakMap<BufferReader, BufferReaderState>} */
const privateFields = new WeakMap();

const privateFieldsGet =
  /** @type {(bufferReader: BufferReader) => BufferReaderState} */ (
    privateFields.get.bind(privateFields)
  );

export class BufferReader {
  constructor(buffer) {
    const bytes = new Uint8Array(buffer);
    const data = new DataView(bytes.buffer);
    privateFields.set(this, {
      bytes,
      data,
      length: bytes.length,
      index: 0,
      offset: 0,
    });
  }
  // ... uses privateFieldsGet(this) throughout
}
```

§The-pattern: module-private WeakMap + pre-bound `.get`
method captured as `privateFieldsGet`. §Every-method-does
`const fields = privateFieldsGet(this)` to access private
state.

§Why-not-`#privateField`-class-syntax: SES-locks-down. §JS-
private-fields use a per-class WeakMap internally; under SES
that mechanism is fine but the §explicit-WeakMap-pattern
predates wide JS-private-field availability and is §still-
the-canonical-Endo-discipline. §Compare-to-cycle-187-shim-
cluster's §postponedHandler-with-interlockP — both are
§module-private-state-with-explicit-mechanism.

§The-§bind-once-at-module-load optimization: `privateFields
.get.bind(privateFields)` produces a function that doesn't
need to look up `.get` on the WeakMap each call. §Compare-to-
cycle-181-base64's §Reflect.apply-captured-at-module-load and
cycle 183-init's §native-bound-at-module-load. §All-three-
are-§module-load-capture-of-primitive-method patterns.

§The-buffer-writer.js variant uses a slightly different shape:

```js
const getPrivateFields = self => {
  const fields = privateFields.get(self);
  if (!fields) {
    throw Error('BufferWriter fields are not initialized');
  }
  return fields;
};
```

§Adds-runtime-check for `undefined` (the writer can be
constructed before private fields are set in some
flows). §The-reader-doesn't-bother because constructor-
order-guarantees fields exist by the time methods run.
§Asymmetric-defense-based-on-construction-invariant.

## §Pre-pasted-pako-crc32-with-attribution-comment (crc32.js, 48 lines)

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

## §IE10-defense-comment-for-historical-ghost (buffer-reader.js)

```js
peek(size) {
  const fields = privateFieldsGet(this);
  // Clamp size.
  size = Math.max(0, Math.min(fields.length - fields.index, size));
  if (size === 0) {
    // in IE10, when using subarray(idx, idx), we get the array [0x00] instead of [].
    return new Uint8Array(0);
  }
  // ...
}
```

§The-§IE10-defense-comment names a §historical-ghost: IE10
(released 2012; killed-by-Microsoft 2016) had a bug where
`Uint8Array.subarray(N, N)` returned `[0x00]` instead of an
empty array.

§The-defense: detect size==0 and return `new Uint8Array(0)`
explicitly.

§Why-the-comment-survives: §the-code-handles-a-platform-that-
no-one-supports-anymore. §A-future-contributor-might-be-
tempted-to-remove-the-special-case ("IE10 is dead"). §The-
comment-prevents-that — it names the platform-bug + the
historical-fix + lets the reader decide.

§Compare-to-cycle-181-base64's §legacy-XS-tier (`globalThis
.Base64.encode` for older Moddable/XS builds). §Both-are-
§historical-ghost-supports kept §with-named-rationale-in-
source. §Cycle-181's-XS-tier is still relevant (some Agoric
chains still run those builds); §cycle-191's-IE10-defense is
arguably stale, but the comment-block is the §audit-trail
that lets the next maintainer decide.

§Tier-1-borrowing: §historical-ghost-defense-with-named-
rationale-in-source. §Don't-silently-remove-defenses-for-
dead-platforms; §name-them-and-let-the-next-reader-decide.

## §STORE-only-zip (the §scope-limitation discipline)

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

## §The-u-helper-for-ASCII-Uint8Array (signature.js)

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

## §The-§Math.max-Math.min-clamp-idiom

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

## §The-finite-state-Buffer Reader (offsets, indexes, lengths)

```js
/**
 * @typedef {object} BufferReaderState
 * @property {Uint8Array} bytes
 * @property {DataView} data
 * @property {number} length
 * @property {number} index
 * @property {number} offset
 */
```

§Five-state-fields: bytes + data + length + index + offset.

§bytes: the underlying Uint8Array.
§data: the DataView over the same buffer (for getUint16/32
endianness).
§length: usable byte count.
§index: current read position (relative to offset).
§offset: base offset within bytes (for sliced readers).

§The-§offset+index-pair lets a parent ZipReader pass a §sub-
window-of-bytes to a sub-parser without copying. §`setter
offset(offset)` updates both `offset` and `length`
atomically: `fields.length = fields.data.byteLength -
fields.offset`.

§Compare-to-cycle-179-lp32's §single-growing-buffer + §`copyWithin(0,
envelopeLength)` shift. §Cycle-179-uses-an-explicit-shift to
free buffer space; §cycle-191-uses-offset-pointer to read
windows-of-a-buffer-without-shifting. §Different-tradeoffs
for §streaming vs §random-access.

§The-`assertCanSeek` / `assertCanRead` pair are §two-flavors-
of-bound-check: absolute (index) + relative (current + offset).
§Both-named-explicitly-with-Error-messages.

## §BufferWriter §doubling-capacity-with-ensureCanSeek

```js
ensureCanSeek(required) {
  assertNatNumber(required);
  const fields = getPrivateFields(this);
  let capacity = fields.capacity;
  while (capacity < required) {
    capacity *= 2;
  }
  const bytes = new Uint8Array(capacity);
  const data = new DataView(bytes.buffer);
  bytes.set(fields.bytes.subarray(0, fields.length));
  fields.bytes = bytes;
  fields.data = data;
  fields.capacity = capacity;
}
```

§Doubling-growth-strategy (sibling to cycle 179-lp32 §single-
growing-buffer with doubling-capacity). §The-§ensureCanSeek
discipline: called before every write to guarantee capacity.

§The-§DataView-rebuild after capacity-change: DataView is
bound to ArrayBuffer; growing the Uint8Array means a new
ArrayBuffer; the DataView must be replaced.

§Compare-to-cycle-179-lp32's §DataView-replaced-when-buffer-
grows comment. §Both-files-name-this-as-a-known-correctness-
hazard. §Cycle-191-zip-just-replaces; cycle-179-lp32 explains
why ("DataViews are bound to ArrayBuffers, not to
Uint8Arrays").

§The-§assertNatNumber check is at the top of every write:

```js
const assertNatNumber = n => {
  if (Number.isSafeInteger(n) && n >= 0) {
    return;
  }
  throw TypeError(`must be a non-negative integer, got ${n}`);
};
```

§Defense-against-NaN-Infinity-negative-fractional. §Number
.isSafeInteger is the canonical check for "a number that's
also a valid integer index."

## §The-`@ts-expect-error missing properties from ArrayBuffer` (reader.js)

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

## §The-`readDosDateTime` (the §legacy-format-quirk)

```js
function readDosDateTime(reader) {
  const dosTime = reader.readUint32(true);
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
}
```

§Six-named-bit-fields extracted from a uint32. §Each-line-
has-a-comment naming what it is. §The-§DOS-date-time-format
is from MS-DOS 1980 ("year offset 1980" + "month 1-12" +
"day 1-31" + "hour 0-23" + "minute 0-59" + "second
×2-second"). §The-`<< 1` on seconds is because §DOS-stored-
seconds-at-2-second-precision (so 30 ticks instead of 60).

§The-`@see` URLs:

```js
 * @see http://www.delorie.com/djgpp/doc/rbinter/it/65/16.html
 * @see http://www.delorie.com/djgpp/doc/rbinter/it/66/16.html
```

§Two-attribution-URLs to the Ralph-Brown-Interrupt-List
documentation. §A-1980s-DOS-spec preserved as `@see`-
references. §Compare-to-cycle-181-base64's §RFC-4648-§3.5-
citation. §Both-attribute-format-specs-via-URL.

§Tier-1-borrowing: §legacy-format-quirk-with-bit-fields-and-
attribution-URL. §When-implementing-a-historical-format,
name-the-bit-fields-inline + cite-the-spec.

## §The-`isEncrypted` bit-flag (zip's encryption awareness)

```js
function isEncrypted(bitFlag) {
  return (bitFlag & 0x0001) === 0x0001;
}
```

§One-bit-check. §Zip-bit-0 is "encrypted." §The-package-
detects-but-doesn't-decrypt: format-reader.js can identify an
encrypted entry and §refuse-it (the package is §STORE-only +
§unencrypted; encryption is an §implicit-non-goal).

## §MAX_VALUE_16BITS + MAX_VALUE_32BITS (the ZIP64 awareness)

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

## §Cohesion notes

- §WeakMap-private-fields-with-bound-get is the §Endo-
  canonical-discipline for module-private state. The bound
  `.get` is §captured-at-module-load (cycle 181/183 sibling).
- §Asymmetric-defense: buffer-reader trusts the constructor
  to initialize fields; buffer-writer checks for `undefined`
  and throws. §Different-construction-invariants justify
  different defenses.
- §Pre-pasted-pako-crc32-with-attribution-comment names the
  source-file + license + URL. §Audit-trail-in-source.
- §IE10-defense-comment-for-historical-ghost names a dead-
  platform's bug + the defensive fix. §Don't-silently-remove-
  defenses-for-dead-platforms; name them and let the next
  reader decide.
- §STORE-only-zip is the §scope-limitation-named-in-tiny-file
  (4 lines: `export const STORE = 0;`).
- §u-helper compresses 4-line Uint8Array-from-string into one
  call. §Six-canonical-zip-signatures use it. §`& 0xff`
  defensive-against-non-ASCII.
- §Math.max-Math.min-clamp-idiom for `[0, max]` bounding.
- §Five-state-BufferReader (bytes + data + length + index +
  offset) with §offset+index-pair for sub-window-without-
  copying.
- §Doubling-capacity-with-ensureCanSeek in BufferWriter;
  §DataView-rebuild after capacity-change.
- §assertNatNumber for §Number.isSafeInteger + non-negative
  check.
- §DOS-date-time-six-bit-fields with §`@see`-URLs to Ralph-
  Brown-Interrupt-List.
- §`isEncrypted` bit-flag detection without decryption
  support (encrypted-entry refused).
- §MAX_VALUE_16BITS + §MAX_VALUE_32BITS for ZIP64 awareness;
  §read-tolerant-write-strict (read ZIP64, write classic).
- §`@ts-expect-error` for ArrayBuffer-vs-Uint8Array type-
  surface mismatch.
- §Fourteenth-member-of-§small-files-with-large-knowledge-
  density family if measured by §discipline-density-per-line.
- §Cycle-186-Cut-3-target (vestigial @endo/zip devDeps were
  deleted). The zip package is the §simplest-leaf in cycle
  186's SCC-break analysis.

## §Tier-1 borrowing

- §WeakMap-private-fields-with-bound-get (alternative to
  class `#private` for SES compatibility)
- §pre-pasted-pako-with-attribution-comment (audit-trail-in-
  source for borrowed code)
- §historical-ghost-defense-with-named-rationale-in-source
  (don't silently remove defenses for dead platforms)
- §scope-limitation-named-in-tiny-file (a four-line file as
  the canonical location of a decision)
- §u-helper-for-ASCII-to-Uint8Array compresses construction
- §`@see`-URL attribution for legacy-format-specs
- §asymmetric-defense-based-on-construction-invariant
- §five-state-BufferReader with §offset+index-pair for
  sub-window-without-copying
- §doubling-capacity-with-DataView-rebuild (sibling to cycle
  179-lp32)
- §read-tolerant-write-strict (Postel's law applied to
  ZIP64)
- §`@ts-expect-error` with named reason (sibling to cycles
  146/181/188/189)

## §Synthesis-target

The §slot-machine-library's binary-format-parser (if any)
can §borrow-the-five-state-BufferReader directly. §The-
§pre-pasted-with-attribution-comment pattern is borrowable
for any §reference-implementation copied from upstream.

§The-§historical-ghost-defense pattern is borrowable for any
§defense-against-dead-platform-bug — name the platform, name
the bug, name the fix, and let the future maintainer decide
whether to remove it.

§The-§scope-limitation-named-in-tiny-file pattern (the four-
line `compression.js` with `STORE = 0`) is borrowable for
any §package-with-explicit-non-goals: a tiny file whose
canonical name is referenced from elsewhere.
