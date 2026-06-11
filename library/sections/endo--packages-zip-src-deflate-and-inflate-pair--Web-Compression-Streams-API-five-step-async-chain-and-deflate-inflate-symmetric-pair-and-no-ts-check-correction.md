---
title: "@endo/zip/src/{deflate,inflate}.js — Web Compression Streams API five-step async chain (Blob → Stream → Response → Blob → ArrayBuffer → Uint8Array) + deflate-inflate symmetric pair + correction: neither file has `// @ts-check`"
section-slug: endo--packages-zip-src-deflate-and-inflate-pair--Web-Compression-Streams-API-five-step-async-chain-and-deflate-inflate-symmetric-pair-and-no-ts-check-correction
source-slug: endo--packages-zip-src-deflate-and-inflate-pair
url: https://github.com/endojs/endo/blob/master/packages/zip/src/{deflate,inflate}.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/{deflate.js,inflate.js}
total-lines: 58 (31 deflate + 27 inflate)
ingest-cycle: 288
ingest-date: 2026-06-10
lane: chat
scope: full
---

# `@endo/zip/src/{deflate,inflate}.js` (pair ingest)

Two near-symmetric files implementing the zip cluster's **compression and decompression** primitives via the **Web Compression Streams API** (`CompressionStream` + `DecompressionStream`). Each file follows an *internal-helper + external-default-export* shape: `compress`/`decompress` is the internal pump, `deflate`/`inflate` is the named external wrapper that fixes the algorithm to `'deflate-raw'`.

## Key moves

- **§the-Web-Compression-Streams-API-as-named-browser-platform-substrate** (first-explicit-observation): `new CompressionStream(...)` + `new DecompressionStream(...)` are *web-platform built-ins*, not bundled libraries. The cluster trusts the host environment to provide DEFLATE-RAW.
- **§the-`'deflate-raw'`-literal-union-type-as-named-API-constraint** (first-explicit-observation): the JSDoc `@param {'deflate-raw'} compressionMethodName` declares **a single-literal-union type**. Callers can pass *only* the string `'deflate-raw'`; any other string is a type error. **§the-single-literal-union-IS-the-named-future-extension-shape** — the type makes room for future algorithms (`'gzip'` + `'deflate'` would extend the union) without changing the function signature.
- **§the-deflate-inflate-symmetric-pair-shape** (first-explicit-observation in pair-ingest scope): cycle 284's reader-writer was 264:60-line asymmetric; cycle 288's deflate-inflate is **near-1:1 symmetric** (31 vs 27 lines). The asymmetry reflects task-asymmetry (writing harder than reading); the symmetry here reflects task-symmetry (compress and decompress are mirror operations through CompressionStream / DecompressionStream).
- **§the-five-step-async-chain** (first-explicit-observation): the compress function performs a five-step bytes-in-to-bytes-out conversion:
  1. `new Blob([bytes], {type})` — wrap Uint8Array in a Blob.
  2. `.stream()` — get a ReadableStream from the Blob.
  3. `.pipeThrough(compressionStream)` — pipe through the CompressionStream.
  4. `new Response(stream)` — convert to a Response for buffering.
  5. `.blob().arrayBuffer().Uint8Array(...)` — three nested awaits to get bytes back.
