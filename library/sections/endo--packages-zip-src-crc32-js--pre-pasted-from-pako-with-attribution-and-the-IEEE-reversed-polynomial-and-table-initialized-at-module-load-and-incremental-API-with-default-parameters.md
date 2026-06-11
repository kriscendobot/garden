---
title: "@endo/zip/src/crc32.js — pre-pasted from pako with attribution comment + the IEEE 802.3 reversed polynomial 0xedb88320 + table initialized at module load + incremental CRC API with default parameters"
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
---

# `@endo/zip/src/crc32.js` (full file)

A 48-line file (the second-smallest zip cluster source file after `compression.js`'s 4 lines) implementing **CRC-32 IEEE 802.3 with the standard table-lookup approach**. The two functions `makeTable` and `crc32` come from **pako**'s `pako/lib/zlib/crc32.js` released under the MIT license — pre-pasted with **explicit attribution comment** at the top of the file. Was part of cycle 191's zip-cluster ingest; cycle 286 ingests as a per-file deep pass.

## Key moves

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

## The structure

```javascript
// @ts-check
/* eslint no-bitwise: ["off"] */

/**
 * The following functions `makeTable` and `crc32` come from `pako`, from
 * pako/lib/zlib/crc32.js released under the MIT license, see pako
 * https://github.com/nodeca/pako/
 */

// Use ordinary array, since untyped makes no boost here
function makeTable() {
  let c;
  const table = [];
  for (let n = 0; n < 256; n += 1) {
    c = n;
    for (let k = 0; k < 8; k += 1) {
      c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    }
    table[n] = c;
  }
  return table;
}

const table = makeTable();

export function crc32(bytes, length = bytes.length, index = 0, crc = 0) {
  const end = index + length;
  crc ^= -1;
  for (let i = index; i < end; i += 1) {
    crc = (crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xff];
  }
  return (crc ^ -1) >>> 0;
}
```

## §the-double-XOR-with-`-1` as named CRC32-finalization pattern (first-explicit-observation)

The function performs **`crc ^= -1`** *before* the loop and **`(crc ^ -1) >>> 0`** *after* the loop. This double XOR with the bitmask `-1` (= `0xFFFFFFFF` in 32-bit signed-vs-unsigned) IS the standard CRC-32 finalization sequence. **§the-pre-and-post-XOR-mask-IS-the-named-standard-shape** for the IEEE 802.3 polynomial.

§the-`-1`-as-bitmask-IS-JS-specific-shorthand: in JavaScript, `-1` in a bitwise context is `0xFFFFFFFF` (all 1s in 32-bit two's complement). Using `-1` instead of `0xFFFFFFFF` is a *terser* idiom but means **the same thing** — the XOR mask flips every bit. §the-`-1`-IS-the-named-all-ones-mask-in-JS-bitwise-context.

## §the-table-lookup-IS-the-named-optimization-vs-bit-by-bit (first-explicit-observation)

The naive CRC-32 computes one bit at a time (32 iterations per byte). The table-lookup approach computes one *byte* at a time using a precomputed 256-entry lookup table. **`makeTable` builds the table; `crc32` uses it.** This is the canonical *speed/space tradeoff* for CRC: 1 KiB of table (256 × 4 bytes signed) buys 8× speedup.

§the-1KB-table-IS-the-named-canonical-CRC-32-optimization. **§the-makeTable-and-crc32-pair-IS-a-named-shape**: a precomputation function + a per-call function, with the table cached at module-scope.

## §three-named-stops-in-the-`makeTable`-inner-loop (first-explicit-observation)

`makeTable`'s inner loop:
```javascript
for (let k = 0; k < 8; k += 1) {
  c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
}
```

Eight iterations per byte — *one iteration per bit*. The ternary `c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1` is **the CRC-32 polynomial division step in compact ternary form**. This is the **named bit-by-bit form** that the table replaces at runtime — `makeTable` runs the slow algorithm 256 times at startup so that `crc32` doesn't have to run it ever.

§the-startup-runs-the-slow-form-once-to-precompute-the-fast-form pattern. **§the-trade-IS-module-load-time-cost-for-runtime-savings** as named scope-of-optimization decision.

## §the-`return table;`-after-mutation-without-`harden` shape (first-explicit-observation in context)

`makeTable` returns a plain JS array without `harden`. The exported `crc32` function then closes over this mutable table. **§the-module-scope-mutable-private-state pattern**: a module-scoped variable that IS mutable in principle but is treated as immutable by convention. Compare cycle 132's eventual-send local.js patterns — the table here is *not* hardened, *not* explicitly frozen, but is private-by-module-scope.

§the-private-by-module-scope IS distinct from §the-private-by-WeakMap (cycle 191 noted WeakMap-private-fields in buffer-reader.js + buffer-writer.js). Two named private-state shapes in the same package: WeakMap (for class-instance fields) + module-scope-closure (for module-load-time tables). **§two-named-private-state-shapes-in-the-zip-cluster**.

## §the-eight-bit-shift-and-XOR-pattern as named CRC-32-update step (first-explicit-observation)

```javascript
crc = (crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xff];
```

This single statement IS the CRC-32 update step: shift the running CRC right by 8 bits, XOR with the table entry indexed by the low-byte of `(crc XOR current-byte)`. **§the-three-operations-in-one-statement**: shift + table-lookup + XOR. Compact, correct, and standard.

§the-pattern-IS-named-`(crc >> 8) ^ table[(crc ^ byte) & 0xff]` in every CRC-32 implementation; §the-form-IS-not-original-to-this-file-but-IS-the-canonical-shape.

## §the-loop-variable-`i`-vs-named-`k`-and-`n` (first-explicit-observation)

The outer loop in `makeTable` uses `n` (the byte being precomputed); the inner uses `k` (the bit position); `crc32` uses `i` (the buffer index). **Three named loop variables in two functions**, each with a *narrow scope*. §the-loop-variable-IS-named-by-the-domain-of-its-iteration (n=byte, k=bit, i=buffer-position).

§the-tradition-IS-mathematical-letters-NOT-`x, y, z`-or-`a, b, c`: `n` for natural-number byte, `k` for index, `i` for iteration. Inherited from the upstream pako attribution, but consistent with the C-style numerical-code tradition.

## §the-`+= 1` vs `++` increment idiom

Both loops use `n += 1` and `k += 1` instead of `n++` and `k++`. **§the-`+= 1` IS the ESLint-friendly idiom** (some ESLint configs disallow `++` because of subtle JS pre-vs-post-increment confusion). The pre-pasted file already conforms to this convention — likely *pako uses the same convention*, or the paste-in adapted it.

§the-`+= 1`-IS-canonical-across-the-zip-cluster (this file + buffer-reader + buffer-writer all use `+= 1`).

## §the-pre-pasted-code-conforms-to-the-host-project's-conventions (first-explicit-observation)

The file is pre-pasted from pako, but uses:
- `// @ts-check` directive (per project CLAUDE.md)
- `/* eslint no-bitwise: ["off"] */` (project ESLint convention)
- `+= 1` instead of `++` (project convention)
- JSDoc `@param` and `@returns` (project convention)

**The pre-paste was NOT a verbatim copy — it was adapted to project conventions.** §the-attribution-comment-does-NOT-mean-verbatim-paste; §the-named-adaptation-while-preserving-attribution discipline.

§the-paste-respects-the-host-conventions-while-citing-the-source — the file IS *both* "the same algorithm as pako's" AND "code that conforms to @endo's house style". The two claims are compatible because algorithmic essence is preserved while stylistic skin is replaced.

## §the-pako-attribution-IS-second-cycle-in-the-cluster (first-explicit-observation)

Cycle 191's cluster ingest noted §pre-pasted-pako-crc32-with-attribution-comment. This per-file ingest is the **second cycle naming the same attribution** in the zip cluster. The pako reference IS the SECOND named external-project attribution in the cluster (alongside the project's own internal references).

§two-cycles-with-pako-attribution-in-the-zip-cluster (191 cluster + 286 per-file). §the-pre-pasted-pako-shape-IS-named-borrowed-substrate.

## Patterns from prior cycles, reaffirmed

- **§the-`// @ts-check`-directive** (cycle 273 project CLAUDE.md observation; reaffirmed in cycles 278 + 280 + 282 + 284 + 286 — now six cycles for the zip cluster).
- **§five-cycles-with-named-eslint-directive-as-acknowledged-exception** (245 + 254 + 276 + 278 + 286).
- **§the-`+= 1` increment idiom** (cycle 191 cluster + many other cycles in @endo source).
- **§the-binary-format-magic-numbers** (cycle 278's signature.js noted `PK` historic-magic-prefix; this file's `0xedb88320` is a different kind of magic number — *algorithm constant*, not *format identifier*).
- **§two-named-magic-number-kinds-in-the-zip-cluster**: format-identifiers (cycle 278's PK + ZIP64) + algorithm-constants (cycle 286's IEEE 802.3 polynomial). §the-magic-numbers-have-named-categories.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §pre-pasted-from-pako-with-attribution-comment + §the-attribution-comment-as-named-borrowed-code-discipline + §the-`// Use ordinary array, since untyped makes no boost here` comment + §the-magic-number-`0xedb88320` + §the-reversed-polynomial-form-IS-the-named-standard + §the-table-initialized-at-module-load + §module-load-time-initialization-as-named-optimization-shape + §the-incremental-CRC-API-via-default-parameters + §the-default-parameters-make-the-streaming-and-non-streaming-API-the-same-function + §the-`>>> 0`-unsigned-coercion + §the-double-XOR-with-`-1`-as-named-CRC32-finalization + §the-table-lookup-IS-the-named-optimization-vs-bit-by-bit + §three-named-stops-in-the-`makeTable`-inner-loop + §the-startup-runs-the-slow-form-once-to-precompute-the-fast-form + §the-`return table;`-after-mutation-without-`harden` + §the-private-by-module-scope-IS-distinct-from-private-by-WeakMap + §the-eight-bit-shift-and-XOR-pattern + §the-loop-variable-IS-named-by-the-domain-of-its-iteration + §the-pre-pasted-code-conforms-to-the-host-project's-conventions + §the-named-adaptation-while-preserving-attribution + §the-pako-attribution-IS-second-cycle-in-the-cluster.
- **Tier 2 (clear analogue, named-shape)**: §the-`-1`-as-bitmask-IS-JS-specific-shorthand + §the-1KB-table-IS-the-named-canonical-CRC-32-optimization + §the-makeTable-and-crc32-pair-IS-a-named-shape + §the-`+= 1`-IS-canonical-across-the-zip-cluster + §two-named-private-state-shapes-in-the-zip-cluster (WeakMap + module-scope-closure) + §two-named-magic-number-kinds-in-the-zip-cluster (format-identifier + algorithm-constant).
- **Tier 3 (multi-cycle pattern recognition)**: §five-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278 + 286) + §six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster (191 + 278 + 280 + 282 + 284 + 286) + §two-cycles-with-pako-attribution-in-the-zip-cluster (191 cluster + 286 per-file) + §the-zip-cluster-source-file-deep-ingest-progresses (signature + writer + types + reader + crc32 = 5 of 12 files now deeply ingested per-file).

