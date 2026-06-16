---
title: Key moves
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
parent: endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry
---

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
