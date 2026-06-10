---
title: "@endo/far/src/index.js + exports.js — the package IS a curated re-export set + the dummy exports.js companion + the five-line package"
source-slug: endo--packages-far-src-index-js-and-exports-js
source-url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
---

# The `@endo/far` package IS a curated re-export set + the dummy `exports.js` companion + the five-line package

[`@endo/far/src/index.js`](../sources/endo--packages-far-src-index-js-and-exports-js.md) is a §five-line-file that re-exports four canonical capability operations from two upstream packages, plus a `export * from './exports.js'` that pulls in the package's typedef vocabulary. The sibling [`@endo/far/src/exports.js`](../sources/endo--packages-far-src-index-js-and-exports-js.md) is a §two-line-dummy-file containing `export {};` whose purpose is to "use exports.d.ts and satisfy runtime imports."

§The-package's-entire-runtime-surface is **seven lines** (5 + 2). §First-direct-ingest from `@endo/far/src/`.

## §The package IS a curated re-export set

```js
// index.js (5 lines)
export { E } from '@endo/eventual-send';
export { Far, getInterfaceOf, passStyleOf } from '@endo/pass-style';

// eslint-disable-next-line import/export
export * from './exports.js';
```

§Four-named-re-exports from §two-named-upstream-packages: §`E` from `@endo/eventual-send` + §`Far`, `getInterfaceOf`, `passStyleOf` from `@endo/pass-style`. §The-package's-existence-IS-the-curation — §`@endo/far` is not a runtime library; it's a single import path that bundles the canonical capability-call operations.

§First-explicit-observation in library of §the-package-IS-a-curated-re-export-set as named-package-purpose. §When-a-package's-job-is-to-name-a-canonical-vocabulary-not-to-implement-it, §the-package-IS-curated-re-exports-from-the-actual-implementations. §The-package-name (`@endo/far`) is the user-facing-name + §the-implementation-packages (`@endo/eventual-send`, `@endo/pass-style`) are the internal-substrate.

§Sibling-pattern-to-cycle-254's-no-shim's-`export *`-with-eslint-disable — §two-cycles-with-`export *`-with-named-eslint-disable (254 + 258). §Three-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254 + 258).

§Sibling-pattern-to-cycle-254's-three-different-export-styles-in-one-file — §cycle-254 had three export styles in one file (`export const`, `export { local as Public }`, `export *`); §cycle-258 has two export styles (`export { name }`, `export *`) but only because the package is pure re-export. §Two-cycles-with-multiple-export-styles-in-one-file.

## §The dummy `exports.js` companion

```js
// exports.js (2 lines)
// Just a dummy to use exports.d.ts and satisfy runtime imports.
export {};
```

§The-`exports.js`-IS-a-dummy. §Its-only-job: §let-the-corresponding-`exports.d.ts`-be-the-real-public-types + §satisfy-the-runtime-loader-when-something-does-`import * from './exports.js'`. §First-explicit-observation in library of §the-dummy-`.js`-companion-to-a-`.d.ts`-file as named TypeScript-and-runtime-bridge pattern.

§The-comment-explains-the-non-obvious-purpose: *Just a dummy to use exports.d.ts and satisfy runtime imports*. §When-a-file's-existence-is-non-obvious-because-its-content-is-trivial, §the-comment-IS-the-evidence-of-the-non-obvious-purpose + §don't-leave-the-reader-to-guess-why-the-file-exists.

§Sibling-pattern-to-cycle-247's-the-function-name-encodes-the-discipline and cycle-252's-`maybe<TargetType>`-as-named-parameter-naming-convention — §three-cycles-with-named-identifier-or-comment-encodes-the-discipline (247 function-name + 252 parameter-name + 258 file-purpose-comment). §The-evidence-of-the-design-is-in-the-naming-or-the-comment.

§Sibling-pattern-to-cycle-249's-`export {};`-typedef-only-file + cycle-256's-`export {};`-typedef-only-file — §three-cycles-with-`export {};`-marker (249 + 256 + 258). §Three-different-roles-for-`export {};`: §cycle-249-marks-typedef-only-protocol-file + §cycle-256-marks-typedef-only-Promise-and-ERef-vocabulary + §cycle-258-marks-the-runtime-companion-to-a-.d.ts.

