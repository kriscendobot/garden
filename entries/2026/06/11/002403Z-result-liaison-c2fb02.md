---
ts: 2026-06-11T00:24:03Z
kind: result
role: liaison
dispatch: c2fb02
host: endolin
model: opus-4-7-1m
---

# librarian cycle 286 — chat-lane — `@endo/zip/src/crc32.js`

Cycle 286 (chat-lane after cycle 285's designs-lane OUTLINER_INTERACTION_PATTERNS second-pass). One source ingested: `@endo/zip/src/crc32.js` (48 lines). **Per-file deep ingest** of a file that was part of cycle 191's zip-cluster ingest at cluster-scope. Implements CRC-32 (IEEE 802.3) via the standard table-lookup approach, **pre-pasted from pako** with **explicit attribution comment** at the top.

## Library state

- 792 sections (up from 791 at cycle 285).
- 332 source documents (up from 331; new per-file source page added).
- §one-hundred-and-nineteenth consecutive designs-chat alternation cycles 166-250 + 252-286 (251 was out-of-band).

## Files written

- `library/sections/endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters.md` (new section file; 48-line file in full scope).
- `library/sources/endo--packages-zip-src-crc32-js.md` (new source page).
- `library/sections/README.md` (Total bumped 791 → 792; sources 331 → 332; new entry added).
- `library/sources/README.md` (new row inserted above cycle 284's @endo/zip/src/reader.js row).
- `library/keywords.md` (new keyword entries + 21 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-285` → `pending-cycle-286`).

## First-explicit-observations (twenty-one)

1. **§pre-pasted-from-pako-with-attribution-comment** — four-line block comment naming upstream source + license + URL.
2. **§the-attribution-comment-as-named-borrowed-code-discipline** — inline at top of consuming file, not buried in LICENSE.
3. **§the-`// Use ordinary array, since untyped makes no boost here`-explanatory-comment**.
4. **§the-magic-number-`0xedb88320`-IS-the-IEEE-802.3-reversed-polynomial** — reflected form of `0x04C11DB7`.
5. **§the-table-initialized-at-module-load** — `const table = makeTable();`; module-load-time-initialization-as-named-optimization-shape.
6. **§the-incremental-CRC-API-via-default-parameters** — `crc32(bytes, length = bytes.length, index = 0, crc = 0)`; the-default-parameters-make-the-streaming-and-non-streaming-API-the-same-function.
7. **§the-`>>> 0`-unsigned-coercion** — JS-32-bit-unsigned-coercion idiom.
8. **§the-double-XOR-with-`-1`-as-named-CRC32-finalization** — `crc ^= -1` pre + `(crc ^ -1) >>> 0` post; the-`-1`-IS-the-named-all-ones-mask-in-JS-bitwise-context.
9. **§the-table-lookup-IS-the-named-optimization-vs-bit-by-bit** — 1 KiB table buys 8× speedup; the-makeTable-and-crc32-pair-IS-a-named-shape.
10. **§three-named-stops-in-the-`makeTable`-inner-loop** — eight iterations per byte; the-startup-runs-the-slow-form-once-to-precompute-the-fast-form.
11. **§the-`return table;`-after-mutation-without-`harden`** — module-scope mutable private state; the-private-by-module-scope IS distinct from the-private-by-WeakMap (cycle 191's buffer-reader/writer).
12. **§the-eight-bit-shift-and-XOR-pattern as named CRC-32-update step** — `(crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xff]`; three operations in one statement.
13. **§the-loop-variable-IS-named-by-the-domain-of-its-iteration** — `n` for natural-number byte + `k` for bit index + `i` for buffer position; the-tradition-IS-mathematical-letters.
14. **§the-pre-pasted-code-conforms-to-the-host-project's-conventions** — `// @ts-check` + `+= 1` + JSDoc + ESLint exception; the-named-adaptation-while-preserving-attribution-discipline.
15-21. **Compound observations** about the borrowed-substance-replaced-skin-discipline + the-attribution-comment-does-NOT-mean-verbatim-paste + the-explanatory-comment-IS-the-named-choice-justification + the-reversed-polynomial-form-IS-the-named-standard + the-256-table-lookup-with-`& 0xff`-byte-mask + the-`+= 1`-IS-canonical-across-the-zip-cluster + the-startup-runs-the-slow-form-once-to-precompute-the-fast-form.

## Multi-cycle pattern recognition

- **§two-cycles-with-pako-attribution-in-the-zip-cluster** (191 cluster + 286 per-file).
- **§two-named-private-state-shapes-in-the-zip-cluster** — WeakMap (cycle 191 buffer-reader/writer) + module-scope-closure (cycle 286 crc32).
- **§two-named-magic-number-kinds-in-the-zip-cluster** — format-identifier (cycle 278 `PK` + `ZIP64_`) + algorithm-constant (cycle 286 `0xedb88320`).
- **§six-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster** (191 + 278 + 280 + 282 + 284 + 286).
- **§five-cycles-with-named-eslint-directive-as-acknowledged-exception** (245 + 254 + 276 + 278 + 286).
- **§the-zip-cluster-source-file-deep-ingest-progresses** — 5 of 12 zip files now per-file ingested (signature 278 + writer 280 + types 282 + reader 284 + crc32 286).

## Synthesis target

Slot machine library `@game/replay/src/checksum.js`: pre-pasted CRC-32 (or Fletcher-16 or Adler-32) with explicit attribution comment naming upstream source + license + URL; `// Use ordinary array...` explanatory comment justifying data-structure choice; file-scope `/* eslint no-bitwise: ["off"] */` exception; algorithm constant as named magic number distinct from game-format magic numbers; table-initialized-at-module-load; incremental checksum API via default parameters letting the caller stream chunk-by-chunk; `>>> 0` unsigned-coercion; double-XOR-with-`-1` finalization sequence; `makeTable` + `checksum` pair with `n`/`k`/`i` loop variables; the pre-paste discipline cites upstream source verbatim AND adapts to project house style.

## Single most structurally interesting move

**§the-pre-pasted-code-conforms-to-the-host-project's-conventions while §the-attribution-comment-remains-intact** — a named two-layer borrowing discipline. The algorithm (essence) IS preserved verbatim from pako; the syntactic skin (style) IS replaced with @endo's house conventions (`// @ts-check` + `+= 1` + JSDoc + `/* eslint no-bitwise: ["off"] */`). The attribution comment tells the reader where the algorithm came from AND implicitly licenses the inevitable house-style adaptation. **The borrowed code IS pure substance + replaced skin** — a discipline that honors the upstream license (the algorithm is the licensed thing; the syntactic skin is not), keeps the borrowed code maintainable by future @endo contributors, and makes the borrow auditable. The pattern generalizes: any codebase that pastes-in a canonical algorithm can preserve attribution while adapting style. §the-borrowed-substance-replaced-skin-discipline.

## Next cycle

Cycle 287 — designs-lane next.
