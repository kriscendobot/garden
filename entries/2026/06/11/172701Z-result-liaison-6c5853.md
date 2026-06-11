---
kind: result
role: liaison
dispatch-root: dispatches/liaison--6c5853
cycle: 316
lane: chat
host: endolin
date: 2026-06-11
---

# Result — liaison cycle 316: @endo/lp32 reader.js (chat-lane; seventh consecutive @endo/* source; reverse-pair completes lp32 cluster)

Cycle 316 ingest: **@endo/lp32 reader.js** (82 lines) — the implementation companion to cycle 315's @endo/lp32 README.md. Chat-lane after cycle 315's designs-lane. **Seventh consecutive non-garden source after the pivot** (cycles 310-316). **Fourth package extends, not adds** — lp32 reader.js is the implementation side of cycle 315's lp32 README.md.

## Single most structurally interesting move

**§the-named-DataView-and-TypedArray-byte-order-asymmetry** — the file-top two-line rationale comment:

```js
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

This names a JS-language asymmetry the implementation relies on. DataView's default endianness is big-endian (network byte order); TypedArrays use host byte order. An explicit endianness argument bridges them. **§the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument** binds rationale-named (cycle 315 README) and technique-named (cycle 316 source) across the documentation/implementation boundary. First-explicit-observation.

## Pair shape established

Cycles 315-316 establish **§the-named-reverse-pair-shape**: README first, source second. This contrasts with **§the-named-regular-pair-shape** (cycles 310-311 nat src→README; cycles 312-313 memoize src→README). With cycle 314's @endo/hex source (no companion README in the cluster), the library now exhibits three pair shapes within the pivot cluster: **§three-shapes-of-pair-discipline** (regular + reverse + orphan-singleton). The pair *exists* in both shapes; the order of arrival differs.

## Citation arc closed

Cycle 316's reader.js *imports* `hostIsLittleEndian` from `./src/host-endian.js`. Cycle 243 (back in the depth-of-the-pre-garden-meta era) already ingested `host-endian.js` as a 9-line "isolate the named decision in its own file" study. Cycle 316 closes a **citation arc** with cycle 243: the file that *uses* the constant arrives 73 cycles after the file that *defines* it, and the library now has both ends of the dependency. **§the-named-citation-arc-IS-named-cross-cycle-closure** (informal naming for now; could promote in a future cycle).

## First-explicit-observations (twenty-plus)

- §the-named-DataView-and-TypedArray-byte-order-asymmetry
- §the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument
- §the-named-two-layer-factory-with-hidden-generator
- §the-named-double-harden-on-factory-and-generator-object
- §the-named-async-generator-not-arrow-because-generator
- §the-named-three-options-with-numeric-defaults
- §the-named-1MB-default-as-inline-comment
- §the-named-Math.max-floor-on-initialCapacity
- §the-named-geometric-buffer-growth
- §the-named-while-not-if-because-one-double-may-be-insufficient
- §the-named-DataView-must-be-rebuilt-on-resize
- §the-named-shared-buffer-between-Uint8Array-and-DataView
- §the-named-drain-loop-on-each-arrival
- §the-named-Fail-via-q-tagged-template-literal
- §the-named-message-includes-named-stream-name
- §the-named-yield-a-copy-not-a-view
- §the-named-copyWithin-for-in-place-shift
- §the-named-absolute-offset-only-for-error-context
- §the-named-trailing-bytes-fail-noisy
- §the-named-cross-package-type-reference-via-import-string
- §the-named-source-and-README-cross-reference-IS-named-pair-shape-marker

## Multi-cycle patterns extended

- §seven-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315 + 316)
- §three-shapes-of-pair-discipline (regular 310-311 + 312-313; reverse 315-316; orphan-singleton 314)
- §five-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316) — extends from four
- §three-cycles-with-named-pre-allocation-discipline (314 + 315 + 316) — extends from two
- §seven-cycles-with-named-harden-call-on-exports — extends from six

## Tier-3 meta-patterns

- §the-named-protocol-target-determined-byte-order-implemented-via-explicit-endianness-argument — rationale-named (README) meets technique-named (source) across the doc/impl boundary; the file-top comment IS the bridge between them
- §the-named-share-the-buffer-internally-isolate-on-yield — internal buffer recycling for efficiency; external view isolation for correctness
- §the-named-tracking-variable-only-for-diagnostics — a local exists *only* to enrich the error message; the error message pays for the tracking
- §the-named-DataView-binding-IS-named-eager — JS-language fact (DataView captures its ArrayBuffer at construction) made load-bearing in the code structure
- §the-named-source-and-README-cross-reference-IS-named-pair-shape-marker — when a pair exists across cycles, each member cites the other; the citation makes the pair legible

## Synthesis-target

Slot machine library **§`@game/streaming/src/reader.js`** — length-prefixed message stream reader between processes:

1. File-top rationale comment naming any JS-language asymmetry the implementation relies on (DataView/TypedArray default-byte-order asymmetry, for instance).
2. Two-layer factory: private `async function*` generator + public thin-wrapper factory; harden both.
3. Three named options with numeric defaults visible in destructuring (`name`, `initialCapacity`, `maxMessageLength`); last with inline unit comment.
4. Defensive minimum floor (`Math.max(prefix-size, initialCapacity)`).
5. Two views over one ArrayBuffer (Uint8Array for byte ops + DataView for typed-read-with-endianness).
6. Geometric growth with `while`-loop doubling.
7. Rebuild DataView on buffer replacement.
8. Outer `for await` chunk loop, inner `while` drain loop.
9. `Fail`-via-`q`-tagged-template error idiom with named stream name interpolated.
10. `slice()` (not `subarray()`) on yield with rationale comment.
11. `copyWithin` for in-place compaction; no allocation on internal maintenance.
12. Absolute-offset tracking variable read *only* by the error message.
13. Trailing-bytes fail-noisy at stream end.
14. JSDoc cross-package type reference via `import('@game/stream').Reader<...>`.

## Library state after cycle 316

- §library-reaches-828-sections from 366 source documents
- §one-hundred-and-forty-ninth consecutive designs-chat alternation (cycles 166-250 + 252-316; 251 out-of-band)
- §seven-cycles-with-named-pivot-domain-stay (pivot productive at seven cycles)
- §three-shapes-of-pair-discipline established this cycle (regular + reverse + orphan-singleton)
- §five-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316)

## Next cycle pacing

Cycle 317 is designs-lane next. With the lp32 reverse-pair complete, candidate moves:

- @endo/lp32 writer.js (49 lines) — would complete a *three-file* lp32 cluster: 315 README + 316 reader.js + 317 writer.js. Symmetric to reader.js but smaller; the README named the writer's `.next(value)` + `.return()` API, so the source would technique-name it. **Chat-lane material, not designs-lane.** Defer.
- @endo/hex README.md (60 lines) — designs-lane; companion to cycle 314's @endo/hex source. Would convert cycle 314's §the-named-orphan-singleton-shape into a §the-named-regular-pair-shape *retroactively* — the source-then-README order would hold, just with a two-cycle gap. **Likely candidate.**
- @endo/stream README.md — designs-lane; cycle 315's round-trip example cited `makePipe()` from `@endo/stream` as the cross-package composition partner. Would establish a fifth package in the pivot cluster.

@endo/hex README is the more productive choice next cycle (closes the cycle 314 orphan into a pair; adds a *fifth* §the-named-six-section-README-shape data point if hex's README follows the same shape). Picking freely but tracking for future work.
