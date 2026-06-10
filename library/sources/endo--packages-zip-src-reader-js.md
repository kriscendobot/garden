---
title: "@endo/zip/src/reader.js — ZipReader sync class + readZip async-adapter pair; reader-writer symmetric pair; closes the zip cluster source-file loop"
source-slug: endo--packages-zip-src-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/reader.js
total-lines: 60
ingest-cycle: 284
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/reader.js`

A 60-line file mirroring cycle 280's `writer.js` exactly in shape: a `ZipReader` sync mutable class + a `readZip` async-adapter factory that wraps it and returns an `ArchiveReader` interface. **Closes the zip cluster source-file loop**: cycle 280 writer + cycle 282 types + cycle 284 reader — three sibling files producing, declaring, and consuming the same typedef set.

## Key moves

- **§reader-writer-symmetric-pair-shape** — class + async-adapter-factory in each, with asymmetric line counts (264 writer vs 60 reader).
- **§three-cycles-closing-the-zip-cluster-source-loop** — 280 writer + 282 types + 284 reader.
- **§seven-cycles-with-closing-an-importer-and-producer-loop** (extends prior six-cycle pattern with the three-file-cluster shape).
- **§the-class-exposes-stat-but-the-async-adapter-only-exposes-read** — the async-adapter narrows the public interface deliberately; the `ArchiveReader` typedef names only `read`; `stat` is class-private convenience.
- **§the-`@type`-inline-JSDoc-on-a-local-const-as-named-type-cast-shape** — `/** @type {import('./types.js').ReadFn} */ const read = async path => reader.read(path);`.
- **§the-inline-`import('./types.js').X`-form-vs-`@import`-at-top form** — reader.js deviates from project CLAUDE.md preference; §two-import-style-shapes-in-one-cluster (writer.js used `@import` per cycle 280; reader.js uses inline).
- **§the-`<unknown>`-default-value-as-named-sentinel** — `name = '<unknown>'` with angle-bracket convention for placeholder.
- **§the-`@ts-expect-error`-with-named-justification-in-comment** — `// @ts-expect-error missing properties from ArrayBuffer`.
- **§the-`as`-rename-import-pattern** — `readZip as readZipFormat` resolves namespace collision; `Format`-suffix naming the narrower format-level shape.
- **§the-`location`-vs-`name`-parameter-naming-drift** — outer API uses domain term, inner class uses generic term; named-rename-at-the-API-boundary.
- **§the-error-message-naming-both-names** — `Cannot find file ${name} in Zip file ${this.name}` includes both missing item AND archive name.
- **§two-named-Map-lookup-then-act-shapes** — read throws on missing, stat returns undefined; the-presence-check-IS-the-API-branch.
- **§the-stat-shape-projecting-onto-typedef** — explicit four-field projection onto `ArchivedStat` (type + mode + date + comment); the-explicit-projection-shape; the-projection-IS-the-conformance-act.
- **§the-content-field-is-deliberately-not-in-stat** — extends §confinement-by-omission to API design (235 + 238 + 259 + 284).
- **§the-Map-lookup-IS-the-shared-mechanism** — the class IS essentially a named Map with an archive label.

## Section files

- [§ZipReader class + readZip async-adapter pair + §reader-writer-symmetric-pair-shape + §three-cycles-closing-the-zip-cluster-source-loop + 11 more first-explicit-observations](../sections/endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop.md) — full 60-line file in scope.

## Ingest scope

Cycle 284 (chat-lane after cycle 283 designs-lane endo-gateway). Full 60-line file in scope. **First-explicit-observations (fourteen)**: reader-writer-symmetric-pair-shape + three-cycles-closing-the-zip-cluster-source-loop + the-class-exposes-stat-but-the-async-adapter-only-exposes-read + the-`@type`-inline-JSDoc-on-a-local-const + the-inline-`import('./types.js').X`-form-vs-`@import`-form (convention-deviation) + the-`<unknown>`-default-value-as-named-sentinel + the-`@ts-expect-error`-with-named-justification-in-comment + the-`as`-rename-import-pattern + the-`location`-vs-`name`-parameter-naming-drift + the-error-message-naming-both-names + two-named-Map-lookup-then-act-shapes + the-stat-shape-projecting-onto-typedef + the-content-field-is-deliberately-not-in-stat + the-Map-lookup-IS-the-shared-mechanism.
