---
title: "@endo/common — ten low-level utility files with tree-shaking-friendly deep-imports"
source-slug: endo--packages-common
url: https://github.com/endojs/endo/tree/master/packages/common
authors: [Mark Miller, Kris Kowal, Endo contributors]
repo: endojs/endo
path:
  - packages/common/apply-labeling-error.js
  - packages/common/from-unique-entries.js
  - packages/common/ident-checker.js
  - packages/common/list-difference.js
  - packages/common/make-array-iterator.js
  - packages/common/make-iterator.js
  - packages/common/object-map.js
  - packages/common/object-meta-assign.js
  - packages/common/object-meta-map.js
  - packages/common/throw-labeled.js
  - packages/common/README.md
total-lines: 440 source across 10 files + ~20 README
license: Apache-2.0
ingest-cycle: 211
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/common

§Ten low-level utility files with §one-purpose-per-file discipline + §tree-shaking-friendly deep-imports (no index.js; each file named after its main export; package.json lists each as distinct `exports` entry). §Four-named-inclusion-criteria stated in README.

## Four named inclusion criteria

> - low level (not depending on anything higher than `ses`, `@endo/eventual-send`, `@endo/promise-kit`)
> - highly reusable
> - sufficiently general
> - can be explained and motivated without much external knowledge

## Ten files

| File | Purpose |
| --- | --- |
| `apply-labeling-error.js` | §The substrate for cycle 198 patterns-diagnostic-feedback — sync+async error-relabeling with cause chain |
| `throw-labeled.js` | Companion to applyLabelingError — `${label}: ${innerErr.message}` + `X\`Caused by ${innerErr}\`` |
| `from-unique-entries.js` | Throws on duplicate property name (defends against user-data property-name injection) |
| `ident-checker.js` | Deprecated; forwards to Rejector confirm/reject pattern |
| `list-difference.js` | Set-based difference using SameValueZero comparison |
| `make-iterator.js` | Hardening analog of `Array.prototype[Symbol.iterator]` — self-iterable via `[Symbol.iterator]: () => iter` |
| `make-array-iterator.js` | Concrete factory built on makeIterator with `@ts-expect-error` for terminal-value-doesn't-matter |
| `object-map.js` | Value-level objectMap + objectExtendEach + typedEntries/typedMap/fromTypedEntries JSDoc-typed-casts |
| `object-meta-assign.js` | Descriptor-level Object.assign (preserves accessors and non-enumerable) |
| `object-meta-map.js` | Descriptor-level objectMap with filter-via-undefined and proto-parameter |

## Key design moves

- **§Tree-shaking-friendly via deep-imports** — explicit goal stated in README ("Some implementations [...] can thus do tree-shaking, omitting code that isn't reachable by imports").
- **§Each-file-named-after-its-main-export** — file naming discipline.
- **§applyLabelingError** sync+async via `E.when(result, undefined, reason => throwLabeled(reason, label))` for the promise case.
- **§throwLabeled** with number-label-becomes-`[N]`-form; sibling pattern to cycle 198's seven-trace-step-kinds discriminated union.
- **§fromUniqueEntries** with §fast-path-then-slow-path-for-diagnostic-quality (first check length-equality fast; on mismatch iterate to find collision with named diagnostic).
- **§identChecker deprecated-with-forwarding-comment to Rejector confirm/reject pattern** (both `@deprecated` tags on the file).
- **§listDifference** with §SameValueZero-comparison-noted-explicitly (NaN equality, ±0 equality).
- **§makeIterator + makeArrayIterator** — hardening analog of built-in iterators; §self-iterable-via-`[Symbol.iterator]: () => iter`; §@ts-expect-error-with-rationale-comment ("The terminal value doesn't matter").
- **§Four-shape-toolkit** for object transformation (objectMap / objectMetaMap / objectMetaAssign / objectExtendEach) covering §value-vs-descriptor × §map-vs-extend.
- **§Five-named-edge-cases per utility** in doc-comments as §runtime-spec.
- **§JSDoc-typed-cast** for built-ins with loose default types (typedEntries / typedMap / fromTypedEntries).
- **§Three-canonical-uncurry-shapes in @endo** now observed (cycle 199 bind.bind(bind.call) + cycle 207 Reflect.apply-form + cycle 211 Function.prototype.call.bind).
- **§hideAndHardenFunction-for-wrappers + §harden-for-leaf-utilities** — semantic distinction.
- **§Honest-cross-package-TypeScript-edges** with explanatory comments (applyLabelingError @ts-ignore).

## The substrate for cycle 198's central discovery

Cycle 198 patterns-diagnostic-feedback's §central-discovery was that §applyLabelingError-already-records-the-path-chain via SES `annotateError`. §Cycle-211-ingests-that-substrate-directly. §The-cycle-198-and-cycle-211-pair completes the §design-and-substrate picture.

## Ingest scope

Cycle 211 (chat-lane): full ingest of all 10 source files + README as one section. Cohesion-honest single-section because §the-package-IS-the-cluster.

## Related material in the library

- **cycle 198 patterns-diagnostic-feedback**: §central-discovery cites §applyLabelingError as the substrate; cycle 211 ingests that substrate directly.
- **cycle 195 cli/src cluster**: §one-purpose-per-file sibling at CLI layer (six files).
- **cycle 199 trampoline/memoize/nat trio**: §minimal-dependency-discipline sibling at marshal/ocapn layer (three packages).
- **cycle 209 path-compare**: §JSDoc-callback-typedef-with-generic-T sibling — both packages use JSDoc-typedef as typed-cast.
- **cycle 207 env-options**: §minimal-dependency-discipline sibling; §three-canonical-uncurry-shapes observation now confirmed across three cycles.
- **cycle 205 evasive-transform**: §inline-typedef-deprecation-marker sibling (ident-checker's deprecation tags).
- **cycle 197 panic**: §honest-design-evolution-in-the-README sibling.
- **cycle 175 harden-make-selector**: `harden` import substrate (every common utility imports it).
- **`@endo/errors`**: substrate (X / makeError / annotateError / hideAndHardenFunction).
- **`@endo/eventual-send`** (E.when): used in applyLabelingError for promise-rejection rewrapping.
- **`@endo/promise-kit`** (isPromise): used in applyLabelingError to detect promise vs sync result.
