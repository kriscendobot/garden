---
title: "@endo/lp32 reader.js — makeLp32Reader implementation; DataView/TypedArray byte-order asymmetry; geometric buffer growth; copy-on-yield"
source-slug: endo--packages-lp32-reader-js
url: https://github.com/endojs/endo/blob/master/packages/lp32/reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/lp32/reader.js
total-lines: 82
ingest-cycle: 316
ingest-date: 2026-06-11
lane: chat
---

# `@endo/lp32 reader.js`

The 82-line implementation companion to cycle 315's @endo/lp32 README.md. **Seventh consecutive non-garden source after the pivot** (cycles 310-316). **§seven-cycles-with-named-pivot-domain-stay**. **§the-named-reverse-pair-shape** — README first (cycle 315), then source (cycle 316) — contrasts with cycles 310-311 (nat src→README) and 312-313 (memoize src→README).

## Key moves

- **§the-named-DataView-and-TypedArray-byte-order-asymmetry** — file-top rationale comment names the asymmetry: DataView defaults to big-endian; TypedArrays use host byte order; an explicit endianness argument bridges them. §the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument (implementation companion to cycle 315's §the-named-32-bit-host-byte-order-discipline).
- **§the-named-two-layer-factory-with-hidden-generator** (private `async function*` + public thin wrapper); §the-named-double-harden-on-factory-and-generator-object (harden the generator object AND the wrapper function).
- **§the-named-three-options-with-numeric-defaults** (`name = '<unknown>'`, `initialCapacity = 1024`, `maxMessageLength = 1024 * 1024`) — the README's named promises now have concrete numeric defaults; §the-named-1MB-default-as-inline-comment.
- **§the-named-Math.max-floor-on-initialCapacity** (`Math.max(4, initialCapacity)`) — defensive minimum of 4 bytes (the protocol prefix size); §the-named-callers-cannot-undercut-the-protocol-prefix-size.
- **§the-named-geometric-buffer-growth** (`while (...) { capacity *= 2; }`) — §the-named-while-not-if-because-one-double-may-be-insufficient.
- **§the-named-DataView-must-be-rebuilt-on-resize** (DataView binding is eager); §the-named-shared-buffer-between-Uint8Array-and-DataView (two views, one ArrayBuffer).
- **§the-named-drain-loop-on-each-arrival** (outer `for await` chunks; inner `while` drain) with §the-named-amortize-multiple-messages-per-arrival.
- **§the-named-Fail-via-q-tagged-template-literal** (@endo/errors canonical idiom); §the-named-message-includes-named-stream-name (the `name` option doubles as error attribution).
- **§the-named-yield-a-copy-not-a-view** — `slice()` (not `subarray()`) with explicit rationale comment `// Must allocate to support concurrent reads.`; §the-named-share-the-buffer-internally-isolate-on-yield.
- **§the-named-copyWithin-for-in-place-shift** — buffer compaction without allocation; §the-named-only-allocate-on-yield-not-on-compaction.
- **§the-named-absolute-offset-only-for-error-context** — `let offset = 0` exists *only* to enrich the error message; §the-named-tracking-variable-only-for-diagnostics.
- **§the-named-trailing-bytes-fail-noisy** — incomplete trailing bytes throw at stream end; §the-named-truncation-IS-named-detected.
- **§the-named-cross-package-type-reference-via-import-string** (`@returns {import('@endo/stream').Reader<Uint8Array, void>}`).
- **§the-named-async-generator-not-arrow-because-generator** (arrows can't be generators).
- **§seven-cycles-with-named-pivot-domain-stay**, **§three-shapes-of-pair-discipline** (regular + reverse + orphan-singleton), **§five-cycles-with-named-Hardened-JS-discipline**, **§three-cycles-with-named-pre-allocation-discipline**.

## Section files

- [§the-named-DataView-and-TypedArray-byte-order-asymmetry + §the-named-two-layer-factory-with-hidden-generator + §the-named-yield-a-copy-not-a-view + §the-named-absolute-offset-only-for-error-context + 20+ more first-explicit-observations](../sections/endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry.md) — full 82-line source in scope.

## Ingest scope

Cycle 316 (chat-lane after cycle 315's designs-lane @endo/lp32 README.md). Full 82-line source in scope. Seventh consecutive @endo/* source; fourth package (same as cycle 315). **First-explicit-observations (twenty-plus)** including §the-named-DataView-and-TypedArray-byte-order-asymmetry, §the-named-two-layer-factory-with-hidden-generator, §the-named-double-harden-on-factory-and-generator-object, §the-named-Math.max-floor-on-initialCapacity, §the-named-geometric-buffer-growth, §the-named-DataView-must-be-rebuilt-on-resize, §the-named-drain-loop-on-each-arrival, §the-named-yield-a-copy-not-a-view, §the-named-copyWithin-for-in-place-shift, §the-named-absolute-offset-only-for-error-context, §the-named-trailing-bytes-fail-noisy, §the-named-cross-package-type-reference-via-import-string, §the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument. Multi-cycle: §seven-cycles-with-named-pivot-domain-stay, §three-shapes-of-pair-discipline (regular 310-311 + 312-313; reverse 315-316; orphan-singleton 314).