- **§the-`new Blob([...], { type: 'application/octet-stream' })` pattern** (first-explicit-observation): MIME type `'application/octet-stream'` IS the **named neutral-binary-content-type** for opaque byte streams; the Blob's type is set even though no consumer reads the MIME — the discipline IS that *every Blob has a meaningful type*.
- **§the-`[/** @type {BlobPart} */ (uncompressedBytes)]`-as-named-inline-type-cast** (first-explicit-observation): JSDoc inline type cast around the Uint8Array to coerce it to `BlobPart` (which is `BufferSource | Blob | string`). **§the-type-cast-at-the-argument-site IS the named workaround for incomplete typing of the Web Platform API**.
- **§the-internal-helper-plus-named-wrapper pattern** (first-explicit-observation in this context): `compress` is the algorithm-parameterized internal; `deflate` is the algorithm-fixed external. **§the-external-wrapper-IS-where-the-algorithm-IS-chosen**; the internal is general; the external is specific. Reader/writer cluster had the same shape (cycle 280's `writeZip = factory(...)`), but this is the simplest possible instance — a single line.
- **§the-`const deflate = uncompressedBytes => compress(uncompressedBytes, 'deflate-raw');` one-line wrapper** (first-explicit-observation): the algorithm-fixing wrapper IS a *single arrow-function expression*. No body block; no statement count; the expression IS the function.
- **§the-`export default deflate;` default-export-discipline** (first-explicit-observation in this file's pattern terms): both `deflate.js` and `inflate.js` use `export default` (NOT named export). This is the **named convention for "this file IS the function"** — the file's purpose IS a single named entity that the file exports as its default.
- **§the-`tentatively just DEFLATE-RAW` named-tentativeness-marker-in-code-comment** (first-explicit-observation): the comment "tentatively just DEFLATE-RAW" is a **prose-hedge inside JSDoc** — sibling-pattern to cycle 263's "my current recommendation"/§three-prose-hedges-in-one-design-fragment. §the-tentativeness-marker-IS-the-named-deliberate-non-finalization.
- **§the-deviation-from-`// @ts-check`-discipline (correction at cycle 288)** (first-explicit-observation): **neither deflate.js nor inflate.js carries the `// @ts-check` directive**. Cycle 286's §six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster claim WAS WRONG; the directive IS on signature.js + writer.js + types.js + reader.js + crc32.js + compression.js, but NOT on deflate.js or inflate.js. **§correction-cycle: cycle 286's-pattern-claim-overgeneralized**; the actual pattern IS §the-`// @ts-check`-directive-IS-on-most-files-of-the-zip-cluster-but-not-the-compression-pair.
- **§the-`@type {BlobPart}` inline cast as named TypeScript-typing-incompleteness-workaround**: the cast exists *because* Web Platform DOM typings sometimes don't include Uint8Array as a BlobPart variant in some lib targets. The inline cast IS the named fix for upstream-incomplete typings.

## §the-symmetric-pair-with-mirror-naming (first-explicit-observation)

| Aspect | deflate.js | inflate.js |
|---|---|---|
| Internal helper | `compress(uncompressedBytes, compressionMethodName)` | `decompress(compressedBytes, compressionMethodName)` |
| External wrapper | `deflate` | `inflate` |
| Lines | 31 | 27 |
| Web API | `CompressionStream` | `DecompressionStream` |
| `// @ts-check` | absent | absent |
| Default export | `deflate` | `inflate` |
| Variable name pattern | `uncompressed*` prefix | `compressed*` + `decompressed*` prefix |

**§named-variable-prefix-pairs as state-tracking discipline**: in compress, the variables flow `uncompressedBlob → compressionStream → compressedStream → compressedResponse → compressedBlob → compressedArrayBuffer → bytes`. The prefix `uncompressed` vs `compressed` IS a named marker that **encodes the data's current state in the variable name**. This is **§the-variable-prefix-IS-the-state-marker** — at any point in the function the reader can see which side of the compression boundary each value sits on.

§the-state-tracking-via-prefix IS sibling-pattern to Hungarian notation but used for *data-flow state* not *type*. The compress function has 7 distinct names that *narrate* the conversion.

## §the-asymmetric-line-count-with-symmetric-shape (first-explicit-observation)

Why is deflate.js 31 lines and inflate.js 27 lines if they're structurally symmetric? The difference IS 4 lines — accounted for by:

- The deflate Blob construction wraps the array argument across multiple lines (`[/** @type {BlobPart} */ (uncompressedBytes)]` on a separate line); the inflate version inlines it (`[/** @type {BlobPart} */ (compressedBytes)]` inside the Blob constructor call).
- The deflate JSDoc opens with `Compresses bytes with the DEFLATE-RAW algorithm.` (2 lines); the inflate JSDoc has only `@param` (1 line of JSDoc on the wrapper).

**§the-formatting-asymmetry-IS-the-cause-of-the-line-count-asymmetry-not-the-substance**. Both files do the same shape of work; the file lengths differ because of formatting choices around the Blob constructor and JSDoc verbosity. §the-line-count-IS-NOT-the-substance.

## §the-Web-Platform-Compression-API-shape as named contemporary-substrate (first-explicit-observation)

The cluster has a *split* in how it handles compression:

- For the format-level CRC checksum: **pre-pasted-pako** code (cycle 286's observation).
- For the actual compression: **the-Web-Platform-API** (cycle 288's observation).

**§two-named-substrate-choices-for-different-binary-operations**: the cluster uses the *better* substrate for each task. Pako is the canonical CRC-32 implementation; the Web Platform's CompressionStream is the canonical DEFLATE-RAW implementation for browser-targeting code.

§the-pre-pasted-pako-IS-for-CRC-while-the-Web-API-IS-for-compression — distinct named substrates for distinct concerns.

## §the-`'deflate-raw'`-IS-fixed-but-the-internal-parameter-IS-the-future-extension-point (first-explicit-observation)

`compress` accepts `compressionMethodName` as a parameter; `deflate` fixes it to `'deflate-raw'`. **§the-internal-IS-the-future-multi-algorithm-API + the-external-IS-the-present-single-algorithm-API**. If the cluster later supports `'gzip'`, only the type union needs to widen, and a new `gzip = ...` wrapper added. The internal need not change.

§the-named-future-extension-shape IS encoded in the type system today. The type IS the bouncer: future additions are anticipated by the union shape.

## §the-async-arrow-function-as-named-substrate-of-the-helper (first-explicit-observation in this context)

Both internal helpers are `async (..., ...) => { ... }` — async arrow functions, not async-named-function-declarations. **§the-async-arrow-IS-the-cluster-canonical-form-for-multi-step-async-chains**. The arrow form is terser; the function-declaration form would be `async function compress(...)` and add a few characters.

§the-arrow-form-IS-the-named-cluster-style — sibling-pattern to cycle 280's `writeZip = async (files) => ...`.

## §the-five-named-intermediate-values-in-one-async-chain (first-explicit-observation)

Compress declares:
1. `uncompressedBlob` (Blob)
2. `compressionStream` (CompressionStream)
3. `compressedStream` (ReadableStream)
4. `compressedResponse` (Response)
5. `compressedBlob` (Blob)
6. `compressedArrayBuffer` (ArrayBuffer)
7. `bytes` (Uint8Array)

**Seven named intermediate values in a 17-line function**. Each value IS named with its data-state-prefix; the final `bytes` IS the only one without a state prefix because the final result IS the canonical-form. **§named-intermediate-values-IS-the-narrative-discipline**. Compare cycle 286's `n`/`k`/`i` brevity (mathematical letters for tight loops); this is the opposite end of the naming spectrum — long descriptive names for a multi-step asynchronous transformation.

§the-naming-style-DEPENDS-on-the-domain: mathematical brevity for hot loops + descriptive verbosity for state-tracking chains.

## §the-`new Response(stream)` IS the named way to drain a stream into bytes (first-explicit-observation)

A `Response` constructed from a `ReadableStream` lets you call `.blob()`, `.arrayBuffer()`, `.text()`, `.json()` on it — **§the-Response-IS-the-named-stream-drain-utility**. This is a Web Platform idiom: instead of writing a loop that reads chunks and accumulates them, you wrap the stream in a Response and let the Response's built-in methods do the accumulation.

§the-Response-IS-NOT-just-for-HTTP — even though `Response` is named after HTTP responses, it serves as a *general-purpose stream-to-bytes adapter*. **§the-API-shape-IS-reused-beyond-its-original-purpose** — a named Web Platform pattern.

## §the-three-nested-awaits-as-named-completion-discipline (first-explicit-observation)

```javascript
const compressedBlob = await compressedResponse.blob();
const compressedArrayBuffer = await compressedBlob.arrayBuffer();
const bytes = new Uint8Array(compressedArrayBuffer);
```

**Three separate awaits in three statements**, NOT one chained await. **§the-named-decomposed-await-shape**: each statement names its intermediate value; the reader can pause and inspect at any line. Compare the alternative `const bytes = new Uint8Array(await (await compressedResponse.blob()).arrayBuffer())` — denser but harder to read.

§named-intermediate-await-results-IS-the-debug-friendly-discipline. The code IS optimized for *future-reader debuggability* over *current-writer terseness*.

## §correction-cycle: cycle 286's six-cycles-claim-was-overgeneralization (first-explicit-observation)

Cycle 286 asserted §six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster (191 + 278 + 280 + 282 + 284 + 286). **This was incorrect.** The actual count IS:

| File | `// @ts-check` |
|---|---|
| compression.js | yes |
| signature.js | yes |
| crc32.js | yes |
| types.js | yes |
| reader.js | yes |
| writer.js | yes |
| deflate.js | **NO** |
| inflate.js | **NO** |
| buffer-reader.js | (TBD) |
| buffer-writer.js | (TBD) |
| format-reader.js | (TBD) |
| format-writer.js | (TBD) |

**§correction-cycle as named library-self-correction shape**: cycle 286's pattern claim got refuted at cycle 288. The library tracks corrections by adding a new section that *names the prior error*. This is **§the-library-IS-self-correcting-by-explicit-refutation** — not by silent revision.

The accurate claim is **§the-`// @ts-check`-directive-IS-on-most-files-of-the-zip-cluster-but-not-the-compression-pair (deflate.js + inflate.js)**. The pair IS missing the directive — possibly because they're thin wrappers around Web Platform APIs that have their own types, possibly an oversight, possibly because the files predate the project's `// @ts-check` discipline being applied universally.

§three-cycles-with-prior-cycle-correction-observed (273 confirms 263 + 286 makes claim + 288 corrects 286). **§the-library-IS-an-evolving-discipline-with-named-correction-events**.

## Patterns from prior cycles, reaffirmed

- **§the-async-arrow-function** (cycle 280 writer.js).
- **§the-internal-helper-plus-named-wrapper** (cycle 280 writer.js writeZip + cycle 284 reader.js readZip + cycle 288 deflate/inflate).
- **§named-variable-prefix-pairs as state-tracking discipline** — cycle 280 noted "preserved JSDoc typo" + this is a new naming-discipline observation.
- **§the-`@type {...}` inline cast as named TypeScript-typing-workaround** — cycle 284's `@type {ReadFn}` (intra-package binding) vs cycle 288's `@type {BlobPart}` (Web Platform typing workaround); §two-named-`@type`-cast-purposes-in-the-zip-cluster.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-Web-Compression-Streams-API + §the-`'deflate-raw'`-literal-union-type + §the-single-literal-union-IS-the-named-future-extension-shape + §the-deflate-inflate-symmetric-pair-shape + §the-five-step-async-chain + §the-`new Blob([...], { type: 'application/octet-stream' })`-pattern + §the-`[/** @type {BlobPart} */ (uncompressedBytes)]`-inline-type-cast + §the-internal-helper-plus-named-wrapper + §the-one-line-arrow-wrapper + §the-`export default` discipline + §the-`tentatively just DEFLATE-RAW`-named-tentativeness-marker-in-code-comment + §the-deviation-from-`// @ts-check`-discipline + §correction-cycle-as-named-library-self-correction + §the-symmetric-pair-with-mirror-naming + §named-variable-prefix-pairs + §the-state-tracking-via-prefix + §the-line-count-IS-NOT-the-substance + §two-named-substrate-choices-for-different-binary-operations + §the-named-future-extension-shape-encoded-in-the-type + §named-intermediate-values-IS-the-narrative-discipline + §the-Response-IS-the-named-stream-drain-utility + §the-API-shape-IS-reused-beyond-its-original-purpose + §the-named-decomposed-await-shape + §named-intermediate-await-results-IS-the-debug-friendly-discipline — all twenty-four first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §the-naming-style-DEPENDS-on-the-domain (cycle 286 mathematical letters + cycle 288 descriptive verbosity) + §two-named-`@type`-cast-purposes-in-the-zip-cluster + §the-async-arrow-IS-the-cluster-canonical-form + §the-pre-pasted-pako-IS-for-CRC-while-the-Web-API-IS-for-compression.
- **Tier 3 (multi-cycle pattern recognition)**: §three-cycles-with-prior-cycle-correction-observed (273 confirms 263 + 286 makes claim + 288 corrects 286) + §the-zip-cluster-source-file-deep-ingest-progresses (6 of 12 files now per-file ingested — cycle 288's pair brings the count to 7 if we count deflate and inflate separately, or 6 if counted as a pair).

## Synthesis target

Slot machine library `@game/replay/src/{compress,decompress}.js`: deflate-inflate pair using Web Compression Streams API; `'deflate-raw'` literal-union-type for future-extension; five-step async chain (Blob → Stream → Response → Blob → ArrayBuffer → Uint8Array); MIME type `'application/octet-stream'` discipline; inline `@type {BlobPart}` cast for Web Platform typing workaround; internal `compress`/`decompress` algorithm-parameterized + external `deflate`/`inflate` algorithm-fixed; one-line arrow wrapper; `export default` discipline; "tentatively just DEFLATE-RAW" named-tentativeness-marker; descriptive variable names with state-prefix (`uncompressed*` vs `compressed*`); seven named intermediate values for narrative clarity; `new Response(stream)` as stream-drain utility; three nested awaits decomposed for debugging.

## Single most structurally interesting move

**§correction-cycle as named library-self-correction shape** — cycle 286's §six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster claim was an over-generalization. Cycle 288 corrects it explicitly, not by silent revision but by **naming the prior cycle's claim as wrong** and stating the correct pattern. The library's integrity depends on this correction-by-explicit-refutation discipline: future readers searching for the `// @ts-check` claim will find both the original assertion (cycle 286) and the correction (cycle 288), and can trace the truth through the chain.

This is **§the-library-IS-an-evolving-discipline-with-named-correction-events**, not a static archive. The pattern generalizes: any long-running pattern-tracking system needs an explicit shape for "I previously said X but now I see X is wrong" — burying the correction inside the next cycle's prose makes the library less trustworthy than naming the correction as such.

§three-cycles-with-prior-cycle-correction-observed (273 confirms 263 + 286 makes claim + 288 corrects 286) — the library has named-correction-events now in addition to named-confirmation-events.