§The-`exports.js`-and-`exports.d.ts`-form-a-pair: §`.d.ts`-IS-the-type-source + §`.js`-IS-the-runtime-marker + §the-pair-IS-how-TypeScript-and-Node.js-cooperate-for-pure-type-imports. §When-a-package-wants-to-export-types-but-no-runtime-values, §the-`.d.ts`-IS-the-source-of-truth + §the-`.js`-IS-the-stub-to-satisfy-the-loader.

## §The five-line package — smallest src/index.js ingested

§Five-lines-as-a-complete-package-runtime-entry-point. §Smallest-`src/index.js`-ingested-yet — §the-package-IS-its-curated-re-exports-and-nothing-else.

§Sibling-pattern-to-cycle-243's-host-endian.js (9 lines) — §two-cycles-with-the-smallest-known-files: §cycle-243 nine-lines-platform-detection + §cycle-258 five-line-curated-re-export-index + §cycle-258's-companion-exports.js two-lines.

§Eight-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256 + 258).

§Forty-fifth-member of §small-files-with-large-knowledge-density family.

§First-explicit-observation in library of §five-line-`src/index.js`-as-curated-re-export-package-entry-point.

## §The `Far` vocabulary: E + Far + getInterfaceOf + passStyleOf

The four re-exports are the §canonical-capability-vocabulary:

1. **§`E`** — the proxy `E(x).method(args)` for eventual-send (sibling: cycle 146).
2. **§`Far`** — the constructor for remotable far-refs (`Far('IfaceName', methods)`).
3. **§`getInterfaceOf`** — the introspection function for a far-ref's interface name.
4. **§`passStyleOf`** — the central pass-style dispatch function (sibling: cycle 71).

§The-four-form-a-cohesive-vocabulary-for-far-references-and-pass-style-discovery. §`@endo/far`-IS-the-package-name-that-makes-them-a-single-import-path.

§First-explicit-observation in library of §the-canonical-Far-vocabulary as the named-four-exports of `@endo/far`. §When-an-application-uses-far-references, §the-`@endo/far`-import-IS-the-canonical-entry-point + §the-application-doesn't-need-to-know-which-implementation-package-provides-which-export.

§The-curated-package-IS-the-abstraction: §the-application-imports-from-`@endo/far` + §the-implementations-can-move-between-`@endo/eventual-send`-and-`@endo/pass-style`-without-the-application-knowing. §Sibling-pattern-to-cycle-242's-`@endo/platform`-conditional-exports — §two-cycles-with-named-curated-package-as-stable-import-path (242 + 258). §Two-different-shapes: §cycle-242 conditional-exports-by-platform + §cycle-258 curated-re-export-set-from-multiple-packages.

## §The package's existence IS the abstraction

§Why-not-just-`import { E } from '@endo/eventual-send'`-directly? §Because-the-curated-package-decouples-the-application-from-the-implementation-package-structure + §future-refactors-can-move-`E`-to-a-different-package-and-only-`@endo/far`-changes + §the-application-keeps-importing-from-`@endo/far`-unchanged.

§The-curated-package-IS-the-abstraction-boundary. §First-explicit-observation in library of §curated-re-export-package-IS-the-abstraction-boundary as named architectural pattern.

§Sibling-pattern-to-cycle-242's-elevator-module — §two-cycles-with-named-import-isolation-pattern: §cycle-242 elevator-isolates-platform-import + §cycle-258 curated-package-isolates-implementation-package-structure. §Three-cycles-with-named-import-isolation (242 + 254 no-shim + 258 curated-re-export).

## §`export *` with `eslint-disable-next-line import/export`

```js
// eslint-disable-next-line import/export
export * from './exports.js';
```

§Same-pattern-as-cycle-254 — the eslint rule flags potential conflicting exports + the author knows the conflict is intentional. §Two-cycles-with-`export *`-with-eslint-disable (254 + 258). §The-eslint-disable-comment-IS-the-acknowledgment-of-the-known-conflict.

