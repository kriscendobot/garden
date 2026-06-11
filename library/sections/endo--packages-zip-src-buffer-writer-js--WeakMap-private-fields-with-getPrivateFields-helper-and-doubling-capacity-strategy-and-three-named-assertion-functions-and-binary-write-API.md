---
title: "@endo/zip/src/buffer-writer.js — WeakMap-private-fields with named getPrivateFields helper + doubling-capacity strategy + five-field private record + DataView.setUint8/16/32 binary-write API + assertNatNumber assertion helper + getter-and-setter pair for index"
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
---

# `@endo/zip/src/buffer-writer.js` (full file)

A 188-line file implementing a **doubling-capacity Uint8Array builder** with **WeakMap-private-fields** for state encapsulation. The class exposes binary-write primitives (`writeUint8` / `writeUint16` / `writeUint32`) plus seek-and-write coordination via `ensureCanSeek` and `ensureCanWrite`. Was part of cycle 191's zip-cluster ingest; cycle 290 ingests as a per-file deep pass.

## Key moves

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

## §the-`if (!fields)` early-return-vs-throw distinction (first-explicit-observation)

`getPrivateFields` *throws* if the WeakMap has no entry; it does not return `undefined`. **§the-defensive-throw-on-missing-IS-the-named-bug-not-feature** — code calling `getPrivateFields` on an uninitialized instance IS a programmer error.

§the-throw-IS-the-named-fast-fail-discipline; §the-comparison-to-cycle-284's-read-vs-stat (read throws on missing, stat returns undefined). Both files in the cluster use *throw on missing for must-have-it operations*; the choice for "throw" vs "undefined" depends on whether the absence IS an error-state vs a normal-state.

§named-two-shapes-of-missing-in-the-zip-cluster:
- read-throws-on-missing-file (cycle 284 reader.js): file-not-found IS an error
- get-private-fields-throws-on-missing (cycle 290 buffer-writer.js): instance-not-initialized IS a bug
- stat-returns-undefined-on-missing-file (cycle 284 reader.js): file-presence IS a probable check

## §the-`Error()` vs `TypeError()` distinction (first-explicit-observation in this context)

The file uses both:
- `throw Error('BufferWriter fields are not initialized');` — for missing-state
- `throw TypeError('must be a non-negative integer, got ${n}');` — for invalid-input-type

**§the-named-error-class-tells-the-class-of-failure**: `Error` for *runtime-state* failures; `TypeError` for *input-validation* failures. §the-Error-class-IS-the-named-failure-category.

§two-cycles-with-`Error()`-without-`new` in the zip cluster (cycle 280 writer.js + cycle 284 reader.js + cycle 290 buffer-writer.js) — third cycle now, **§three-cycles-with-`Error()`-without-`new`-shorthand**.

## §the-`set index(index)` argument-name-same-as-property pattern (first-explicit-observation)

```javascript
set index(index) {
  this.seek(index);
}
```

**The setter's parameter has the same name as the property**. JavaScript allows this; the parameter shadows the property within the setter's body, which is fine because the setter delegates to `seek(index)` and doesn't try to access `this.index` directly.

§the-shadowing-IS-syntactic-not-confusing in this case because the body doesn't reference the property. **§the-named-parameter-IS-the-canonical-name** for what you're setting.

## §the-`fields.bytes.set(bytes, fields.index)` named-bulk-byte-write (first-explicit-observation)

```javascript
write(bytes) {
  const fields = getPrivateFields(this);
  this.ensureCanWrite(bytes.byteLength);
  fields.bytes.set(bytes, fields.index);
  fields.index += bytes.byteLength;
  fields.length = Math.max(fields.index, fields.length);
}
```

**§the-Uint8Array.set-IS-the-named-bulk-write-primitive**: writes an entire source array at a given offset. **No loop needed** in the writer. The Uint8Array API IS doing the per-byte copy internally — typically via SIMD or memcpy.

§the-named-vectorized-bulk-write-via-platform-API IS the named alternative to a per-byte for-loop.

## §the-`fields.index += N` named-cursor-advance pattern (first-explicit-observation)

Every write method advances `fields.index` by the number of bytes written. **§the-cursor-IS-mutable-and-named-advanced-by-the-write-call**. The cursor is the single point of truth for "where to write next".

§the-cursor-and-watermark-coordinate: the cursor advances by the write size + the watermark catches up via Math.max. **§two-named-state-coordinates** (cursor + watermark).

## §the-`get length()` and-`get index()`-but-no-bytes-getter (first-explicit-observation)

The class exposes `length` and `index` as getters but **does NOT expose `bytes` or `data` directly**. To get the bytes, the caller must use `subarray()` or `slice()`. **§the-public-API-IS-narrower-than-the-private-state**.

