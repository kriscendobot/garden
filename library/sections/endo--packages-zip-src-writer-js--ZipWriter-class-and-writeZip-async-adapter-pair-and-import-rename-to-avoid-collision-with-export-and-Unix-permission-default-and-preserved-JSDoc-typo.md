---
title: "@endo/zip/src/writer.js — ZipWriter class + writeZip async adapter pair + import-rename to avoid collision with export + Unix permission default 0o644 + preserved JSDoc typo (missing @ on type annotation)"
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
---

# `@endo/zip/src/writer.js` — the class-and-async-adapter pair

A 64-line file that exports the `ZipWriter` class **paired with** the `writeZip()` async-adapter factory function. The pair instantiates a named structural shape: a synchronous-mutable class plus a thin async adapter that wraps the class behind a deferred-not-truly-async API.

§First-explicit-observation in library: **§the-class-and-async-adapter-pair-as-named-discipline — §a-synchronous-mutable-class (ZipWriter) + §an-async-adapter-factory (writeZip) wrapping the class + §the-async-wrapper's-body-IS-sync (`await` would be a no-op) + §the-abstraction-lets-future-implementations-be-truly-async-if-needed**.

§Sibling-pattern to cycle 276's platform-bound-bootstrap + powers-injected-factory pair — but here the pair is class + async-adapter rather than bootstrap + factory; §two-named-paired-file-shapes in the @endo cluster: §bootstrap-and-factory-pair (276) + §class-and-async-adapter-pair (280).

## §The ZipWriter class — synchronous mutable API

Lines 6-50 carry the §sync-mutable-class:
- **Constructor** with `options = { date: new Date() }` default.
- **`write(name, content, options)`** — adds a file to the internal Map.
- **`snapshot()`** — produces a Uint8Array of the full ZIP buffer.

§First-explicit-observation in library: **§the-sync-mutable-class-with-named-snapshot-method — §the-class-accumulates-state-via-`write()` + §`snapshot()`-produces-the-current-serialized-form-without-mutating-the-class-state + §sibling-pattern to many CRDT and immutable-collection conventions (Automerge `Doc.snapshot()`; immutable.js `.toJS()`)**.

§The-`snapshot`-method-returns-a-Uint8Array-via-`writer.subarray()` — §the-BufferWriter's-`subarray()`-returns-the-whole-written-buffer; §sibling-pattern to many builder-pattern conventions where the final `.build()` or `.snapshot()` returns the accumulated structure.

§Two-named-snapshot-conventions-now (cycle 259's Browser.snapshot() returning text-or-screenshot + cycle 280's ZipWriter.snapshot() returning Uint8Array); §two-cycles-with-named-snapshot-method-returning-different-shape-types (259 + 280).

## §The Map-of-files preserves insertion order

Line 15: `this.files = new Map();`

§First-explicit-observation in library: **§the-Map-for-files-IS-a-named-insertion-order-preserving-store — §JS-Maps-preserve-insertion-order + §the-ZIP-format-IS-sensitive-to-file-order + §the-Map-IS-the-canonical-choice-for-ordered-named-key-to-value-mapping**.

