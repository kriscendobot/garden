---
title: §The async Promise-returning typedef pair
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

Both `ReadFn` and `SnapshotFn` return `Promise<Uint8Array>` — §the-Uint8Array-IS-the-payload-type-on-both-the-read-and-snapshot-paths; §sibling-pattern to many Node Buffer-handling APIs.

§the-`Promise<Uint8Array>`-and-`Promise<void>`-pair — §the-three-callbacks-encode-the-async-protocol-with-two-return-payload-shapes (bytes-or-void); §sibling-pattern to many cluster-conventions where the async-API has named return shapes.
