---
title: "@endo/lp32 reader.js — makeLp32Reader implementation; DataView/TypedArray byte-order asymmetry; geometric buffer growth; copy-on-yield for concurrent reads"
source: endo--packages-lp32-reader-js
url: https://github.com/endojs/endo/blob/master/packages/lp32/reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/lp32/reader.js
line-range: 1-82
ingest-cycle: 316
ingest-date: 2026-06-11
lane: chat
section-tags:
  - the-named-DataView-and-TypedArray-byte-order-asymmetry
  - the-named-two-layer-factory-with-hidden-generator
  - the-named-double-harden-on-factory-and-generator-object
  - the-named-geometric-buffer-growth
  - the-named-DataView-must-be-rebuilt-on-resize
  - the-named-drain-loop-on-each-arrival
  - the-named-yield-a-copy-not-a-view
  - the-named-copyWithin-for-in-place-shift
  - the-named-Math.max-floor-on-initialCapacity
  - the-named-absolute-offset-only-for-error-context
  - the-named-Fail-via-q-tagged-template-literal
  - the-named-cross-package-type-reference-via-import-string
  - the-named-async-generator-not-arrow-because-generator
  - the-named-trailing-bytes-fail-noisy
  - the-named-1MB-default-as-inline-comment
  - the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument
  - seven-cycles-with-named-pivot-domain-stay
  - the-named-reverse-pair-shape
  - three-shapes-of-pair-discipline
  - five-cycles-with-named-Hardened-JS-discipline
  - three-cycles-with-named-pre-allocation-discipline
---

# `@endo/lp32 reader.js` — makeLp32Reader implementation

The 82-line implementation companion to cycle 315's @endo/lp32 README.md. Cycle 316 is **chat-lane after cycle 315's designs-lane** — README first, source second — a **§the-named-reverse-pair-shape** that contrasts with cycles 310-311 (nat src then nat README) and cycles 312-313 (memoize src then memoize README). **Seventh consecutive non-garden source after the pivot** (cycles 310 + 311 + 312 + 313 + 314 + 315 + 316). **§seven-cycles-with-named-pivot-domain-stay**. **Fourth package** in the pivot cluster (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32) — extends, not adds.

## The single most structurally interesting move

**§the-named-DataView-and-TypedArray-byte-order-asymmetry** — the file's *top-of-file rationale comment*, two lines long:

```js
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

This is the **implementation-side companion** to cycle 315's README-side **§the-named-32-bit-host-byte-order-discipline**. The README *announces* host byte order as a deliberate consequence of the protocol target (same-host browser-to-native-host communication). The source *implements* it by deliberately passing `hostIsLittleEndian` (a boolean from `./src/host-endian.js`) as DataView's `littleEndian` argument to `data.getUint32(0, hostIsLittleEndian)`. **§the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument** binds the two together — the rationale (cycle 315) and the technique (cycle 316).

Without that argument, `data.getUint32(0)` defaults to *big-endian* (network byte order, the historical default for binary protocols). TypedArrays (`Uint32Array`, `Int32Array`, etc.) use host byte order; DataView uses big-endian by default. The asymmetry — §the-named-two-classes-of-JS-binary-views-with-opposite-default-byte-orders — is a foot-gun that would silently mis-decode if the implementer wasn't aware. The two-line comment at the file top makes the awareness explicit; the `./src/host-endian.js` import is the concrete remedy. §first-explicit-observation in library.

## Key moves

- **§the-named-two-layer-factory-with-hidden-generator** — `makeLp32Iterator` is a private `async function*` (async generator); `makeLp32Reader` is the public thin wrapper that calls it and hardens both layers. §the-named-private-generator-and-public-factory-pair; §the-named-thin-wrapper-exposes-harden; §the-named-async-generator-not-arrow-because-generator (arrow functions can't be generators); §the-named-private-generator-still-hardened (line 70: `harden(makeLp32Iterator)` despite the private status).

- **§the-named-double-harden-on-factory-and-generator-object** — `harden(makeLp32Iterator(reader, options))` hardens the *generator object* returned by invoking the generator function; `harden(makeLp32Reader)` then hardens the wrapper function itself. Both the produced object and the function that produces it are hardened. §the-named-harden-the-result-and-harden-the-producer.

- **§the-named-three-options-with-numeric-defaults** — `name = '<unknown>'`, `initialCapacity = 1024`, `maxMessageLength = 1024 * 1024` (with inline `// 1MB` comment). The README's named three Reader options now have concrete numeric defaults visible in source. §the-named-1MB-default-as-inline-comment; §the-named-name-default-IS-named-unknown-bracketed-placeholder; §the-named-1024-byte-initial-capacity-default.

