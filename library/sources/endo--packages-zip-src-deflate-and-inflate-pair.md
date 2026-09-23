---
title: "@endo/zip/src/{deflate,inflate}.js — Web Compression Streams API pair; near-symmetric (31:27 lines); neither file has `// @ts-check`"
source-slug: endo--packages-zip-src-deflate-and-inflate-pair
url: https://github.com/endojs/endo/blob/master/packages/zip/src/{deflate,inflate}.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/{deflate.js,inflate.js}
total-lines: 58 (31 + 27)
ingest-cycle: 288
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/{deflate,inflate}.js`

Two near-symmetric files implementing the zip cluster's compression/decompression primitives via the **Web Compression Streams API** (`CompressionStream` + `DecompressionStream`). Each file uses an *internal-helper + external-default-export* shape. **Important correction**: neither file carries `// @ts-check` — cycle 286's six-cycles-with-`// @ts-check`-on-every-file claim was an over-generalization.

## Key moves

- **§the-Web-Compression-Streams-API-as-named-browser-platform-substrate** — `CompressionStream` + `DecompressionStream` as web-platform built-ins.
- **§the-`'deflate-raw'`-literal-union-type-as-named-API-constraint** — `@param {'deflate-raw'} compressionMethodName` declares single-literal-union; the-single-literal-union-IS-the-named-future-extension-shape.
- **§the-deflate-inflate-symmetric-pair-shape** — near-1:1 line counts (31 vs 27) reflecting task-symmetry vs cycle 284's reader-writer 264:60 asymmetry.
- **§the-five-step-async-chain** — Blob → Stream → Response → Blob → ArrayBuffer → Uint8Array (five transformations to get bytes-in-bytes-out).
- **§the-`new Blob([...], { type: 'application/octet-stream' })`-pattern** — `application/octet-stream` MIME type as named neutral-binary-content-type; the-discipline-IS-that-every-Blob-has-a-meaningful-type.
- **§the-`[/** @type {BlobPart} */ (uncompressedBytes)]`-inline-type-cast** — workaround for Web Platform DOM typings incompleteness.
- **§the-internal-helper-plus-named-wrapper pattern** — `compress` is algorithm-parameterized internal; `deflate` is algorithm-fixed external one-line arrow-function wrapper.
- **§the-`export default deflate;` default-export-discipline** — both files use default export; the-file's-purpose-IS-a-single-named-entity.
- **§the-`tentatively just DEFLATE-RAW`-named-tentativeness-marker-in-code-comment** — prose-hedge inside JSDoc; sibling-pattern to cycle 263's "my current recommendation".
- **§the-deviation-from-`// @ts-check`-discipline (correction at cycle 288)** — neither deflate.js nor inflate.js has the directive; the cluster's directive coverage IS NOT universal.
- **§correction-cycle as named library-self-correction shape** — cycle 286's six-cycles-with-`// @ts-check`-on-every-file claim was over-generalization; cycle 288 corrects explicitly; the-library-IS-self-correcting-by-explicit-refutation.
- **§the-symmetric-pair-with-mirror-naming** — compress/decompress + deflate/inflate + uncompressed*/compressed* state-prefix-named variables.
- **§named-variable-prefix-pairs as state-tracking discipline** — variable name encodes data's current state; sibling-pattern to Hungarian notation but for data-flow state.
- **§the-line-count-IS-NOT-the-substance** — 4-line difference between files comes from formatting choices not substantive differences.
- **§two-named-substrate-choices-for-different-binary-operations** — pre-pasted-pako-IS-for-CRC + Web-Platform-API-IS-for-compression.
- **§the-`'deflate-raw'`-IS-fixed-but-the-internal-parameter-IS-the-future-extension-point** — future algorithm additions widen the type union; internal function need not change.
- **§the-async-arrow-IS-the-cluster-canonical-form-for-multi-step-async-chains**.
- **§seven-named-intermediate-values-in-one-async-chain** — named-intermediate-values-IS-the-narrative-discipline.
- **§the-Response-IS-the-named-stream-drain-utility** — `new Response(stream)` lets you call `.blob()`/`.arrayBuffer()`/`.text()`; the-Response-IS-NOT-just-for-HTTP; the-API-shape-IS-reused-beyond-its-original-purpose.
- **§the-three-nested-awaits-as-named-completion-discipline** — three decomposed awaits with named intermediate values for debug-friendliness; named-decomposed-await-shape.
- **§three-cycles-with-prior-cycle-correction-observed** (273 confirms 263 + 286 makes claim + 288 corrects 286) — the-library-IS-an-evolving-discipline-with-named-correction-events.

## Section files

- [§Web-Compression-Streams-API + §five-step-async-chain + §deflate-inflate-symmetric-pair + §correction-cycle for cycle 286's overgeneralization](../sections/endo--packages-zip-src-deflate-and-inflate-pair--Web-Compression-Streams-API-five-step-async-chain-and-deflate-inflate-symmetric-pair-and-no-ts-check-correction.md) — full 58-line pair in scope at cycle 288.

## Ingest scope

Cycle 288 (chat-lane after cycle 287's designs-lane subpath-pattern-replacement). Full 58-line pair (31 deflate + 27 inflate) in scope. **First-explicit-observations (twenty-four)**: the-Web-Compression-Streams-API + the-`'deflate-raw'`-literal-union-type + the-single-literal-union-IS-the-named-future-extension-shape + the-deflate-inflate-symmetric-pair-shape + the-five-step-async-chain + the-`new Blob([...], { type: 'application/octet-stream' })`-pattern + the-`[/** @type {BlobPart} */ (...)]`-inline-type-cast + the-internal-helper-plus-named-wrapper + the-one-line-arrow-wrapper + the-`export default` discipline + the-`tentatively just DEFLATE-RAW`-named-tentativeness-marker + the-deviation-from-`// @ts-check`-discipline + correction-cycle-as-named-library-self-correction + the-symmetric-pair-with-mirror-naming + named-variable-prefix-pairs + the-state-tracking-via-prefix + the-line-count-IS-NOT-the-substance + two-named-substrate-choices-for-different-binary-operations + the-named-future-extension-shape-encoded-in-the-type + named-intermediate-values-IS-the-narrative-discipline + the-Response-IS-the-named-stream-drain-utility + the-API-shape-IS-reused-beyond-its-original-purpose + the-named-decomposed-await-shape + named-intermediate-await-results-IS-the-debug-friendly-discipline.
