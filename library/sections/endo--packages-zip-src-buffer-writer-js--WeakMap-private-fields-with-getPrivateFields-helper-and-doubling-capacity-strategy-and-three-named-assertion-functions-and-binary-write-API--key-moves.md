---
title: Key moves
section-slug: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
---

- **§the-WeakMap-private-fields-pattern as named ES2015-pre-class-private-fields shape** (first-explicit-observation at per-file scope; noted in cycle 191's cluster ingest):

```javascript
/**
 * @type {WeakMap<BufferWriter, {
 *   length: number,
 *   index: number,
 *   bytes: Uint8Array,
 *   data: DataView,
 *   capacity: number,
 * }>}
 */
const privateFields = new WeakMap();
```

**§the-`@type {WeakMap<Class, { ... }>}` named-JSDoc-on-the-WeakMap** (first-explicit-observation): the JSDoc names the *full shape* of the value stored in the WeakMap. The reader sees the entire private-state shape inline at the WeakMap declaration. §the-private-state-shape-IS-document-by-the-WeakMap-typedef.

- **§the-`getPrivateFields(self)`-named-private-getter-helper** (first-explicit-observation): a module-scoped function that takes the public instance and returns its private fields, throwing if the instance was never registered.

```javascript
const getPrivateFields = self => {
  const fields = privateFields.get(self);
  if (!fields) {
    throw Error('BufferWriter fields are not initialized');
  }
  return fields;
};
```

**§the-`if (!fields) throw` defensive-discipline**: catches *forged-instance* attacks where someone constructs a `BufferWriter`-shaped object without the WeakMap entry. The WeakMap IS the *capability discriminator*.

- **§the-`assertNatNumber` named-assertion-helper-combining-type-and-value-check** (first-explicit-observation):

```javascript
const assertNatNumber = n => {
  if (Number.isSafeInteger(n) && /** @type {number} */ (n) >= 0) {
    return;
  }
  throw TypeError(`must be a non-negative integer, got ${n}`);
};
```

**§the-pattern-IS-`safe-integer + non-negative`-in-one-check**. The `Number.isSafeInteger` covers both "is an integer" and "is in safe range"; the `>= 0` adds the natural-number constraint.

§the-`/** @type {number} */ (n) >= 0` inline-type-cast pattern: `n` is `unknown` at the entrypoint; the cast lets the comparison through TypeScript. §two-cycles-with-`@type`-inline-cast-on-unknown-parameter (cycle 288 BlobPart + cycle 290 number).

- **§the-five-field-private-record** (first-explicit-observation): `{ length, index, bytes, data, capacity }`. **Five named coordinates of the writer's state**: total used length + cursor index + the Uint8Array + the DataView wrapping the same buffer + the allocated capacity. The DataView and Uint8Array view the SAME buffer; both are stored to avoid re-wrapping on every primitive write.

- **§the-doubling-capacity-strategy** (first-explicit-observation): when more space is needed:

```javascript
let capacity = fields.capacity;
while (capacity < required) {
  capacity *= 2;
}
```

**§the-named-amortized-O(1)-append discipline**: doubling on each reallocation gives amortized O(1) per write. Classic dynamic-array idiom; the cluster names it via `ensureCanSeek` and `ensureCanWrite`. §the-`while`-loop-IS-the-named-grow-to-fit shape: not just `capacity * 2` (which might not be enough); a `while` loop *grows until sufficient* in case the required size is far beyond current.

- **§the-getter-and-setter-pair-for-`index`** (first-explicit-observation):

```javascript
get index() {
  return getPrivateFields(this).index;
}
set index(index) {
  this.seek(index);
}
```

**§the-set-by-method-not-by-field-mutation**: setting `writer.index = N` delegates to `writer.seek(N)`. **The getter reveals; the setter dispatches**. §the-setter-IS-a-method-not-a-mutation: keeps the side-effect (capacity grow + length watermark update) in `seek`, not in the setter's body.

§the-getter-and-setter-pair-coordinate IS the named property-as-method-pair pattern.

- **§the-`ensureCanSeek` vs `ensureCanWrite` named-pre-conditions** (first-explicit-observation): **two named pre-condition methods** with one calling the other.

```javascript
ensureCanWrite(size) {
  assertNatNumber(size);
  const fields = getPrivateFields(this);
  this.ensureCanSeek(fields.index + size);
}
```

**§the-named-pre-condition-method-composition shape**: `ensureCanWrite(size)` delegates to `ensureCanSeek(index + size)`. The naming captures *what the caller wants*: "I want to write N bytes from here" vs "I want to seek to position N". The implementation translates the higher-level want into the lower-level capacity check.

- **§the-`fields.length = Math.max(fields.index, fields.length)` named-watermark-update** (first-explicit-observation): every write updates the length high-water-mark. **§the-watermark-IS-the-named-grow-only-state**. Multiple writes to lower indices don't shrink the watermark; only writes that *extend* the watermark update it.

§the-Math.max-watermark IS sibling-pattern to many buffer-builder idioms; named here as the discipline for tracking written-vs-allocated.

- **§the-`DataView.setUint8/16/32`-named-binary-write-primitives** (first-explicit-observation): three named methods on the DataView, each writing N bytes at the current index:

```javascript
fields.data.setUint8(fields.index, value);     // 1 byte
fields.data.setUint16(index, value, littleEndian);  // 2 bytes
fields.data.setUint32(index, value, littleEndian);  // 4 bytes
```

**§the-DataView-IS-the-named-binary-write-substrate**. The Uint8Array IS for bulk-byte-set; the DataView IS for typed-numeric-write. **§the-bytes-vs-data-view-pair** — Uint8Array view + DataView view of the same underlying buffer; both stored as private fields so neither has to be re-created per call.

- **§the-`littleEndian` parameter as optional, named for binary format clarity** (first-explicit-observation): `writeUint16(value, littleEndian)` lets the caller specify endianness. **§the-littleEndian-IS-the-named-binary-format-discriminator**. The default (`undefined`, which the DataView treats as big-endian) IS the named *default-IS-big-endian-discipline*.

§the-named-optional-parameter-IS-the-format-flexibility-hook: the writer doesn't fix one endianness; it lets the call site choose. ZIP format uses little-endian, so most calls will pass `true`.

- **§the-`subarray()` returning a view vs `slice()` returning a copy** (first-explicit-observation):

```javascript
subarray(begin, end) {
  const fields = getPrivateFields(this);
  return fields.bytes.subarray(0, fields.length).subarray(begin, end);
}
slice(begin, end) {
  return this.subarray(begin, end).slice();
}
```

**§the-named-view-vs-copy-pair**: `subarray` returns a **view** into the writer's internal bytes (cheap, but shares memory); `slice` returns a **copy** (expensive, but independent). The naming follows Uint8Array's own convention. §the-view-and-copy-pair-IS-named-explicitly: the caller chooses based on whether they need an independent buffer.

§the-double-subarray-call-pattern: `bytes.subarray(0, length).subarray(begin, end)` — first restricts to the *used* range, then applies the caller's range. **§the-two-step-restriction-IS-the-named-defensive-slicing**.

- **§the-`copyWithin` named-internal-bytes-copy pattern** (first-explicit-observation):

```javascript
writeCopy(start, end) {
  assertNatNumber(start);
  assertNatNumber(end);
  const fields = getPrivateFields(this);
  const size = end - start;
  this.ensureCanWrite(size);
  fields.bytes.copyWithin(fields.index, start, end);
  // ...
}
```

**§the-named-intra-buffer-copy via Uint8Array.copyWithin** — copy bytes from one range to another *within the same buffer*. Useful for zip-format-specific operations that re-use prior bytes (e.g., DEFLATE back-references, though `compression.js`'s STORE=0 doesn't use this).

- **§the-default-capacity-16-as-named-initial-buffer-size** (first-explicit-observation): `constructor(capacity = 16)` — the writer starts with a 16-byte buffer by default. §the-small-default-IS-the-named-no-waste-discipline: assume small until proven otherwise; doubling absorbs growth.

§the-power-of-2-default-IS-the-named-bytes-aligned-shape: 16 IS a power of 2, aligning with the doubling strategy.

- **§the-`new DataView(bytes.buffer)` view-wrapping pattern** (first-explicit-observation): both views point at the same underlying `ArrayBuffer`. **§the-two-views-share-the-buffer + the-state-IS-coherent-across-both-views**. Writing via DataView's `setUint8` and reading via Uint8Array indexing both see the same byte.

§the-named-view-coherence-discipline.

- **§the-class-method-IS-a-thin-wrapper-around-private-fields** (first-explicit-observation): every method (except getters) starts with `const fields = getPrivateFields(this);`. **The-method-body-IS-mostly-private-field-mutation + the-public-API-IS-the-protected-shell**.

§the-named-shell-and-state shape: public methods are the *shell*; the WeakMap entry IS the *state*; `getPrivateFields(this)` IS the *bridge*.

- **§the-no-`harden`-on-private-fields** (first-explicit-observation): the WeakMap holds plain mutable JS objects, not frozen or hardened. **The state IS mutable by design** (the writer needs to grow + the watermark needs to advance); the WeakMap's privacy IS what protects against external mutation.

§the-private-mutability-IS-okay-when-the-shell-IS-the-only-access-path. Compare cycle 286's `return table;` mutable-without-harden — same principle: privacy IS what protects, not freezing.
