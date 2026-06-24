---
title: §The `@callback` shape — distinct from `@typedef object`
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
