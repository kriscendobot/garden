---
title: §Three named typedefs imported for typing the thin wrapper
source-slug: endo--packages-zip-src-writer-js
section-slug: ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
source-repo: endojs/endo
source-path: packages/zip/src/writer.js
source-author: Endo project (collective)
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
---

Lines 53, 57, 61 carry §three-named-typedef-imports-via-JSDoc-from-types.js:

- `import('./types.js').ArchiveWriter` — the abstract-interface-typedef returned by `writeZip()`.
- `import('./types.js').WriteFn` — the type of the `write` method.
- `import('./types.js').SnapshotFn` — the type of the `snapshot` method.

§First-explicit-observation in library: **§three-named-typedefs-imported-for-typing-the-thin-wrapper — §each-of-the-three-elements-of-the-returned-object-has-its-own-named-typedef + §the-discipline-IS-per-method-typedef-naming + §sibling-pattern to TypeScript's `interface ArchiveWriter { write: WriteFn; snapshot: SnapshotFn; }` discipline applied in JSDoc**.

§Sibling-pattern to cycle 264's `confirmPassStyle` JSDoc-block-with-multiple-typedefs (cycle 266's metalanguage observation); §the-cluster-uses-per-method-typedef-naming-where-the-method-IS-non-trivial.
