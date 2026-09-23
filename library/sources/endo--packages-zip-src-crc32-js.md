---
title: "@endo/zip/src/crc32.js — pre-pasted from pako with attribution; IEEE 802.3 reversed polynomial; incremental CRC API via default parameters"
source-slug: endo--packages-zip-src-crc32-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/crc32.js
authors: [Endo project (collective, pre-pasted from pako)]
repo: endojs/endo
path: packages/zip/src/crc32.js
total-lines: 48
ingest-cycle: 286
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/crc32.js`

A 48-line file implementing CRC-32 (IEEE 802.3) via the standard table-lookup approach. The two functions `makeTable` and `crc32` come from pako's `pako/lib/zlib/crc32.js` (MIT licensed) — pre-pasted with explicit attribution comment at the top. Was part of cycle 191's zip-cluster ingest (cluster-scope); cycle 286 ingests as a per-file deep pass.

## Key moves

- **§pre-pasted-from-pako-with-attribution-comment** — four-line block comment naming upstream source + license + URL.
- **§the-attribution-comment-as-named-borrowed-code-discipline** — inline at the top of the consuming file, not buried in a LICENSE.
- **§the-`// Use ordinary array, since untyped makes no boost here` comment** — explanatory comment justifies `Array<number>` over `Uint32Array`; the-explanatory-comment-IS-the-named-choice-justification.
- **§the-`/* eslint no-bitwise: ["off"] */` file-scope ESLint exception** — extends prior 4-cycle pattern to §five-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278 + 286).
- **§the-magic-number-`0xedb88320`-IS-the-IEEE-802.3-reversed-polynomial** — reflected form of `0x04C11DB7`.
- **§the-table-initialized-at-module-load** — `const table = makeTable();` runs at module-import; module-load-time-initialization as named optimization.
- **§the-incremental-CRC-API-via-default-parameters** — `crc32(bytes, length = bytes.length, index = 0, crc = 0)`; the-default-parameters-make-the-streaming-and-non-streaming-API-the-same-function.
- **§the-`crc ^= -1`-pre-XOR + `(crc ^ -1) >>> 0`-post-XOR-mask** — standard CRC-32 finalization; the-`-1`-IS-the-named-all-ones-mask-in-JS-bitwise-context.
- **§the-`>>> 0`-unsigned-coercion** — JS-32-bit-unsigned-coercion idiom.
- **§the-256-table-lookup-with-`& 0xff`-byte-mask** — `(crc ^ bytes[i]) & 0xff`; mask IS explicit not implicit.
- **§the-double-XOR-with-`-1` as named CRC32-finalization pattern**.
- **§the-table-lookup-IS-the-named-optimization-vs-bit-by-bit** — 1 KiB table buys 8× speedup; the-canonical-CRC-32-optimization-IS-named.
- **§three-named-stops-in-the-`makeTable`-inner-loop** — eight iterations per byte, one per bit; the-startup-runs-the-slow-form-once-to-precompute-the-fast-form.
- **§the-`return table;`-after-mutation-without-`harden`** — module-scope mutable private state; the-private-by-module-scope IS distinct from the-private-by-WeakMap (cycle 191's buffer-reader / buffer-writer); §two-named-private-state-shapes-in-the-zip-cluster.
- **§the-eight-bit-shift-and-XOR-pattern as named CRC-32-update step** — `(crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xff]`; three operations in one statement.
- **§the-loop-variable-IS-named-by-the-domain-of-its-iteration** — `n` for natural-number byte + `k` for bit index + `i` for buffer position.
- **§the-`+= 1` vs `++` increment idiom** — ESLint-friendly; canonical-across-the-zip-cluster.
- **§the-pre-pasted-code-conforms-to-the-host-project's-conventions** — `// @ts-check` + `/* eslint no-bitwise: ["off"] */` + `+= 1` + JSDoc; the-attribution-comment-does-NOT-mean-verbatim-paste; the-named-adaptation-while-preserving-attribution discipline.
- **§the-pako-attribution-IS-second-cycle-in-the-cluster** — §two-cycles-with-pako-attribution (191 cluster + 286 per-file).
- **§two-named-magic-number-kinds-in-the-zip-cluster** — format-identifier (cycle 278 `PK` + `ZIP64_`) + algorithm-constant (cycle 286 `0xedb88320`).
- **§six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster** (191 + 278 + 280 + 282 + 284 + 286).

## Section files

- [§pre-pasted-from-pako-with-attribution + §the-IEEE-reversed-polynomial + §table-initialized-at-module-load + §incremental-API-with-default-parameters + 17 more first-explicit-observations](../sections/endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters.md) — full 48-line file in scope at cycle 286 (per-file deep ingest after cycle 191's cluster-scope ingest).

## Ingest scope

Cycle 286 (chat-lane after cycle 285's designs-lane OUTLINER_INTERACTION_PATTERNS second-pass). Full 48-line file in scope. **First-explicit-observations (twenty-one)** as a per-file deep ingest: pre-pasted-from-pako-with-attribution-comment + the-attribution-comment-as-named-borrowed-code-discipline + the-`// Use ordinary array, since untyped makes no boost here` comment + the-explanatory-comment-IS-the-named-choice-justification + the-magic-number-`0xedb88320`-IS-the-IEEE-802.3-reversed-polynomial + the-reversed-polynomial-form-IS-the-named-standard + the-table-initialized-at-module-load + module-load-time-initialization-as-named-optimization-shape + the-incremental-CRC-API-via-default-parameters + the-default-parameters-make-the-streaming-and-non-streaming-API-the-same-function + the-`>>> 0`-unsigned-coercion + the-double-XOR-with-`-1`-as-named-CRC32-finalization + the-table-lookup-IS-the-named-optimization-vs-bit-by-bit + three-named-stops-in-the-`makeTable`-inner-loop + the-startup-runs-the-slow-form-once-to-precompute-the-fast-form + the-`return table;`-after-mutation-without-`harden` + the-private-by-module-scope-IS-distinct-from-private-by-WeakMap + the-eight-bit-shift-and-XOR-pattern + the-loop-variable-IS-named-by-the-domain-of-its-iteration + the-pre-pasted-code-conforms-to-the-host-project's-conventions + the-named-adaptation-while-preserving-attribution.