§Sibling-pattern to many @endo/* conventions where Map IS preferred over plain Object for: insertion-order preservation + non-string keys + no prototype pollution.

## §The writeZip() async-adapter factory — ten lines wrapping the class

Lines 54-64:
```js
export const writeZip = () => {
  const writer = new ZipWriter();
  const write = async (path, data) => {
    writer.write(path, data);
  };
  const snapshot = async () => writer.snapshot();
  return { write, snapshot };
};
```

§First-explicit-observation in library: **§the-sync-class-wrapped-by-async-adapter-pattern (deferred-not-async) — §the-`async`-keyword-IS-on-the-function-signature + §the-body-uses-sync-calls + §the-`await`-of-the-result-would-be-a-no-op-today + §the-abstraction-promises-async-semantics-even-when-the-current-impl-IS-sync**.

§Sibling-pattern to many cluster-conventions where the public API IS Promise-returning to allow future implementations to become truly async; §the-discipline-IS-async-promise-without-current-async-action.

§The-factory-returns-`{ write, snapshot }` — §minimal-interface; §two-method-interface; §sibling-pattern to many @endo/* readable+writable adapter patterns.

§The-factory-IS-thin (ten lines) — §the-thin-async-wrapper-around-the-thick-sync-class; §the-class-holds-all-the-logic + §the-wrapper-holds-the-protocol-promise; §the-discipline-IS-separation-of-implementation-from-protocol.

§First-explicit-observation in library: **§the-thin-async-wrapper-around-thick-sync-class — §the-class-has-50+-lines + §the-wrapper-has-10-lines + §the-wrapper's-only-job-IS-the-async-protocol + §sibling-pattern to many adapter-pattern conventions**.

## §Import-rename to avoid collision with export

Line 4: `import { writeZip as writeZipFormat } from './format-writer.js';`

§The-`writeZip`-from-`./format-writer.js` IS renamed to `writeZipFormat` because line 55's `export const writeZip = () => {...}` would collide.

§First-explicit-observation in library: **§import-rename-to-avoid-collision-with-export — §the-imported-symbol-IS-renamed-at-import-site + §the-renamed-symbol-IS-used-internally + §the-original-name-IS-reused-as-the-public-export + §sibling-pattern to many cluster conventions where the internal function and the public factory share a name**.

§Two-named-`writeZip`-symbols-disambiguated-via-import-rename:
1. **Internal `writeZipFormat`** (from `./format-writer.js`) — the actual ZIP format writer.
2. **Public `writeZip`** (this file's export) — the async-adapter factory.

§The-internal-function-and-the-public-API-share-the-conceptual-name + §the-rename-resolves-the-syntactic-collision-while-preserving-the-conceptual-correspondence; §first-explicit-observation in library.

## §Named options pattern with three named option fields

Lines 28-29:
```js
write(name, content, options = {}) {
  const { mode = 0o644, date = undefined, comment = '' } = options;
```

§Three-named-options-with-named-defaults:
- **`mode = 0o644`** — Unix-style file-permission default.
- **`date = undefined`** — explicit undefined-as-default.
- **`comment = ''`** — empty-string-as-default.

§First-explicit-observation in library: **§the-`0o644`-permission-default-as-named-Unix-convention — §`0o644`-IS-`-rw-r--r--`-(owner-read-write-+-group-read-+-other-read) + §the-default-IS-the-canonical-Unix-file-permission-for-non-executable-content + §the-zip-format-honors-the-Unix-permission-model**.

§Sibling-pattern to many Unix-aware libraries (tar + chmod + mkdir); §the-`0o644`-IS-the-named-canonical-default-for-regular-files; §the-discipline-IS-explicit-permission-defaults-in-the-options-object.

§The-`date = undefined`-explicit-undefined-as-default — §the-default-IS-explicit-undefined-not-omitted; §sibling-pattern to functional-programming conventions where the default IS named even when it IS the absence; §first-explicit-observation in library of §the-explicit-undefined-as-default-pattern-when-the-absence-IS-meaningful.

## §The `if (!content) throw Error(...)` validation

Lines 30-32:
```js
if (!content) {
  throw Error(`ZipWriter write requires content for ${name}`);
}
```

§First-explicit-observation in library: **§the-`Error(...)`-without-`new`-shorthand — §JS-allows-Error()-as-function-call-not-just-constructor + §the-result-IS-the-same-Error-instance + §the-shorthand-saves-the-`new`-keyword + §sibling-pattern to many @endo/* conventions where Error() IS called without `new`**.

§The-error-message-includes-the-`name`-parameter — §named-context-in-the-error; §the-message-IS-helpful-because-it-names-which-file-was-being-written-when-the-error-fired; §sibling-pattern to many @endo/* conventions for context-rich error messages.

§The-`if (!content)`-truthy-check — §rejects-null-undefined-empty-string-zero-NaN-empty-Uint8Array; §the-zero-byte-Uint8Array-IS-truthy (Uint8Array instances are objects); §the-check-rejects-the-three-falsy-values-that-make-no-sense-for-content (null + undefined + empty string).

## §The preserved JSDoc typo — `type {Map<string, ZFile>}` missing the `@`

Line 14: `/** type {Map<string, ZFile>} */`

§The-correct-JSDoc-tag-IS-`@type`-not-`type` — §the-`@`-prefix-IS-the-JSDoc-syntax-marker + §without-the-`@`-the-annotation-IS-effectively-a-no-op + §the-TypeScript-checker-ignores-this-comment.

§First-explicit-observation in library: **§a-preserved-JSDoc-typo (missing `@` on `type` annotation) — §the-typo-IS-evidence-of-imperfect-review + §the-discipline-of-running-`yarn lint`-and-`tsc --build`-from-the-project-CLAUDE.md (cycle 273's read-through) would-have-caught-this-but-didn't + §the-typo-persists-in-the-current-tree**.

§Two-cycles-with-preserved-typo-as-evidence (263 outliner-design-doc-2's `or something.f` + 280 writer.js's `type {Map<string, ZFile>}`):
- **Cycle 263** — typo IS evidence of design-fragment's-informal-status (a deliberate choice to keep the document as in-flight thinking).
- **Cycle 280** — typo IS evidence of imperfect review (the lint-and-tsc check should have caught this but didn't).

§First-explicit-observation in library: **§two-named-shapes-of-preserved-typo (deliberate-informal-status + imperfect-review-trace) — §the-typo's-status-depends-on-the-document's-genre**.

## §Three named typedefs imported for typing the thin wrapper

Lines 53, 57, 61 carry §three-named-typedef-imports-via-JSDoc-from-types.js:

- `import('./types.js').ArchiveWriter` — the abstract-interface-typedef returned by `writeZip()`.
- `import('./types.js').WriteFn` — the type of the `write` method.
- `import('./types.js').SnapshotFn` — the type of the `snapshot` method.

§First-explicit-observation in library: **§three-named-typedefs-imported-for-typing-the-thin-wrapper — §each-of-the-three-elements-of-the-returned-object-has-its-own-named-typedef + §the-discipline-IS-per-method-typedef-naming + §sibling-pattern to TypeScript's `interface ArchiveWriter { write: WriteFn; snapshot: SnapshotFn; }` discipline applied in JSDoc**.

§Sibling-pattern to cycle 264's `confirmPassStyle` JSDoc-block-with-multiple-typedefs (cycle 266's metalanguage observation); §the-cluster-uses-per-method-typedef-naming-where-the-method-IS-non-trivial.

## §Cycle 280 first-explicit-observations roundup (twelve)

1. §the-class-and-async-adapter-pair-as-named-discipline.
2. §the-sync-mutable-class-with-named-snapshot-method.
3. §two-cycles-with-named-snapshot-method-returning-different-shape-types (259 + 280).
4. §the-Map-for-files-IS-a-named-insertion-order-preserving-store.
5. §the-sync-class-wrapped-by-async-adapter-pattern (deferred-not-async).
6. §the-thin-async-wrapper-around-thick-sync-class.
7. §import-rename-to-avoid-collision-with-export.
8. §the-`0o644`-permission-default-as-named-Unix-convention.
9. §the-explicit-undefined-as-default-pattern-when-the-absence-IS-meaningful.
10. §the-`Error(...)`-without-`new`-shorthand.
11. §a-preserved-JSDoc-typo (missing `@` on `type` annotation).
12. §two-named-shapes-of-preserved-typo (deliberate-informal-status + imperfect-review-trace).

Plus: §three-named-typedefs-imported-for-typing-the-thin-wrapper.

## §Recurring meta-pattern counters bumped at cycle 280

- §**two-named-paired-file-shapes-in-the-cluster** (cycle 276 bootstrap-and-factory-pair + cycle 280 class-and-async-adapter-pair).
- §**two-cycles-with-named-snapshot-method** (259 Browser.snapshot + 280 ZipWriter.snapshot).
- §**two-cycles-with-preserved-typo-as-evidence** (263 + 280; two named shapes).
- §**one-hundred-and-thirteenth consecutive designs-chat alternation cycles 166-250 + 252-280** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-class-and-async-adapter-pair applies to the §game-engine-cluster:

- §**`GameStateWriter`** class (sync mutable, like ZipWriter) — accumulates state via `write()` + produces `snapshot()` as bytes.
- §**`writeGameState()`** async-adapter factory wrapping the class — returns `{ write, snapshot }` with async signatures.
- §**§the-Map-for-game-states** preserves insertion order.
- §**§the-`0o644`-permission-default** for game-state files.
- §**§named options** with explicit-undefined defaults for the optional fields.
- §**§import-rename to avoid collision** when the internal function and the public factory share a name.

## §Tier-1 borrowing

§the-class-and-async-adapter-pair-as-named-discipline + §the-sync-mutable-class-with-named-snapshot-method + §the-Map-for-files-IS-a-named-insertion-order-preserving-store + §the-sync-class-wrapped-by-async-adapter-pattern + §the-thin-async-wrapper-around-thick-sync-class + §import-rename-to-avoid-collision-with-export + §the-`0o644`-permission-default-as-named-Unix-convention + §the-explicit-undefined-as-default-pattern + §the-`Error(...)`-without-`new`-shorthand + §a-preserved-JSDoc-typo + §two-named-shapes-of-preserved-typo (deliberate-informal-status + imperfect-review-trace).

## §Tier-2 borrowing

§three-named-typedefs-imported-for-typing-the-thin-wrapper + §two-named-`writeZip`-symbols-disambiguated-via-import-rename + §named-context-in-the-error.

## §Tier-3 borrowing

§two-named-paired-file-shapes-in-the-cluster (276 + 280) + §two-cycles-with-named-snapshot-method (259 + 280) + §two-cycles-with-preserved-typo-as-evidence (263 + 280) + §library-reaches-786-sections at cycle 280 + §one-hundred-and-thirteenth consecutive designs-chat alternation cycles 166-250 + 252-280.

## Pattern summary (tag-prefixed)

§the-class-and-async-adapter-pair + §the-sync-mutable-class-with-named-snapshot-method + §the-Map-for-files-IS-a-named-insertion-order-preserving-store + §the-sync-class-wrapped-by-async-adapter-pattern (deferred-not-truly-async) + §the-thin-async-wrapper-around-thick-sync-class + §import-rename-to-avoid-collision-with-export + §two-named-`writeZip`-symbols-disambiguated-via-import-rename + §the-`0o644`-permission-default-as-named-Unix-convention + §the-explicit-undefined-as-default-pattern + §the-`Error(...)`-without-`new`-shorthand + §named-context-in-the-error + §three-named-typedefs-imported-for-typing-the-thin-wrapper + §a-preserved-JSDoc-typo (missing `@` on `type` annotation) + §two-named-shapes-of-preserved-typo (deliberate-informal-status + imperfect-review-trace) + §two-cycles-with-preserved-typo-as-evidence (263 + 280).
