---
title: The single most structurally interesting move
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

**§the-named-DataView-and-TypedArray-byte-order-asymmetry** — the file's *top-of-file rationale comment*, two lines long:

```js
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

This is the **implementation-side companion** to cycle 315's README-side **§the-named-32-bit-host-byte-order-discipline**. The README *announces* host byte order as a deliberate consequence of the protocol target (same-host browser-to-native-host communication). The source *implements* it by deliberately passing `hostIsLittleEndian` (a boolean from `./src/host-endian.js`) as DataView's `littleEndian` argument to `data.getUint32(0, hostIsLittleEndian)`. **§the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument** binds the two together — the rationale (cycle 315) and the technique (cycle 316).

Without that argument, `data.getUint32(0)` defaults to *big-endian* (network byte order, the historical default for binary protocols). TypedArrays (`Uint32Array`, `Int32Array`, etc.) use host byte order; DataView uses big-endian by default. The asymmetry — §the-named-two-classes-of-JS-binary-views-with-opposite-default-byte-orders — is a foot-gun that would silently mis-decode if the implementer wasn't aware. The two-line comment at the file top makes the awareness explicit; the `./src/host-endian.js` import is the concrete remedy. §first-explicit-observation in library.
