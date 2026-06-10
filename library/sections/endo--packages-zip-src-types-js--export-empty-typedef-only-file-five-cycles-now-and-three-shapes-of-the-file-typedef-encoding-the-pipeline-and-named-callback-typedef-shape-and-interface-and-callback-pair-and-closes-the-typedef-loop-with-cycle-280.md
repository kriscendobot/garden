---
title: "@endo/zip/src/types.js — `export {};` typedef-only file (5th cycle) + three shapes of the file typedef encoding the pipeline + named @callback typedef shape + interface-and-callback pair + closes the typedef loop with cycle 280's writer.js"
source-slug: endo--packages-zip-src-types-js
section-slug: export-empty-typedef-only-file-five-cycles-now-and-three-shapes-of-the-file-typedef-encoding-the-pipeline-and-named-callback-typedef-shape-and-interface-and-callback-pair-and-closes-the-typedef-loop-with-cycle-280
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/types.js
source-repo: endojs/endo
source-path: packages/zip/src/types.js
source-author: Endo project (collective)
total-lines: 76
ingest-cycle: 282
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/types.js` — typedefs for the zip cluster + closes the typedef loop with cycle 280

A 76-line `export {};` typedef-only file that defines the zip package's typedef vocabulary. **Closes the typedef-import loop with cycle 280's `writer.js`** — that file imported `ArchiveWriter` + `WriteFn` + `SnapshotFn` from this types.js; cycle 282 ingests the producer.

§First-explicit-observation in library: **§closing-the-typedef-import-loop — §cycle-280's-writer.js-imported-three-typedefs-from-this-types.js + §cycle-282-ingests-the-producer-of-those-typedefs + §the-two-ingests-form-an-importer-and-producer-pair**.

§Three-cycles-with-closing-an-importer-and-producer-loop:
1. **Cycle 263 + 273** — outliner-design-doc-2 fragment (references) + OUTLINER_INTERACTION_PATTERNS guide (the referenced doc).
2. **Cycle 268 + 270** — TaggedHelper validator + makeTagged constructor (constructor-validator pair).
3. **Cycle 280 + 282** — writer.js consumer + types.js producer (consumer-producer pair).

§First-explicit-observation in library: **§three-cycles-with-closing-an-importer-and-producer-loop — §each-cycle-pair-IS-a-different-kind-of-relationship (references + constructor-validator + consumer-producer) + §the-cycles-ARE-the-explicit-record-of-the-relationship**.

## §`export {};` typedef-only file pattern — five cycles now

Line 3: `export {};` — the typedef-only file marker.

§Five-cycles-with-`export {};`-typedef-only-file-pattern now (254 no-shim + 256 promise-kit types + 258 far exports + 266 internal-types + 282 zip types); §the-discipline-now-reified-across-five-cycles.

§First-explicit-observation in library: **§five-cycles-with-`export {};`-typedef-only-file-pattern — §the-discipline-IS-now-canonical-across-five-instances + §sibling-pattern to many TypeScript declaration-only files**.

§The-`// @ts-check`-directive (line 1) carries forward from cycle 278's observation; §sibling-pattern with cycle 278's zip signature.js — §the-zip-cluster-uses-the-`// @ts-check`-directive-on-every-file.

## §Three shapes of the file typedef encoding the pipeline

Lines 6-36 define §three-shape-versions-of-the-conceptual-file:

1. **`ArchivedFile`** (the input/output shape) — `name: string` + `content: Uint8Array` + ArchivedStat fields.
2. **`UncompressedFile`** (the on-the-wire pre-compression shape) — `name: Uint8Array` (binary) + `content: Uint8Array` + binary `comment`.
3. **`CompressedFile`** (the on-the-wire compressed shape) — `name: Uint8Array` + `crc32: number` + `compressionMethod: number` + `compressedLength: number` + `uncompressedLength: number` + `content: Uint8Array` + `comment: Uint8Array`.

§First-explicit-observation in library: **§three-shapes-of-the-file-typedef-encoding-the-pipeline — §input-shape (string name + ArchivedStat metadata) + §uncompressed-wire-shape (Uint8Array name + content) + §compressed-wire-shape (Uint8Array name + content + crc32 + compression metadata) + §each-shape-encodes-a-stage-of-the-pipeline**.

