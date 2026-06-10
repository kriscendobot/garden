---
title: "@endo/zip/src/reader.js — ZipReader sync class + readZip async-adapter pair; reader-writer symmetric-pair shape; closes the zip cluster source-file loop"
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
---

# `@endo/zip/src/reader.js` (full file)

A 60-line file (the smallest of the zip cluster's three source files we've ingested) that mirrors cycle 280's `writer.js` exactly in shape: a `ZipReader` **sync mutable class** + a `readZip` **async-adapter factory** that wraps it and returns an `ArchiveReader` interface. **Closes the zip cluster source-file loop**: cycle 280 ingested the writer, cycle 282 ingested the typedef vocabulary, cycle 284 ingests the reader — three sibling files producing, declaring, and consuming the same typedef set.

## Key moves

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

## The structure

```
import { BufferReader } from './buffer-reader.js';
import { readZip as readZipFormat } from './format-reader.js';

export class ZipReader {
  constructor(data, options = {}) {
    const { name = '<unknown>' } = options;
    // @ts-expect-error missing properties from ArrayBuffer
    const reader = new BufferReader(data);
    this.files = readZipFormat(reader);
    this.name = name;
  }
  read(name) {  // throws on missing
    const file = this.files.get(name);
    if (file === undefined) {
      throw Error(`Cannot find file ${name} in Zip file ${this.name}`);
    }
    return file.content;
  }
  stat(name) {  // returns undefined on missing
    const file = this.files.get(name);
    if (file === undefined) {
      return undefined;
    }
    return { type: file.type, mode: file.mode, date: file.date, comment: file.comment };
  }
}

export const readZip = async (data, location) => {
  const reader = new ZipReader(data, { name: location });
  /** @type {import('./types.js').ReadFn} */
  const read = async path => reader.read(path);
  return { read };
};
```

**Two named modes of access**, exactly paralleling writer.js:

| Aspect | writer.js (cycle 280) | reader.js (cycle 284) |
|---|---|---|
| Class | `ZipWriter` (sync mutable) | `ZipReader` (sync) |
| Async adapter | `writeZip(files): Promise<Uint8Array>` | `readZip(data, location): Promise<ArchiveReader>` |
| Class surface | `write` + `snapshot` | `read` + `stat` |
| Adapter surface | snapshot bytes | `{ read }` (narrowed; no stat) |
| Imports | `@import` at file top | inline `import('./types.js').X` |
| `// @ts-check` | yes | yes |
| Lines | 264 | 60 |
| `import-rename-to-avoid-collision-with-export` | yes (`writeZip as writeZipFormat`) | yes (`readZip as readZipFormat`) |

## §the-import-rename-to-avoid-collision-with-export reaffirmed

Cycle 280 noted: `import { writeZip as writeZipFormat }` in writer.js — the file *renames the format-level import on the way in* so it can *export its own `writeZip` name*. Reader.js does the **exact same** thing: `import { readZip as readZipFormat } from './format-reader.js';`. **§two-cycles-with-import-rename-to-avoid-collision-with-export in the same cluster** (280 + 284).

## §the-`as`-rename-import-pattern as named cluster discipline

The zip cluster uses **a `as`-rename-import for every "top-level public name" it then re-exports**: format-reader.js exports `readZip` (the format-level read), reader.js wants to export `readZip` (the high-level read). The rename `readZip as readZipFormat` *resolves the collision in the simplest possible way* — same name in two namespaces, distinguished by the `Format` suffix at the consuming site. §the-suffix-IS-`Format`-naming-the-narrower-format-level-shape.

## §the-three-line-async-adapter shape

`readZip`'s body is *three statements in five lines including blank-line padding*: construct, type-annotate-and-bind read, return narrowed interface. **The async-adapter pattern can be this tight** when the underlying class already does the work; cycle 280's `writeZip` was much longer (60 lines for its body) because it composed reader-from-keys + per-file iteration + snapshot.

§named-spectrum-of-async-adapter-density: dense (cycle 280's writeZip ~60 lines wrapping write+snapshot loop) vs sparse (cycle 284's readZip ~5 lines).

