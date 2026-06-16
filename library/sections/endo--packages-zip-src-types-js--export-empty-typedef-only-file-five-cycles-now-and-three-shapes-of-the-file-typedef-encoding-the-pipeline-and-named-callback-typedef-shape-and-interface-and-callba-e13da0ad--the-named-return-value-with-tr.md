---
title: §The named return value with trailing identifier — `Promise<Uint8Array> bytes`
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
parent: endo--packages-zip-src-types-js--export-empty-typedef-only-file-five-cycles-now-and-three-shapes-of-the-file-typedef-encoding-the-pipeline-and-named-callback-typedef-shape-and-interface-and-callback-pair-and-closes-the-typedef-loop-with-cycle-280
---

Line 57: `@returns {Promise<Uint8Array>} bytes`

§First-explicit-observation in library: **§named-return-value-in-JSDoc-with-trailing-identifier — §the-`@returns`-tag-can-carry-a-name-after-the-type + §the-name-IS-documentation-only-not-required + §the-discipline-IS-explicit-naming-of-the-returned-value-for-readability**.

§Sibling-pattern to many JSDoc-heavy codebases that name the return value for readability; §the-name-`bytes`-IS-the-mnemonic-shorthand.

§Note that only one of the three callbacks uses the named return form — `ReadFn` does, `WriteFn` and `SnapshotFn` don't; §the-discipline-IS-applied-where-the-return-value-IS-the-primary-information + §`Promise<void>`-needs-no-name (void IS its own answer).