§The-conceptual-shift-from-string-to-Uint8Array — §the-input-shape-uses-`string`-for-name + §the-wire-shapes-use-`Uint8Array` because the ZIP format stores names as bytes; §the-shape-distinction-encodes-the-format-boundary.

§Sibling-pattern to many serialization-format types where input + wire + compressed-wire shapes are distinct.

## §The intersection-type syntax in JSDoc typedef

Line 16: `} & ArchivedStat} ArchivedFile`

§First-explicit-observation in library: **§the-intersection-type-syntax-in-JSDoc-typedef — §JSDoc-supports-TypeScript's-`&`-intersection-type + §the-syntax-IS-`{...newFields} & BaseType` + §the-discipline-IS-mixin-via-intersection**.

§Sibling-pattern to TypeScript's `interface ArchivedFile extends ArchivedStat` discipline; §the-JSDoc-form-IS-explicit-intersection + §the-TypeScript-form-IS-implicit-extends; §two-named-mixin-syntaxes-for-the-same-conceptual-shape.

## §The `Date?` syntax as named optional-or-nullable marker

Lines 8, 21, 29, 42 carry `date: Date?` — TypeScript-style `?` suffix for optional/nullable.

§First-explicit-observation in library: **§the-`Date?`-syntax-as-named-optional-or-nullable-marker — §the-`?`-suffix-IS-the-optional-marker + §sibling-pattern to TypeScript's `Date | null | undefined` shorthand + §the-discipline-IS-a-short-form-for-the-optional-shape**.

§Note: TypeScript itself does NOT support the `?` suffix as a type modifier (only on parameters or properties); the JSDoc here uses a non-canonical shorthand that the JSDoc-to-TypeScript adapter understands.

§The-Date?-IS-not-standard-TypeScript-syntax + §the-JSDoc-form-IS-the-cluster's-accepted-shorthand; §sibling-pattern to many JSDoc dialects' optional markers.

## §The string-literal-union typedef

Line 10: `type: "file" | "directory"` — TypeScript-style string-literal-union.

§First-explicit-observation in library: **§the-string-literal-union-typedef-as-named-enum-shape — §the-`"file" | "directory"`-IS-the-named-enum + §sibling-pattern to many TypeScript enum-via-union patterns + §the-discipline-IS-narrow-string-typing-not-bare-`string`**.

§The-two-named-types ("file" + "directory") — §two-element-enum-as-named-binary-choice; §sibling-pattern to many systems' file-or-directory distinction.

## §Two named typedef-block styles

Lines 5-47 carry §a-multi-typedef-block — one `/** ... */` containing five typedefs (ArchivedStat + ArchivedFile + UncompressedFile + CompressedFile + ArchiveHeaders).

Lines 49-76 carry §three-single-typedef-blocks — each `/** @typedef ... */` defines one typedef (ArchiveReader + ReadFn + ArchiveWriter + WriteFn + SnapshotFn).

§First-explicit-observation in library: **§two-named-typedef-block-styles — §multi-typedef-block-style (one comment containing many typedefs) + §single-typedef-block-style (one typedef per comment) + §the-file-uses-both + §the-discipline-IS-group-related-data-typedefs-together-and-give-each-callback-typedef-its-own-comment**.

§Sibling-pattern to many JSDoc-heavy codebases where the choice between block styles signals relatedness.

## §The `@callback` shape — distinct from `@typedef object`

Lines 54-58, 66-71, 73-76 carry §three-named-`@callback`-typedefs:

```js
/**
 * @callback ReadFn
 * @param {string} name
 * @returns {Promise<Uint8Array>} bytes
 */

/**
 * @callback WriteFn
 * @param {string} name
 * @param {Uint8Array} bytes
 * @returns {Promise<void>}
 */

/**
 * @callback SnapshotFn
 * @returns {Promise<Uint8Array>}
 */
```