## Synthesis target

Slot machine library `@game/replay/src/checksum.js`: pre-pasted CRC-32 (or similar checksum algorithm like Fletcher-16 or Adler-32) with explicit attribution comment naming the upstream source and license; `// Use ordinary array, since untyped makes no boost here` explanatory comment justifying data-structure choice; file-scope `/* eslint no-bitwise: ["off"] */` exception; algorithm constant (the polynomial) as named magic number distinct from game-format magic numbers; table-initialized-at-module-load; incremental checksum API via default parameters (`length = bytes.length, index = 0, checksum = 0`) letting the caller stream chunk-by-chunk; `>>> 0` unsigned-coercion for the final result; double-XOR-with-`-1` finalization sequence; `makeTable` + `checksum` pair pattern with `n`-by-byte, `k`-by-bit, `i`-by-buffer-position loop variables. The pre-paste discipline: cite upstream source verbatim, *adapt* to project house style (`+= 1`, JSDoc, `// @ts-check`).

## Single most structurally interesting move

**§the-pre-pasted-code-conforms-to-the-host-project's-conventions** while **§the-attribution-comment-remains-intact** — the file demonstrates a *named two-layer borrowing discipline*: the algorithm (essence) IS preserved verbatim from pako; the syntactic skin (style) IS replaced with @endo's house conventions. The attribution comment tells the reader where the algorithm came from AND implicitly licenses the inevitable house-style adaptation. **The borrowed code IS pure substance + replaced skin** — a discipline that:

1. Honors the upstream license (the algorithm is the licensed thing; the syntactic skin is not).
2. Keeps the borrowed code maintainable by future @endo contributors (who can rely on `// @ts-check`, `+= 1`, JSDoc conventions).
3. Makes the borrow auditable (a reviewer can compare the algorithm against pako's source).

This is **§the-borrowed-substance-replaced-skin-discipline** — a named pattern for code reuse that respects both the upstream and the downstream's conventions. The pattern generalizes: any codebase that pastes-in a canonical algorithm can preserve attribution while adapting style.