## §the-`location`-vs-`name` parameter-naming drift (first-explicit-observation)

The `readZip` async-adapter takes `(data, location)`; it then passes `location` to `ZipReader`'s constructor under the parameter name `name` (`new ZipReader(data, { name: location })`). **The same string is called `location` at the outer surface and `name` at the inner surface**. The class abstracts away the "where the file is" specificity into the more general "name" concept.

§named-rename-at-the-API-boundary as a small pattern: the outer-facing API uses the domain term (`location` = "where this zip came from") and the inner-facing class uses the generic term (`name` = "what to call this archive in error messages"). §the-outer-API-IS-domain-specific + §the-inner-class-IS-domain-general — a deliberate abstraction step at the boundary.

## §the-error-message-naming-both-names shape (first-explicit-observation)

The error message includes *both* names: the missing file name AND the archive's own name. `Cannot find file ${name} in Zip file ${this.name}`. The reader was given a name (defaulting to `<unknown>`) precisely so that this kind of error message can identify which archive complained.

§the-error-naming-both-the-missing-thing-AND-the-container-IS-a-debuggability-discipline; §the-archive-needs-a-name-precisely-so-errors-can-name-it.

## §two-named-Map-lookup-then-act-shapes in one class (first-explicit-observation)

Both `read` and `stat` do `this.files.get(name)`. They diverge on what to do when the result is undefined: `read` throws, `stat` returns undefined. **The branch on undefined is the API decision point**, not the lookup mechanism. This is **§the-presence-check-IS-the-API-branch** — the same data, two named missing-behaviors.

§read-throws-on-missing (forcing the caller to handle) + §stat-returns-undefined (letting the caller probe).

## §the-stat-shape-projecting-onto-typedef (first-explicit-observation)

The `stat` method returns `{ type: file.type, mode: file.mode, date: file.date, comment: file.comment }` — **explicitly enumerating the four named fields of `ArchivedStat`** (per cycle 282's typedef inventory). This is **§the-explicit-projection-shape**: rather than returning the full `file` object (which would expose `content` and possibly other fields), the method projects to the typedef's exact field set. §the-projection-IS-the-conformance-act.

§two-named-conformance-shapes for the same typedef: §the-`@type`-tag-on-a-callback (used here at line 57) + §the-explicit-projection-of-fields (used here at lines 41-46).

## §the-content-field-is-deliberately-not-in-stat (first-explicit-observation)

The `ArchivedFile` typedef (cycle 282) includes `content: string` + the four stat fields. The `ArchivedStat` typedef explicitly **omits** `content`. The `stat` method's projection therefore **deliberately omits content** — `stat` lets the caller inspect metadata without paying the cost of materializing the bytes. §the-stat-IS-a-strict-subset-of-the-archived-file-shape; §the-omission-IS-the-named-design-decision (cycle 259's §confinement-by-omission-the-omission-IS-the-defense shape, now applied to API design rather than security).

§the-confinement-by-omission-pattern-applied-to-API-design: in cycle 259 (Page interface) the omission was a security defense (no cookies, no localStorage, no network); here the omission is a *cost-deferred-read* discipline. **The same shape applied to two different concerns**.

§four-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 284).

## §the-`// @ts-check`-on-every-file-of-the-zip-cluster reaffirmed (now four files)

writer.js (280) + signature.js (278) + types.js (282) + reader.js (284). The cluster discipline is **complete** — every observed source file uses the directive. §four-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster (278 + 280 + 282 + 284).

## §the-Map-lookup-IS-the-shared-mechanism (first-explicit-observation)

The `this.files` map (constructed by `readZipFormat` at construction time) IS the shared state for both read and stat. **The class is a thin wrapper over a Map**, with a name and two access methods. §the-class-IS-essentially-a-named-Map-with-an-archive-label.

§the-class-IS-a-Map + §the-class-IS-essentially-(state, label, read, stat).

## Patterns from prior cycles, reaffirmed

