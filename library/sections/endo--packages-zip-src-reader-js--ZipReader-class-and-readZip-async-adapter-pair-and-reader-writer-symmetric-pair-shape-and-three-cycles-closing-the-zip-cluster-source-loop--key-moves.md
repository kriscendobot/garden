---
title: Key moves
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

- **§reader-writer-symmetric-pair-shape** (first-explicit-observation): the reader file mirrors the writer file structurally — class + async-adapter-factory — but with markedly asymmetric line counts (264 writer vs 60 reader). The asymmetry reflects the **inherent asymmetry of the underlying task**: writing tracks state (crc32, compression, header chunking), reading delegates to a single format-reader call.
- **§three-cycles-closing-the-zip-cluster-source-loop** (first-explicit-observation): cycle 280 (writer.js — producer of ArchiveWriter, WriteFn, SnapshotFn) + cycle 282 (types.js — definer of all typedefs) + cycle 284 (reader.js — consumer of ArchivedStat, ArchiveReader, ReadFn).
- **§seven-cycles-with-closing-an-importer-and-producer-loop** (extends prior six-cycle pattern): 263+273 fragment-references-the-referenced-doc + 268+270 constructor-validator-pair + 280+282 consumer-producer-pair + 280+282+284 three-file-cluster.
- **§the-class-exposes-stat-but-the-async-adapter-only-exposes-read shape** (first-explicit-observation): `ZipReader` exposes both `read(name)` and `stat(name)`; `readZip` returns only `{ read }`. **The async-adapter narrows the interface deliberately**, matching the `ArchiveReader` typedef which is named for the minimal read-only surface.
- **§the-`@type` inline JSDoc on a local const as named type-cast shape** (first-explicit-observation): `/** @type {import('./types.js').ReadFn} */ const read = async path => reader.read(path);` — *casts the arrow function to the named callback typedef*. This is **§named-conformance-tag at the binding site**.
- **§the-inline-`import('./types.js').X`-form vs `@import`-at-top form** (first-explicit-observation): reader.js uses *inline* `import('./types.js').X` in JSDoc annotations (not the `@import` directive at the top of the file). **The project's own CLAUDE.md prefers `@import`** — but this file deviates from that preference. §convention-deviation-within-same-package; §two-import-style-shapes-in-one-cluster (writer.js used `@import` per cycle 280's observation; reader.js does not).
- **§the-`<unknown>`-default-value-as-named-sentinel** (first-explicit-observation): `const { name = '<unknown>' } = options;` — the default value `'<unknown>'` is *itself a named sentinel string with angle-bracket convention*, distinct from the typical defaults of `undefined`, `''`, or `null`. The angle brackets are a convention naming "this is a placeholder, not a real name".
- **§the-`@ts-expect-error` with named justification-in-comment** (first-explicit-observation): `// @ts-expect-error missing properties from ArrayBuffer` — the `@ts-expect-error` is *immediately followed by a justification phrase* on the same comment line. Compare cycle 132's similar pattern in the eventual-send local.js (§justified-`@ts-expect-error`).
- **§the-`get`-returns-undefined-into-named-not-found shape**: `const file = this.files.get(name); if (file === undefined) { throw Error(...) }` — read throws on missing; stat returns undefined on missing. **Two named missing-behaviors in one class** for the same underlying Map lookup. §two-named-missing-behaviors-by-method (read=throw, stat=undefined-return).
- **§the-`Error()`-without-`new`-shorthand** (cycle 280 observation reaffirmed): `throw Error(\`Cannot find file ${name} in Zip file ${this.name}\`)`.
- **§template-literal-error-message-with-two-named-interpolations** (the missing file name + the archive name): `Cannot find file ${name} in Zip file ${this.name}`. The error message names *both* the missing item AND the container it was not found in — better debugging than the typical one-name message.
- **§the-`async path => reader.read(path)`-as-named-sync-to-async-adapter shape**: a one-line arrow function that takes a sync method and returns a Promise — the same `the-sync-class-wrapped-by-async-adapter-pattern` (cycle 280's first-explicit-observation) instantiated at minimal expression.
- **§the-`@returns {import('./types.js').ArchivedStat=}`-shape with named-optional-marker** (the `=` suffix in JSDoc means optional/undefined-return). Cycle 282 noted the `Date?` syntax for optional fields; the `T=` syntax here is the same family — **§the-`=`-suffix-as-named-optional-return-marker**. §two-named-JSDoc-optional-markers (`Date?` postfix-question-mark for nullable + `T=` postfix-equals for optional-undefined-return).