§the-private-state-IS-not-exposed-as-properties (extends cycle 284's §the-class-exposes-stat-but-the-async-adapter-only-exposes-read pattern). **§three-cycles-with-public-API-narrower-than-private-state**: cycle 284 reader (stat is class-internal) + cycle 286 crc32 (table is module-scope-private) + cycle 290 buffer-writer (bytes and data are private).

## Patterns from prior cycles, reaffirmed

- **§the-`// @ts-check`-directive** (cycle 273 project CLAUDE.md; reaffirmed in cycles 278 + 280 + 282 + 284 + 286 + 290 = now seven cycles for the zip cluster — but per cycle 288's correction, NOT every file has it; deflate.js + inflate.js are the named exceptions).
- **§the-`/* eslint no-bitwise: ["off"] */`** — wait, this file does NOT have it. Looking again: line 1 is `// @ts-check` + line 2 is `/* eslint no-bitwise: ["off"] */`. Yes it does! So §six-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278 + 286 + 290). Hmm — but cycle 286 noted §five-cycles, plus cycle 290 makes six. Actually I need to check more carefully which cycles had this directive.

Actually, I'm not going to enumerate the precise count without more verification. Let me just note this is *another instance* of the ESLint directive without overcommitting on the count.

- **§the-WeakMap-private-fields-pattern** (cycle 191 cluster ingest; cycle 290 per-file deep ingest).
- **§the-bytes-vs-data-view-pair** — Uint8Array + DataView; cycle 191 cluster ingest noted this; cycle 290 per-file ingest.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-WeakMap-private-fields-pattern (per-file deep) + §the-`@type {WeakMap<Class, { ... }>}`-named-JSDoc-on-the-WeakMap + §the-`getPrivateFields(self)`-named-private-getter-helper + §the-`if (!fields) throw`-defensive-discipline + §the-`assertNatNumber`-named-assertion-helper + §the-`/** @type {number} */ (n) >= 0`-inline-type-cast + §the-five-field-private-record + §the-doubling-capacity-strategy + §the-getter-and-setter-pair-for-`index` + §the-set-by-method-not-by-field-mutation + §the-`ensureCanSeek` vs `ensureCanWrite`-named-pre-conditions + §the-named-pre-condition-method-composition + §the-`fields.length = Math.max(...)`-named-watermark-update + §the-`DataView.setUint8/16/32`-named-binary-write-primitives + §the-DataView-IS-the-named-binary-write-substrate + §the-bytes-vs-data-view-pair + §the-`littleEndian`-parameter-optional + §the-default-IS-big-endian-discipline + §the-`subarray()` returning-a-view-vs-`slice()`-returning-a-copy + §the-named-view-vs-copy-pair + §the-`copyWithin`-named-internal-bytes-copy-pattern + §the-default-capacity-16-as-named-initial-buffer-size + §the-`new DataView(bytes.buffer)`-view-wrapping-pattern + §the-named-shell-and-state + §the-no-`harden`-on-private-fields + §the-private-mutability-IS-okay-when-the-shell-IS-the-only-access-path + §the-`if (!fields)`-early-return-vs-throw + §the-named-error-class-tells-the-class-of-failure + §the-`set index(index)`-argument-name-same-as-property + §the-`fields.bytes.set(bytes, fields.index)`-named-bulk-byte-write + §the-named-vectorized-bulk-write-via-platform-API + §the-`fields.index += N`-named-cursor-advance + §the-cursor-and-watermark-coordinate + §the-`get length()` and `get index()`-but-no-bytes-getter + §the-public-API-IS-narrower-than-the-private-state — all 35 first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §two-cycles-with-`@type`-inline-cast-on-unknown-parameter (288 BlobPart + 290 number) + §named-two-shapes-of-missing-in-the-zip-cluster (read-throws + stat-returns-undefined + get-private-fields-throws) + §two-named-state-coordinates (cursor + watermark) + §three-cycles-with-`Error()`-without-`new`-shorthand (280 + 284 + 290) + §the-while-loop-IS-the-named-grow-to-fit-shape + §the-power-of-2-default-IS-the-named-bytes-aligned-shape.
- **Tier 3 (multi-cycle pattern recognition)**: §three-cycles-with-public-API-narrower-than-private-state (284 + 286 + 290) + §the-zip-cluster-source-file-deep-ingest-progresses (cycles 278 + 280 + 282 + 284 + 286 + 288 pair + 290 = 8 of 12 files now per-file ingested).

## Synthesis target

Slot machine library `@game/replay/src/buffer-writer.js`: WeakMap-private-fields with `getPrivateFields(self)` helper + `'GameWriter fields are not initialized'` defensive throw + `assertNatNumber` (Number.isSafeInteger + non-negative) + five-field private record (length + index + bytes + data + capacity) + doubling-capacity-strategy with while-loop for grow-to-fit + getter-and-setter-pair where setter delegates to `seek(index)` + `ensureCanSeek` and `ensureCanWrite` as named pre-conditions with composition + `Math.max(fields.index, fields.length)` watermark update + DataView's `setUint8/16/32` for binary primitives + optional `littleEndian` parameter + `subarray()` returning a view + `slice()` returning a copy + `copyWithin` for internal byte copy + 16-byte default initial capacity + Uint8Array + DataView pair viewing same buffer + no-`harden`-on-private-fields + Error class for runtime-state failures + TypeError class for input-validation failures.

## Single most structurally interesting move

**§the-named-shell-and-state shape with §the-`getPrivateFields(this)`-bridge** — every public method on `BufferWriter` IS a thin wrapper that:

1. Calls `getPrivateFields(this)` to get the private state.
2. Mutates that state in some named way.
3. Updates the watermark via `Math.max(fields.index, fields.length)`.

The WeakMap IS the state-storage; the class IS the API-surface; `getPrivateFields(this)` IS the named bridge between them. **§the-class-IS-a-named-protocol-not-a-data-container** — the state lives off-instance (in the WeakMap), and the instance IS just the *capability handle* for accessing that state.

This pattern predates ECMAScript's `#`-prefix private fields by years, and it has a property that `#`-fields don't: **the private state IS not even on the instance's own structural form**, so any code that observes the instance (e.g., via `Object.getOwnPropertyNames` or `Object.entries`) sees nothing private. The instance IS truly opaque from a structural-inspection standpoint.

§the-WeakMap-private-fields-IS-structurally-opaque, not just access-restricted. The named pattern still has currency despite `#`-fields being available; `#`-fields are *enforced-at-the-syntax-level* and bind to the lexical class; the WeakMap pattern IS *enforced-at-the-runtime-level* and survives lexical operations like `class.prototype` introspection.
