---
title: "@endo/zip/src/types.js — typedef vocabulary for the zip cluster"
source-slug: endo--packages-zip-src-types-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/types.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/types.js
total-lines: 76
ingest-cycle: 282
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/types.js`

A 76-line `export {};` typedef-only file that defines the zip package's typedef vocabulary. **Closes the typedef-import loop with cycle 280's `writer.js`** — that file imported `ArchiveWriter` + `WriteFn` + `SnapshotFn` from this types.js; cycle 282 ingests the producer.

## Key moves

- **§Closing the typedef-import loop** (cycle 280's writer.js consumer + cycle 282's types.js producer).
- **§Three cycles with closing an importer-and-producer loop** (263+273 fragment-references-the-referenced-doc + 268+270 constructor-validator-pair + 280+282 consumer-producer-pair).
- **§Five cycles with `export {};` typedef-only file pattern** (254 no-shim + 256 promise-kit types + 258 far exports + 266 internal-types + 282 zip types).
- **§Three shapes of the file typedef encoding the pipeline** — `ArchivedFile` (input; string name + content) + `UncompressedFile` (uncompressed wire; Uint8Array name + content) + `CompressedFile` (compressed wire; with crc32 + compressionMethod + compressed/uncompressed lengths).
- **§The conceptual shift from string to Uint8Array** between input shape and wire shapes.
- **§The intersection-type syntax in JSDoc typedef** — `{...newFields} & BaseType` as the mixin form.
- **§The `Date?` syntax as named optional-or-nullable marker** — non-standard TypeScript but accepted JSDoc shorthand for `Date | null | undefined`.
- **§The string-literal-union typedef as named enum shape** — `type: "file" | "directory"`.
- **§Two named typedef-block styles** — multi-typedef-block (one `/** ... */` containing many) + single-typedef-block (one per `/** ... */`); the file uses both.
- **§The `@callback` shape IS distinct from `@typedef object` shape** — `@callback` for function-typedefs; `@typedef object` for data-typedefs + interface-typedefs.
- **§Two named typedef-kinds in JSDoc paired for interface definition** — the interface typedef references named callback typedefs.
- **§The interface-and-callback pair shape** — `ArchiveReader { read: ReadFn }` + separate `@callback ReadFn`.
- **§Named return value in JSDoc with trailing identifier** — `@returns {Promise<Uint8Array>} bytes`.

## Section files

- [§`export {};` typedef-only file (5th cycle) + §three shapes of the file typedef encoding the pipeline + §named `@callback` typedef shape + §interface-and-callback pair + §closes the typedef loop with cycle 280](../sections/endo--packages-zip-src-types-js--export-empty-typedef-only-file-five-cycles-now-and-three-shapes-of-the-file-typedef-encoding-the-pipeline-and-named-callback-typedef-shape-and-interface-and-callback-pair-and-closes-the-typedef-loop-with-cycle-280.md) — full 76-line file in scope.

## Ingest scope

Cycle 282 (chat-lane after cycle 281's designs-lane garden-driver-design). Full 76-line file ingested. **First-explicit-observations (twelve)**: closing-the-typedef-import-loop + three-cycles-with-closing-an-importer-and-producer-loop + five-cycles-with-`export {};`-typedef-only-file-pattern + three-shapes-of-the-file-typedef-encoding-the-pipeline + the-intersection-type-syntax-in-JSDoc-typedef + the-`Date?`-syntax-as-named-optional-or-nullable-marker + the-string-literal-union-typedef-as-named-enum-shape + two-named-typedef-block-styles + the-`@callback`-shape-IS-distinct-from-`@typedef-object`-shape + two-named-typedef-kinds-in-JSDoc-paired-for-interface-definition + the-interface-and-callback-pair-shape + named-return-value-in-JSDoc-with-trailing-identifier.