§First-explicit-observation in library: **§the-`@callback`-shape-IS-distinct-from-`@typedef-object`-shape — §`@callback`-IS-for-function-typedefs + §`@typedef object`-IS-for-data-typedefs + §the-two-shapes-coexist-in-one-file**.

§Two-named-typedef-kinds-in-JSDoc: §`@callback` (function-typedefs) + §`@typedef object` (data-typedefs + interface-typedefs).

§First-explicit-observation in library: **§two-named-typedef-kinds-in-JSDoc-paired-for-interface-definition — §the-interface-typedef-references-the-callback-typedefs-by-name (e.g., `ArchiveWriter` has `write: WriteFn`)**.

## §The interface-and-callback pair shape

Lines 50-58 carry §the-interface-and-callback-pair-for-ArchiveReader:
- **`ArchiveReader`** (interface; `@typedef object`) — `{ read: ReadFn }`.
- **`ReadFn`** (function; `@callback`) — `(name: string) => Promise<Uint8Array>`.

Lines 61-76 carry the §interface-and-callback-pair-for-ArchiveWriter:
- **`ArchiveWriter`** (interface) — `{ write: WriteFn, snapshot: SnapshotFn }`.
- **`WriteFn`** (function) — `(name, bytes) => Promise<void>`.
- **`SnapshotFn`** (function) — `() => Promise<Uint8Array>`.

§First-explicit-observation in library: **§the-interface-and-callback-pair-shape — §the-interface-typedef-references-named-callback-typedefs + §the-callback-typedefs-are-named-and-defined-separately + §the-discipline-IS-named-method-types-not-inline-function-types**.

§Sibling-pattern to TypeScript's `interface ArchiveWriter { write: WriteFn; snapshot: SnapshotFn; }` discipline applied in JSDoc.

