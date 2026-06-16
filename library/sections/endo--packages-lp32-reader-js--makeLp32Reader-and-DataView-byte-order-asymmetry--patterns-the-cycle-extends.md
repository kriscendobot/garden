---
title: Patterns the cycle extends
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

- **§seven-cycles-with-named-pivot-domain-stay** (310 + 311 + 312 + 313 + 314 + 315 + 316) — pivot is now seven cycles old; still adding twenty-plus first-explicit-observations per cycle.

- **§the-named-reverse-pair-shape** (cycle 315 README → cycle 316 source) — contrasts with §the-named-regular-pair-shape (cycles 310 nat src → 311 nat README; cycles 312 memoize src → 313 memoize README). The pair *exists* in both shapes; the order of arrival differs. §three-shapes-of-pair-discipline:
  - §the-named-regular-pair-shape: source first then README (310-311 nat, 312-313 memoize)
  - §the-named-reverse-pair-shape: README first then source (315-316 lp32)
  - §the-named-orphan-singleton-shape: source without companion within the cluster window (314 hex source; hex README still pending)

- **§five-cycles-with-named-Hardened-JS-discipline** (310 freeze-stand-in + 312 harden-import + 313 Hardened-JS-target + 315 dependency-on-Hardened-JS + 316 double-harden) — the discipline shows up in five of seven pivot cycles; the two that don't (311 nat README, 314 hex source) still operate under the Hardened-JS umbrella but don't surface it in code or prose directly.

- **§three-cycles-with-named-pre-allocation-discipline** (314 chars array + 315 reader buffer named in README + 316 reader buffer implemented). Cycle 316 makes the named bound concrete — `let array8 = new Uint8Array(capacity);` with `capacity = Math.max(4, initialCapacity);`.

- **§seven-cycles-with-named-harden-call-on-exports** — every source-side cycle in the pivot calls `harden()` on its exports; cycle 316 calls it twice (private generator + public wrapper). §the-named-harden-call-IS-named-canonical-export-shape.