- **§the-named-Math.max-floor-on-initialCapacity** — `let capacity = Math.max(4, initialCapacity);` — defensive minimum of 4 bytes (the length prefix itself). §the-named-defensive-minimum-floor; §the-named-clamp-to-protocol-minimum; §the-named-callers-cannot-undercut-the-protocol-prefix-size.

- **§the-named-geometric-buffer-growth** — `while (length + chunk.byteLength >= capacity) { capacity *= 2; }` — doubles capacity until it fits the chunk. §the-named-double-when-full-discipline; §the-named-geometric-growth-amortization; §the-named-while-not-if-because-one-double-may-be-insufficient (a single chunk could exceed twice the current capacity, so the loop is required, not optional).

- **§the-named-DataView-must-be-rebuilt-on-resize** — after allocating the replacement `Uint8Array`, the code does `data = new DataView(array8.buffer);` because DataView is bound to its underlying ArrayBuffer at construction; the old DataView still points at the old buffer. §the-named-DataView-binding-IS-named-eager; §the-named-rebind-on-buffer-replacement-discipline.

- **§the-named-shared-buffer-between-Uint8Array-and-DataView** — `new DataView(array8.buffer)` — two views over the *same* underlying ArrayBuffer; Uint8Array for `.set` / `.slice` / `.copyWithin` byte operations, DataView for the typed `getUint32` read with explicit endianness. §the-named-two-views-one-buffer; §the-named-buffer-as-shared-substrate; §the-named-typed-view-for-typed-read-untyped-view-for-byte-copy.

- **§the-named-drain-loop-on-each-arrival** — outer `for await (const chunk of reader)` drives chunks in; inner `while (!drained && length >= 4) { ... }` drains as many complete messages as the buffer holds *each time a chunk arrives*. §the-named-pull-drain-pattern; §the-named-amortize-multiple-messages-per-arrival; §the-named-length-greater-than-or-equal-to-4-IS-named-prefix-fits.

- **§the-named-Fail-via-q-tagged-template-literal** — `messageLength <= maxMessageLength || Fail\`Messages on ${q(name)} must not exceed ${q(maxMessageLength)} bytes in length\`;` — the canonical @endo/errors idiom (Fail-or-throw via short-circuit logical-OR; `q()` quotes values for safe interpolation; tagged template for structured error data). §the-named-short-circuit-Fail-discipline; §the-named-q-for-value-quoting; §the-named-tagged-template-as-error-shape; §the-named-message-includes-named-stream-name (the `name` option doubles as error-message attribution, fulfilling the README's named promise).

- **§the-named-yield-a-copy-not-a-view** — `yield array8.slice(4, envelopeLength);` *with explicit rationale*: `// Must allocate to support concurrent reads.` — `slice()` allocates a new buffer; `subarray()` would share the buffer and mutate underneath the consumer if the next chunk arrives. §the-named-slice-not-subarray-for-isolation; §the-named-allocate-on-yield-discipline; §the-named-share-the-buffer-internally-isolate-on-yield; §first-explicit-observation in library.

- **§the-named-copyWithin-for-in-place-shift** — `array8.copyWithin(0, envelopeLength);` — shifts the rest of the buffer down by `envelopeLength` bytes in place. §the-named-copyWithin-for-in-place-shift; §the-named-no-new-allocation-on-buffer-compaction; §the-named-buffer-recycled-not-replaced; §the-named-only-allocate-on-yield-not-on-compaction (paired with the yield-a-copy discipline: copies happen on yield, not on internal buffer maintenance).

- **§the-named-absolute-offset-only-for-error-context** — `let offset = 0;` is incremented but *never read except in the error message* `at offset ${offset} of ${name}`. §the-named-tracking-variable-only-for-diagnostics; §the-named-error-message-pays-for-the-tracking; §the-named-named-stream-cursor-IS-named-debug-aid; §first-explicit-observation in library.

- **§the-named-trailing-bytes-fail-noisy** — `if (length > 0) { throw Error(\`Unexpected dangling message of length ${length} at offset ${offset} of ${name}\`); }` — when the underlying stream ends with bytes still in the buffer that don't form a complete message, the iterator throws rather than silently ending. §the-named-fail-loud-on-incomplete-trailing-bytes; §the-named-stream-ends-cleanly-only-on-message-boundary; §the-named-truncation-IS-named-detected.

- **§the-named-cross-package-type-reference-via-import-string** — `@returns {import('@endo/stream').Reader<Uint8Array, void>}` — JSDoc reference to a type from another package via `import('...')` string. §the-named-JSDoc-cross-package-type; §the-named-type-from-stream-package; §the-named-Reader-IS-named-stream-package-protocol-shape; §the-named-Uint8Array-and-void-IS-named-payload-and-return-type-parameters.

## Patterns the cycle extends

- **§seven-cycles-with-named-pivot-domain-stay** (310 + 311 + 312 + 313 + 314 + 315 + 316) — pivot is now seven cycles old; still adding twenty-plus first-explicit-observations per cycle.

- **§the-named-reverse-pair-shape** (cycle 315 README → cycle 316 source) — contrasts with §the-named-regular-pair-shape (cycles 310 nat src → 311 nat README; cycles 312 memoize src → 313 memoize README). The pair *exists* in both shapes; the order of arrival differs. §three-shapes-of-pair-discipline:
  - §the-named-regular-pair-shape: source first then README (310-311 nat, 312-313 memoize)
  - §the-named-reverse-pair-shape: README first then source (315-316 lp32)
  - §the-named-orphan-singleton-shape: source without companion within the cluster window (314 hex source; hex README still pending)

- **§five-cycles-with-named-Hardened-JS-discipline** (310 freeze-stand-in + 312 harden-import + 313 Hardened-JS-target + 315 dependency-on-Hardened-JS + 316 double-harden) — the discipline shows up in five of seven pivot cycles; the two that don't (311 nat README, 314 hex source) still operate under the Hardened-JS umbrella but don't surface it in code or prose directly.

- **§three-cycles-with-named-pre-allocation-discipline** (314 chars array + 315 reader buffer named in README + 316 reader buffer implemented). Cycle 316 makes the named bound concrete — `let array8 = new Uint8Array(capacity);` with `capacity = Math.max(4, initialCapacity);`.

- **§seven-cycles-with-named-harden-call-on-exports** — every source-side cycle in the pivot calls `harden()` on its exports; cycle 316 calls it twice (private generator + public wrapper). §the-named-harden-call-IS-named-canonical-export-shape.

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags above marked §first-explicit-observation or new this cycle. The DataView/TypedArray asymmetry is the structural highlight; the yield-a-copy-not-a-view discipline (with its explicit "concurrent reads" rationale) is the most directly portable; the absolute-offset-only-for-error-context is the most quietly clever (a tracking variable paid for entirely by diagnostics).

## Tier-2 borrowing (multi-cycle patterns extended)

- §seven-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315 + 316)
- §three-shapes-of-pair-discipline (regular + reverse + orphan-singleton)
- §five-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316)
- §three-cycles-with-named-pre-allocation-discipline (314 + 315 + 316)
- §seven-cycles-with-named-harden-call-on-exports
- §the-named-source-and-README-cross-reference-IS-named-pair-shape-marker (315 README cited cycle 314's source; 316 source implements cycle 315's named promises)

