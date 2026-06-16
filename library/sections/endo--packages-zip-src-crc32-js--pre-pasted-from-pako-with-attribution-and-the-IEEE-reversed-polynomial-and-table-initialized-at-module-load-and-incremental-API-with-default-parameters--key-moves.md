---
title: Key moves
section-slug: endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters
source-slug: endo--packages-zip-src-crc32-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/crc32.js
authors: [Endo project (collective, pre-pasted from pako)]
repo: endojs/endo
path: packages/zip/src/crc32.js
total-lines: 48
ingest-cycle: 286
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters
---

- **§pre-pasted-from-pako-with-attribution-comment** (first-explicit-observation as a per-file ingest; noted in cycle 191's cluster ingest) — the four-line block-comment naming the upstream source (`pako/lib/zlib/crc32.js`), the license (MIT), and the project URL (`https://github.com/nodeca/pako/`).
- **§the-attribution-comment-as-named-borrowed-code-discipline** (first-explicit-observation): when code IS pre-pasted from an upstream project, the file *opens with the attribution* — not buried in a `LICENSE` file at the repo root, but inline at the top of the consuming file.
- **§the-`// Use ordinary array, since untyped makes no boost here` comment** (first-explicit-observation): a single-line explanatory comment naming **why** an ordinary `Array<number>` is used instead of `Uint32Array`. **§the-explanatory-comment-IS-the-named-choice-justification**: the comment proves the choice was deliberate (someone tested) rather than default.
- **§the-`/* eslint no-bitwise: ["off"] */` file-scope ESLint exception** — reaffirms cycle 278's §named-ESLint-disable-shapes; **§five-cycles-with-named-eslint-directive-as-acknowledged-exception** extends prior 4-cycle pattern (245 + 254 + 276 + 278 + 286).
- **§the-magic-number-`0xedb88320`-IS-the-IEEE-802.3-reversed-polynomial** (first-explicit-observation): the *reflected* form of the polynomial `0x04C11DB7`. **§the-reversed-polynomial-form-IS-the-named-standard-for-CRC32**.
- **§the-table-initialized-at-module-load** — `const table = makeTable();` runs once when the module is imported; the table IS module-scoped state. **§module-load-time-initialization as named optimization shape** (first-explicit-observation in this context): trades increased module-load cost for per-call computation reduction.
- **§the-incremental-CRC-API-via-default-parameters** (first-explicit-observation): `crc32(bytes, length = bytes.length, index = 0, crc = 0)` — the four parameters let the caller compute the CRC of a chunk by passing the previous chunk's CRC as the `crc` parameter, and process a slice with explicit `index` + `length`. **§the-default-parameters-make-the-streaming-and-non-streaming-API-the-same-function**.
- **§the-`crc ^= -1`-pre-XOR + `(crc ^ -1) >>> 0`-post-XOR-mask pattern** — standard CRC-32 finalization; the `-1` (in JS, the 32-bit two's-complement representation 0xFFFFFFFF) is XORed in and out.
- **§the-`>>> 0` unsigned-coercion** (first-explicit-observation): JavaScript's `^` operator returns a *signed* 32-bit int; the trailing `>>> 0` forces unsigned coercion (an idiomatic JS-32-bit trick). **§the-`>>> 0` IS the named JS-unsigned-coercion idiom**.
- **§the-256-table-lookup-with-`& 0xff`-byte-mask** — `(crc ^ bytes[i]) & 0xff` extracts the low byte of the XOR result to index the table. **§the-byte-mask-IS-explicit-not-implicit** even though `bytes[i]` is already a byte; the mask defends the table-index against any non-byte-shape `crc ^ bytes[i]` value.