§Three-cycles-with-closing-the-typedef-import-loop (263+273 + 268+270 + 280+282); §the-loop-closure-IS-an-emerging-meta-pattern (cycle 270's observation now confirmed across three pair-types).

## §The named return value with trailing identifier — `Promise<Uint8Array> bytes`

Line 57: `@returns {Promise<Uint8Array>} bytes`

§First-explicit-observation in library: **§named-return-value-in-JSDoc-with-trailing-identifier — §the-`@returns`-tag-can-carry-a-name-after-the-type + §the-name-IS-documentation-only-not-required + §the-discipline-IS-explicit-naming-of-the-returned-value-for-readability**.

§Sibling-pattern to many JSDoc-heavy codebases that name the return value for readability; §the-name-`bytes`-IS-the-mnemonic-shorthand.

§Note that only one of the three callbacks uses the named return form — `ReadFn` does, `WriteFn` and `SnapshotFn` don't; §the-discipline-IS-applied-where-the-return-value-IS-the-primary-information + §`Promise<void>`-needs-no-name (void IS its own answer).

## §The async Promise-returning typedef pair

Both `ReadFn` and `SnapshotFn` return `Promise<Uint8Array>` — §the-Uint8Array-IS-the-payload-type-on-both-the-read-and-snapshot-paths; §sibling-pattern to many Node Buffer-handling APIs.

§the-`Promise<Uint8Array>`-and-`Promise<void>`-pair — §the-three-callbacks-encode-the-async-protocol-with-two-return-payload-shapes (bytes-or-void); §sibling-pattern to many cluster-conventions where the async-API has named return shapes.

## §Cycle 282 first-explicit-observations roundup (twelve)

1. §closing-the-typedef-import-loop (cycle 280's writer.js + cycle 282's types.js).
2. §three-cycles-with-closing-an-importer-and-producer-loop (263+273 + 268+270 + 280+282).
3. §five-cycles-with-`export {};`-typedef-only-file-pattern (254 + 256 + 258 + 266 + 282).
4. §three-shapes-of-the-file-typedef-encoding-the-pipeline (input + uncompressed-wire + compressed-wire).
5. §the-intersection-type-syntax-in-JSDoc-typedef.
6. §the-`Date?`-syntax-as-named-optional-or-nullable-marker.
7. §the-string-literal-union-typedef-as-named-enum-shape.
8. §two-named-typedef-block-styles (multi-typedef-block + single-typedef-block).
9. §the-`@callback`-shape-IS-distinct-from-`@typedef-object`-shape.
10. §two-named-typedef-kinds-in-JSDoc-paired-for-interface-definition.
11. §the-interface-and-callback-pair-shape.
12. §named-return-value-in-JSDoc-with-trailing-identifier.

## §Recurring meta-pattern counters bumped at cycle 282

- §**five-cycles-with-`export {};`-typedef-only-file-pattern** (254 + 256 + 258 + 266 + 282).
- §**three-cycles-with-closing-an-importer-and-producer-loop** (263+273 + 268+270 + 280+282).
- §**one-hundred-and-fifteenth consecutive designs-chat alternation cycles 166-250 + 252-282** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-typedef-cluster-vocabulary applies to the §game-engine-cluster:

- §**`@game/replay/src/types.js`** — `export {};` typedef-only file for the game-replay vocabulary.
- §**§three shapes of the game-event typedef encoding the pipeline** — input-shape (string name + game-state metadata) + uncompressed-wire-shape (Uint8Array name + content) + compressed-wire-shape (with crc32 + compression metadata).
- §**§the-intersection-type-syntax** for game-event mixins.
- §**§the-string-literal-union-typedef** for game-event types ("game-start" | "game-end" | "bet").
- §**§two-named-typedef-block-styles** in one file (multi for related data; single per callback).
- §**§the-`@callback`-shape** for function-typedefs vs `@typedef object` for data-typedefs.
- §**§the-interface-and-callback-pair-shape** — `GameReader` interface with `read: GameReadFn` callback.

## §Tier-1 borrowing

§closing-the-typedef-import-loop + §three-cycles-with-closing-an-importer-and-producer-loop + §five-cycles-with-`export {};`-typedef-only-file-pattern + §three-shapes-of-the-file-typedef-encoding-the-pipeline + §the-intersection-type-syntax-in-JSDoc-typedef + §the-`Date?`-syntax-as-named-optional-or-nullable-marker + §the-string-literal-union-typedef-as-named-enum-shape + §two-named-typedef-block-styles + §the-`@callback`-shape-IS-distinct-from-`@typedef-object`-shape + §two-named-typedef-kinds-in-JSDoc-paired-for-interface-definition + §the-interface-and-callback-pair-shape + §named-return-value-in-JSDoc-with-trailing-identifier.

## §Tier-2 borrowing

§the-conceptual-shift-from-string-to-Uint8Array (input shape vs wire shape) + §the-`Promise<Uint8Array>`-and-`Promise<void>`-pair-as-named-async-return-shape + §the-zip-cluster-uses-the-`// @ts-check`-directive-on-every-file.

## §Tier-3 borrowing

§five-cycles-with-`export {};`-typedef-only-file-pattern + §library-reaches-788-sections at cycle 282 + §one-hundred-and-fifteenth consecutive designs-chat alternation cycles 166-250 + 252-282.

## Pattern summary (tag-prefixed)

§closing-the-typedef-import-loop (cycle 280 writer.js + cycle 282 types.js) + §three-cycles-with-closing-an-importer-and-producer-loop (263+273 references-and-referenced-doc + 268+270 constructor-validator + 280+282 consumer-producer) + §five-cycles-with-`export {};`-typedef-only-file-pattern (254 + 256 + 258 + 266 + 282) + §three-shapes-of-the-file-typedef-encoding-the-pipeline (input + uncompressed-wire + compressed-wire) + §the-conceptual-shift-from-string-to-Uint8Array + §the-intersection-type-syntax-in-JSDoc-typedef + §the-`Date?`-syntax-as-named-optional-or-nullable-marker + §the-string-literal-union-typedef-as-named-enum-shape + §two-named-typedef-block-styles (multi + single) + §the-`@callback`-shape-IS-distinct-from-`@typedef-object`-shape + §two-named-typedef-kinds-in-JSDoc-paired-for-interface-definition + §the-interface-and-callback-pair-shape + §named-return-value-in-JSDoc-with-trailing-identifier + §the-`Promise<Uint8Array>`-and-`Promise<void>`-pair-as-named-async-return-shape.
