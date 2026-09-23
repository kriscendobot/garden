---
title: Synthesis target
section-slug: endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop
source-slug: endo--packages-zip-src-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/reader.js
total-lines: 60
ingest-cycle: 284
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop
---

Slot machine library `@game/replay/src/reader.js`: a `ReplayReader` sync class wrapping a Map of player-action-records + a `readReplay` async-adapter that narrows to `{ read }` for the recorded-game-event consumer; constructor takes `(data, options)` where `options.name` defaults to `'<unknown>'`; `read(eventName)` throws on missing event with both-names error; `stat(eventName)` returns optional `EventStat=` (deliberately omits the event payload, only metadata); the async adapter type-annotates the read function with `/** @type {ReadFn} */` to bind to the typedef shape; `// @ts-check` on the file; both inline `import('./types.js').X` types (deviating from project preference for `@import`) and any necessary import rename to avoid collision with `format-reader.js`'s `readReplay`.
