---
title: "`@endo/zip/src/writer.js` — the class-and-async-adapter pair"
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

A 64-line file that exports the `ZipWriter` class **paired with** the `writeZip()` async-adapter factory function. The pair instantiates a named structural shape: a synchronous-mutable class plus a thin async adapter that wraps the class behind a deferred-not-truly-async API.

§First-explicit-observation in library: **§the-class-and-async-adapter-pair-as-named-discipline — §a-synchronous-mutable-class (ZipWriter) + §an-async-adapter-factory (writeZip) wrapping the class + §the-async-wrapper's-body-IS-sync (`await` would be a no-op) + §the-abstraction-lets-future-implementations-be-truly-async-if-needed**.

§Sibling-pattern to cycle 276's platform-bound-bootstrap + powers-injected-factory pair — but here the pair is class + async-adapter rather than bootstrap + factory; §two-named-paired-file-shapes in the @endo cluster: §bootstrap-and-factory-pair (276) + §class-and-async-adapter-pair (280).