§The-conflict-here: §`exports.js`-is-a-no-op + §`export *`-from-it-adds-nothing-at-runtime + §but-the-`.d.ts`-companion-DOES-add-types + §the-eslint-rule-only-sees-the-`.js`-and-flags-it.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §The package IS a curated re-export set — named-package-purpose distinct from implementation.
- §Four-named-re-exports from two named upstream packages — `@endo/far` collects `E` + `Far` + `getInterfaceOf` + `passStyleOf`.
- §The dummy `.js` companion to a `.d.ts` file — TypeScript-and-runtime bridge pattern.
- §The comment explains the non-obvious purpose — when a file's existence is non-obvious, the comment IS the evidence.
- §Curated re-export package IS the abstraction boundary — the application decouples from implementation package structure.
- §The canonical Far vocabulary as the named-four-exports of `@endo/far`.
- §Five-line `src/index.js` as curated re-export package entry point.

**Tier-2 (named comparisons):**

- §Three-cycles-with-`export {};`-marker (249 + 256 + 258) — three different roles.
- §Three-cycles-with-named-import-isolation (242 elevator + 254 no-shim + 258 curated-re-export).
- §Three-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254 + 258).
- §Three-cycles-with-named-identifier-or-comment-encodes-the-discipline (247 function-name + 252 parameter-name + 258 file-purpose-comment).
- §Two-cycles-with-named-curated-package-as-stable-import-path (242 + 258).
- §Two-cycles-with-`export *`-with-named-eslint-disable (254 + 258).
- §Two-cycles-with-multiple-export-styles-in-one-file (254 + 258).

**Tier-3 (file-shape patterns):**

- §Five-line `src/index.js` as smallest package entry point ingested yet.
- §Two-line `exports.js` as smallest companion file ingested (smaller than cycle 243's 9 lines).
- §Eight-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256 + 258).

## §Synthesis target — slot machine library

For a slot machine library:

- §The-game-engine-public-API-package-IS-a-curated-re-export-set from the actual implementation packages.
- §`@game/api` as the canonical name for the game engine's public vocabulary.
- §Four-named-re-exports from named implementation packages: `playGame` + `Game` + `getRulesOf` + `gameStyleOf`.
- §The-dummy-`.js`-companion-to-a-`.d.ts`-file for game-engine's pure-type exports.
- §The-comment-explains-the-non-obvious-purpose for game-rule-utility-files.
- §Curated-re-export-package-IS-the-abstraction-boundary — the game's application code decouples from internal package structure.

## §Library meta-counters

- §Library-reaches-764-sections at cycle 258 (chat-lane @endo/far/src/index + exports).
- §Ninety-first-consecutive designs-chat alternation cycle (cycles 166-250 + 252-258; cycle 251 was out-of-band papers).
- §First-direct-ingest from `@endo/far/src/`.
- §Forty-fifth-member of §small-files-with-large-knowledge-density family.
- §Eight-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256 + 258).
- §Three-cycles-with-`export {};`-marker (249 + 256 + 258).
- §Three-cycles-with-named-import-isolation (242 + 254 + 258).
- §Three-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254 + 258).
- §Three-cycles-with-named-identifier-or-comment-encodes-the-discipline (247 + 252 + 258).
- §Two-cycles-with-named-curated-package-as-stable-import-path (242 + 258).
- §Two-cycles-with-`export *`-with-named-eslint-disable (254 + 258).
- §Two-cycles-with-multiple-export-styles-in-one-file (254 + 258).
- §First-explicit-observation of seven patterns: §the-package-IS-a-curated-re-export-set + §the-dummy-`.js`-companion-to-a-`.d.ts`-file + §curated-re-export-package-IS-the-abstraction-boundary + §the-canonical-Far-vocabulary + §five-line-`src/index.js`-as-curated-re-export-package-entry-point + §the-comment-explains-the-non-obvious-purpose-of-a-trivial-file + §two-line-`exports.js`-as-companion-to-`.d.ts`.

(Endo Project Contributors authored)