- **§the-`// @ts-check`-directive** (cycle 273 project CLAUDE.md observation; reaffirmed cycle 282; now four cycles).
- **§the-sync-class-wrapped-by-async-adapter-pattern** (cycle 280 first-explicit-observation; reaffirmed here at minimal expression).
- **§import-rename-to-avoid-collision-with-export** (cycle 280 first-explicit-observation; second cycle in same cluster).
- **§the-class-and-async-adapter-pair-as-named-discipline** (cycle 280; second cycle).
- **§the-`Error()`-without-`new`-shorthand** (cycle 280; second cycle).
- **§the-Map-for-files-IS-a-named-insertion-order-preserving-store** (cycle 280; second cycle — but only implicitly; reader doesn't iterate in order).
- **§the-sync-snapshot-method** — analogue here is sync read and sync stat (cycle 280's snapshot was sync too).
- **§explicit-confinement-by-omission** (234 + 238 + 259 + 284 — fourth cycle; now also applied to API-design, not just security).
- **§five-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster** if we count signature.js (278) + writer.js (280) + types.js (282) + reader.js (284) + the implicit observation from the other files we haven't yet ingested.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §reader-writer-symmetric-pair-shape + §three-cycles-closing-the-zip-cluster-source-loop + §the-class-exposes-stat-but-the-async-adapter-only-exposes-read + §the-`@type`-inline-JSDoc-on-a-local-const + §the-inline-`import('./types.js').X`-form-vs-`@import`-form (convention-deviation) + §the-`<unknown>`-default-value-as-named-sentinel + §the-`@ts-expect-error`-with-named-justification-in-comment + §the-`as`-rename-import-pattern + §the-`location`-vs-`name`-parameter-naming-drift + §the-error-message-naming-both-names + §two-named-Map-lookup-then-act-shapes + §the-stat-shape-projecting-onto-typedef + §the-content-field-is-deliberately-not-in-stat + §the-Map-lookup-IS-the-shared-mechanism — all fourteen first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §named-spectrum-of-async-adapter-density (dense vs sparse) + §two-named-conformance-shapes (`@type`-tag + explicit-projection) + §named-rename-at-the-API-boundary + §the-presence-check-IS-the-API-branch + §two-named-JSDoc-optional-markers (`Date?` postfix-question-mark + `T=` postfix-equals).
- **Tier 3 (multi-cycle pattern recognition)**: §four-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 284) + §four-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster (278 + 280 + 282 + 284) + §seven-cycles-with-closing-an-importer-and-producer-loop (263+273 + 268+270 + 280+282 + 280+282+284) + §two-cycles-with-import-rename-to-avoid-collision-with-export in same cluster (280 + 284).

## Synthesis target

Slot machine library `@game/replay/src/reader.js`: a `ReplayReader` sync class wrapping a Map of player-action-records + a `readReplay` async-adapter that narrows to `{ read }` for the recorded-game-event consumer; constructor takes `(data, options)` where `options.name` defaults to `'<unknown>'`; `read(eventName)` throws on missing event with both-names error; `stat(eventName)` returns optional `EventStat=` (deliberately omits the event payload, only metadata); the async adapter type-annotates the read function with `/** @type {ReadFn} */` to bind to the typedef shape; `// @ts-check` on the file; both inline `import('./types.js').X` types (deviating from project preference for `@import`) and any necessary import rename to avoid collision with `format-reader.js`'s `readReplay`.

## Single most structurally interesting move

**§the-class-exposes-stat-but-the-async-adapter-only-exposes-read** — the async-adapter **deliberately narrows the public interface**. The `ArchiveReader` typedef (from cycle 282's types.js) names *only* `read`; `stat` is a sync convenience on the class but is NOT part of the cross-package contract. The factory enforces this narrowing by destructuring `{ read }` from the constructed reader at the return point, not by hiding the class entirely.

This is **§the-typedef-IS-the-public-contract + the-class-IS-the-private-implementation**, with the factory at the boundary doing the narrowing. The class can grow more methods over time without changing the cross-package contract; the contract is the typedef, not the class. §named-public-private-boundary-via-typedef-narrowing — a distinct discipline from "hide the class entirely" (which would be heavier-handed).