## Tier-3 borrowing (meta-patterns)

- §the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument — the README's *rationale-named* matches the source's *technique-named*; pattern-pairs across the documentation/implementation boundary
- §the-named-share-the-buffer-internally-isolate-on-yield — internal recycling for efficiency; external isolation for correctness
- §the-named-tracking-variable-only-for-diagnostics — a variable that exists *only* for the error message; "the error message pays for the tracking"
- §the-named-DataView-binding-IS-named-eager — JS-language fact (DataView's ArrayBuffer reference is captured at construction) made load-bearing in the code

## Synthesis-target

Slot machine library **§`@game/streaming/src/reader.js`** — length-prefixed message stream reader between processes (e.g., game-server-to-renderer):

1. Top-of-file rationale comment naming any JS-language asymmetry the implementation relies on (DataView/TypedArray default-byte-order asymmetry, for instance).
2. Two-layer factory: private `async function*` generator + public thin-wrapper factory; harden both.
3. Three named options with numeric defaults visible in destructuring (`name`, `initialCapacity`, `maxMessageLength`), the last with an inline unit comment (`// 1MB`).
4. Defensive minimum floor (`Math.max(4, initialCapacity)`) so callers cannot undercut the protocol prefix size.
5. Two views over one ArrayBuffer (Uint8Array for byte ops + DataView for typed-read-with-endianness).
6. Geometric growth with `while`-loop doubling (not `if`-loop) — a single chunk could exceed twice the current capacity.
7. Rebuild DataView on every buffer replacement.
8. Outer `for await` chunk loop, inner `while` drain loop with `length >= prefix-size` guard.
9. `Fail`-via-`q`-tagged-template error idiom with the named stream name interpolated into every diagnostic.
10. `slice()` (not `subarray()`) on yield to support concurrent reads, with the rationale named in comment.
11. `copyWithin` for in-place buffer compaction; no allocation on internal maintenance, only on yield.
12. Absolute-offset tracking variable read *only* by the error message.
13. Trailing-bytes fail-noisy at stream end.
14. JSDoc cross-package type reference via `import('@game/stream').Reader<...>` (if the type's authoritative home is in another package).
