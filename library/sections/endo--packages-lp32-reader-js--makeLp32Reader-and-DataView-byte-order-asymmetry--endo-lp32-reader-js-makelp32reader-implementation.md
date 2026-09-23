---
title: "`@endo/lp32 reader.js` — makeLp32Reader implementation"
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

The 82-line implementation companion to cycle 315's @endo/lp32 README.md. Cycle 316 is **chat-lane after cycle 315's designs-lane** — README first, source second — a **§the-named-reverse-pair-shape** that contrasts with cycles 310-311 (nat src then nat README) and cycles 312-313 (memoize src then memoize README). **Seventh consecutive non-garden source after the pivot** (cycles 310 + 311 + 312 + 313 + 314 + 315 + 316). **§seven-cycles-with-named-pivot-domain-stay**. **Fourth package** in the pivot cluster (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32) — extends, not adds.
