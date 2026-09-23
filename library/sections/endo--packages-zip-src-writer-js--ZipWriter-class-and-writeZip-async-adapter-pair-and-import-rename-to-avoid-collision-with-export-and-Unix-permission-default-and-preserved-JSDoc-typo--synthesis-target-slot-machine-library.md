---
title: §Synthesis target — slot machine library
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

§The-class-and-async-adapter-pair applies to the §game-engine-cluster:

- §**`GameStateWriter`** class (sync mutable, like ZipWriter) — accumulates state via `write()` + produces `snapshot()` as bytes.
- §**`writeGameState()`** async-adapter factory wrapping the class — returns `{ write, snapshot }` with async signatures.
- §**§the-Map-for-game-states** preserves insertion order.
- §**§the-`0o644`-permission-default** for game-state files.
- §**§named options** with explicit-undefined defaults for the optional fields.
- §**§import-rename to avoid collision** when the internal function and the public factory share a name.
