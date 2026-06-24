---
title: Synthesis-target
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
