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
kind: index
section_count: 8
---

Sections:

- [`@endo/lp32 reader.js` — makeLp32Reader implementation](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--endo-lp32-reader-js-makelp32reader-implementation.md)
- [The single most structurally interesting move](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--the-single-most-structurally-interesting-move.md)
- [Key moves](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--key-moves.md)
- [Patterns the cycle extends](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--patterns-the-cycle-extends.md)
- [Tier-1 borrowing (twenty-plus first-explicit-observations)](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--tier-1-borrowing-twenty-plus-first-explicit-observations.md)
- [Tier-2 borrowing (multi-cycle patterns extended)](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--tier-2-borrowing-multi-cycle-patterns-extended.md)
- [Tier-3 borrowing (meta-patterns)](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--tier-3-borrowing-meta-patterns.md)
- [Synthesis-target](endo--packages-lp32-reader-js--makeLp32Reader-and-DataView-byte-order-asymmetry--synthesis-target.md)
