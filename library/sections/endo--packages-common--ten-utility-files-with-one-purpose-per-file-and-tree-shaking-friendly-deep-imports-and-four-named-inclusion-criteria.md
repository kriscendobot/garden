---
title: §Ten-utility-files with §one-purpose-per-file + §tree-shaking-friendly-deep-imports (no index.js; each file named after its main export) + §four-named-inclusion-criteria + §applyLabelingError + throwLabeled as §the-substrate-for-cycle-198-patterns-diagnostic-feedback + §fromUniqueEntries with collision-throwing-on-user-data + §identChecker-deprecated-with-forwarding-to-Rejector-pattern + §listDifference with SameValueZero comparison + §makeIterator + makeArrayIterator hardening analog + §objectMap + objectMetaMap + objectMetaAssign + objectExtendEach typed-cast trio + §typedEntries/typedMap/fromTypedEntries JSDoc-typed-cast — @endo/common
source: endo packages/common/{*.js,README.md}
source-slug: endo--packages-common
ingest-cycle: 211
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo-but-for-bots--llm-designs-patterns-diagnostic-feedback (cycle 198; cites applyLabelingError as the substrate; §the-data-is-already-there-just-locked discovery centers on this file)
  - endo--packages-cli-src-utility-cluster (cycle 195; §one-purpose-per-file + §no-internal-dependencies sibling — both are utility clusters at different layers)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199; §minimal-dependency-discipline sibling)
  - endo--packages-path-compare (cycle 209; §JSDoc-callback-typedef sibling — both packages use JSDoc-typedef as typed-cast)
  - endo--packages-env-options (cycle 207; §minimal-dependency-discipline at the same layer)
keywords:
  - ten-utility-files (apply-labeling-error / throw-labeled / from-unique-entries / ident-checker / list-difference / make-iterator / make-array-iterator / object-map / object-meta-assign / object-meta-map)
  - one-purpose-per-file
  - tree-shaking-friendly via deep-imports (no index.js)
  - each-file-named-after-its-main-export
  - package.json lists each as distinct exports entry
  - four-named-inclusion-criteria (low-level / highly-reusable / sufficiently-general / explainable-without-much-external-knowledge)
  - applyLabelingError (cited by cycle 198 patterns-diagnostic-feedback as the substrate)
  - throwLabeled companion (makeError + annotateError via X`Caused by ${innerErr}`)
  - sync-and-async-error-relabeling (E.when wrapped for promise case)
  - hideAndHardenFunction on every export
  - fromUniqueEntries (throws on duplicate property name; defends against user-provided-data property name injection)
  - identChecker-deprecated-with-forwarding-comment to Rejector pattern
  - listDifference with SameValueZero comparison (NaN equality, +0/-0 equality)
  - makeIterator + makeArrayIterator hardening analog of Array.prototype[Symbol.iterator]
  - one-shot-iterator discipline
  - terminal-value-doesn't-matter @ts-expect-error
  - objectMetaAssign reflective-level Object.assign (descriptors not values)
  - objectMap + objectMetaMap + objectMetaAssign + objectExtendEach four-shape-toolkit
  - typedEntries/typedMap/fromTypedEntries JSDoc-typed-cast for generic-type-narrowing
  - objectMetaMap with metaMapFn returning undefined to filter
  - some-implementations-can-do-tree-shaking explicitly named in README
  - reflective-level-vs-value-level distinction
  - cycle 211 chat-lane
  - twenty-fourth-member of small-files-with-large-knowledge-density family
  - forty-fifth consecutive designs/chat alternation cycle 166-211
---

# @endo/common — §ten-utility-files + §one-purpose-per-file + §tree-shaking-friendly + §four-named-inclusion-criteria + §applyLabelingError-as-cycle-198-substrate

## Source

- `endo packages/common/{apply-labeling-error,from-unique-entries,ident-checker,list-difference,make-array-iterator,make-iterator,object-map,object-meta-assign,object-meta-map,throw-labeled}.js` — 440 lines across 10 files
- `endo packages/common/README.md` — ~20 lines
- Cycle 211 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 210's designs-lane lal-fae-form-provisioning; §forty-fifth consecutive designs/chat alternation cycle 166-211)

§Twenty-fourth-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§Ten-utility-files with §one-purpose-per-file discipline + §each-file-named-after-its-main-export + §no-index.js so each importer must do §a-deep-import-of-exactly-the-export-it-needs + §package.json-lists-each-as-distinct-`exports`-entry for §tree-shaking-friendly bundling + §four-named-inclusion-criteria stated in README (low-level / highly-reusable / sufficiently-general / explainable-without-much-external-knowledge).

§The-package-as-architectural-axiom: §"There is no index.js file that rolls them together. Thus, each importer must do a deep import of exactly the export it needs. Some implementations (bundlers, packagers) can thus do tree-shaking, omitting code that isn't reachable by imports."

§Sibling-pattern to cycle 195 cli/src cluster's §six-tight-utilities and cycle 199 trampoline/memoize/nat trio — §three-different-utility-cluster-shapes at §three-different-layers of @endo. §Cycle-195 is CLI-layer; §cycle-199 is small-helpers-shared-by-marshal-and-ocapn; §cycle-211 is shared-by-everything-above-ses/eventual-send/promise-kit.

## §Four-named-inclusion-criteria

From the README:

> Each of the utilities in this packages
> - are low level in the sense of not depending on anything higher level than `ses`, `@endo/eventual-send`, and `@endo/promise-kit`. Many depend on nothing beyond plain old JavaScript.
> - highly reusable, i.e., potentially useful many places.
> - sufficiently general that it would be awkward to import from a more specialized package.
> - can be explained and motivated without much external knowledge.

§Four-named-criteria for inclusion. §The-criteria-define-the-membership of the package. §Any-utility-that-doesn't-meet-all-four belongs elsewhere.

§Borrowable-pattern: §named-inclusion-criteria for §utility-packages that need §clear-membership-rules.

§Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §nine-Design-Decisions canonical format — both designs §name-the-axes-of-the-design-decision. §Cycle-211 names inclusion-criteria-as-design-decision (membership question).

## §applyLabelingError — the substrate for cycle 198 patterns-diagnostic-feedback

```js
export const applyLabelingError = (func, args, label = undefined) => {
  if (label === undefined) {
    return func(...args);
  }
  let result;
  try {
    result = func(...args);
  } catch (err) {
    throwLabeled(err, label);
  }
  if (isPromise(result)) {
    return E.when(result, undefined, reason => throwLabeled(reason, label));
  } else {
    return result;
  }
};
hideAndHardenFunction(applyLabelingError);
```

§Cycle-198-patterns-diagnostic-feedback's §central-discovery was that §applyLabelingError-already-records-the-path-chain via SES `annotateError`. §The-substrate-design-here is §the-source-of-that-claim.

§Three-named-cases:
1. §`label === undefined` — passthrough, no labeling.
2. §Synchronous-throw — `throwLabeled(err, label)` rethrows with prefixed message + `annotateError(outerErr, X\`Caused by ${innerErr}\`)`.
3. §Promise-rejection — `E.when(result, undefined, reason => throwLabeled(reason, label))` rewraps the rejection.

§Sync-and-async-error-relabeling in one function. §Sibling-pattern to cycle 199 trampoline's §sync/async-two-color-sharing-via-generator and cycle 205 evasive-transform's §sync-and-async-API-pair.

§Honest-comment-with-TypeScript-disclaimer: §"Cannot be at-ts-expect-error because there is no type error locally. Rather, a type error only as imported into exo" — §an-honest-named-cross-package-TypeScript-edge. §@ts-ignore is used with §explicit-comment-explaining-why.

## §throwLabeled — the companion

```js
export const throwLabeled = (innerErr, label, errConstructor, options) => {
  if (typeof label === 'number') {
    label = `[${label}]`;
  }
  const outerErr = makeError(
    `${label}: ${innerErr.message}`,
    errConstructor,
    options,
  );
  annotateError(outerErr, X`Caused by ${innerErr}`);
  throw outerErr;
};
```

§Two-shape-of-label: §string-label-passes-through; §number-label-becomes-`[N]`-form. §Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §seven-trace-step-kinds-discriminated-union which §generalized-this-string|number-label-into-richer-types.

§annotateError-via-`X\`Caused by ${innerErr}\`` — §the-template-tag from `@endo/errors` redacts the inner error's content from the visible message while §preserving-it-in-the-SES-cause-chain.

§Borrowable-pattern: §error-relabeling-with-cause-chain-via-annotateError as §the-substrate-for-rich-diagnostic-tooling.

## §fromUniqueEntries — collision-throwing on user-data

```js
export const fromUniqueEntries = allEntries => {
  const entriesArray = [...allEntries];
  const result = harden(fromEntries(entriesArray));
  if (ownKeys(result).length === entriesArray.length) {
    return result;
  }
  // ... find-and-throw with named collision
};
```

§Defense-against-user-provided-data — §"Use it to protect from property names computed from user-provided data". §`Object.fromEntries`-silently-deduplicates duplicate keys (later overrides earlier); §fromUniqueEntries throws instead.

§Fast-path-then-slow-path: §first-check-length-equality (fast); §on-mismatch, §iterate-to-find-the-collision (slow, with named diagnostic).

§Borrowable-pattern: §fast-path-then-slow-path-for-diagnostic-quality — §when-validation-fails, §do-extra-work-to-name-what-went-wrong.

## §identChecker — deprecated with forwarding-comment

```js
/**
 * @deprecated Use `Rejector` in the confirm/reject pattern instead
 * @callback Checker
 * Internal to a useful pattern for writing checking logic
 * (a "checkFoo" function) that can be used to implement a predicate
 * (an "isFoo" function) or a validator (an "assertFoo" function).
 * [...]
 */

/**
 * @deprecated use `false` in the confirm/reject pattern instead
 */
export const identChecker = (cond, _details) => cond;
```

§Two-deprecation-tags on one file — both Checker and identChecker §forwarded to §Rejector-confirm/reject-pattern. §The-pattern-is-still-documented in the typedef despite deprecation — §design-archaeology-preserved.

§Sibling-pattern to cycle 205 evasive-transform's §inline-typedef-deprecation-marker (vestigial useLocationUnmap) — both packages §preserve-deprecated-surfaces-with-forwarding-comments.

§Borrowable-pattern: §deprecation-tags-with-forwarding-comment-to-replacement-pattern for §gradual-API-evolution.

## §listDifference — SameValueZero comparison

```js
export const listDifference = (leftList, rightList) => {
  const rightSet = new Set(rightList);
  return leftList.filter(element => !rightSet.has(element));
};
```

§Three-line-utility with §rich-doc-comment. §The-doc-comment-names-the-comparison-semantics:

> Uses the comparison built into `Set` membership (SameValueZero) which is like JavaScript's `===` except that it judges any `NaN` to be the same as any `NaN` and it judges `0` to be the same a `-0`.

§Two-named-edge-cases: NaN-equality + ±0-equality. §Standard-quirks-of-Set-membership.

§Used-for-name-mismatch-diagnostics: §"This is often used on lists of names that should match, in order to generate useful diagnostics about the unmatched names."

§Borrowable-pattern: §SameValueZero-comparison-noted-explicitly when the utility uses Set/Map membership. §The-comparison-semantics-are-rarely-default-expectations.

## §makeIterator + makeArrayIterator — hardening analog

```js
export const makeIterator = next => {
  const iter = harden({
    [Symbol.iterator]: () => iter,
    next,
  });
  return iter;
};
```

§Two-line-factory + §self-referential-iter via `[Symbol.iterator]: () => iter`. §Self-iterable — §the-iterator-is-its-own-iterable.

§Sibling-pattern to cycle 199 trampoline's §generator-based-trampoline at §the-iterator-protocol layer.

```js
export const makeArrayIterator = arr => {
  const { length } = arr;
  let i = 0;
  return makeIterator(() => {
    let value;
    if (i < length) {
      value = arr[i];
      i += 1;
      return harden({ done: false, value });
    }
    // @ts-expect-error The terminal value doesn't matter
    return harden({ done: true, value });
  });
};
```

§Terminal-value-doesn't-matter @ts-expect-error — §honest-comment naming §why-the-type-error-is-acceptable. §The-comment-is-the-rationale.

§Borrowable-pattern: §@ts-expect-error-with-rationale-comment for §named-acceptable-type-errors.

## §objectMap + objectMetaMap + objectMetaAssign + objectExtendEach — four-shape-toolkit

§Four-related-utilities each at §different-points in the value-vs-descriptor and map-vs-extend axes:

| Utility | Level | Operation |
| --- | --- | --- |
| `objectMap` | Value-level | Map each value; result is hardened plain object |
| `objectMetaMap` | Descriptor-level | Map each descriptor; can filter via undefined; can set prototype |
| `objectMetaAssign` | Descriptor-level | Object.assign at descriptor level (all properties incl. non-enumerable) |
| `objectExtendEach` | Value-level | Extend each value with additional properties (intersection type) |

§Four-shape-toolkit covering §value-vs-descriptor × §map-vs-extend.

§The-objectMap-doc-comment-enumerates-five-edge-cases for non-CopyRecord originals:
1. The result is hardened.
2. Only string-named enumerable own properties are mapped.
3. Accessor original getters are called (using their values).
4. All result properties are non-writable, non-configurable data properties.
5. Result inherits from `Object.prototype`.

§Five-named-edge-cases per utility — §extensive-doc-comments compensate for the §non-trivial-semantics.

§Sibling-pattern to cycle 195 cli/src cluster's §example-comments-in-source-not-tests — both designs §use-doc-comments-as-runtime-spec.

## §typedEntries / typedMap / fromTypedEntries — JSDoc-typed-cast

```js
export const typedEntries = /** @type {TypedEntries} */ (Object.entries);
export const fromTypedEntries = /** @type {FromTypedEntries} */ (Object.fromEntries);
export const typedMap = /** @type {TypedMap} */ (
  Function.prototype.call.bind(Array.prototype.map)
);
```

§Three-typed-casts for §JavaScript-built-ins that have §loose-default-types. §The-typed-versions preserve §the-narrower-generic-type that the built-in doesn't.

§The-typedMap is §uncurry-this on Array.prototype.map (sibling to cycle 199 trampoline's §classic-uncurry-this and cycle 207 env-options's §Reflect.apply-form). §Two-uncurry-this-shapes now seen plus this third (`Function.prototype.call.bind(...)`). §Three-canonical-uncurry-shapes in @endo.

§Sibling-pattern to cycle 209 path-compare's §JSDoc-callback-typedef-with-generic-T — both packages use §JSDoc-typedef as §typed-cast for §generic-type-narrowing.

## §`hideAndHardenFunction` on every export

Most utilities end with `hideAndHardenFunction(applyLabelingError)` / `harden(makeIterator)` etc.

§Two-hardening-shapes:
- `hideAndHardenFunction(fn)` — hardens AND hides the function from stack traces (caller's frame is what appears).
- `harden(fn)` — hardens only.

§The-distinction-is-semantic: §error-relabeling-functions use `hideAndHardenFunction` because §they're-not-the-source-of-the-error and shouldn't appear in stack traces. §Pure-utilities use `harden` because §they-are-the-call.

§Borrowable-pattern: §hideAndHardenFunction-for-wrappers + §harden-for-leaf-utilities.

## §Borrowable patterns (tier-1)

1. **§Ten-utility-files with §one-purpose-per-file** — each file is its own export; no index.js.
2. **§Tree-shaking-friendly architecture** — package.json lists each as distinct `exports` entry; importers do deep imports.
3. **§Four-named-inclusion-criteria** for utility packages (low-level / highly-reusable / sufficiently-general / explainable-without-much-external-knowledge).
4. **§applyLabelingError** as §the-substrate-for-rich-diagnostic-tooling — sync + async error-relabeling with cause chain via `annotateError`.
5. **§throwLabeled** companion — `${label}: ${innerErr.message}` + `X\`Caused by ${innerErr}\`` cause-chain.
6. **§Fast-path-then-slow-path-for-diagnostic-quality** — when validation fails, do extra work to name what went wrong (fromUniqueEntries pattern).
7. **§fromUniqueEntries defends against user-data property-name injection** — `Object.fromEntries` silently deduplicates; fromUniqueEntries throws.
8. **§Deprecation-tags-with-forwarding-comment-to-replacement-pattern** for gradual API evolution.
9. **§SameValueZero-comparison-noted-explicitly** when utilities use Set/Map membership.
10. **§Hardening-analog-of-built-in-iterators** — `makeIterator` + `makeArrayIterator` for `harden`-friendly iteration.
11. **§Self-iterable-via-`[Symbol.iterator]: () => self`** for iterators that are their own iterable.
12. **§@ts-expect-error-with-rationale-comment** for named acceptable type errors ("The terminal value doesn't matter").
13. **§Four-shape-toolkit** (value-vs-descriptor × map-vs-extend) — objectMap / objectMetaMap / objectMetaAssign / objectExtendEach.
14. **§Five-named-edge-cases per utility** — extensive doc-comments as runtime-spec for non-trivial semantics.
15. **§JSDoc-typed-cast** for built-ins with loose default types (typedEntries / typedMap / fromTypedEntries).
16. **§Three-canonical-uncurry-shapes in @endo**: `Function.prototype.call.bind(...)` (cycle 211) + `Reflect.apply`-form (cycle 207) + `bind.bind(bind.call)` (cycle 199).
17. **§hideAndHardenFunction-for-wrappers + §harden-for-leaf-utilities** — semantic distinction between error-relabeling wrappers and leaf utilities.
18. **§Honest-cross-package-TypeScript-edges** with explanatory comments (the applyLabelingError @ts-ignore explains the cross-package type issue).
19. **§Generic-named-package-with-named-membership-rules** — `@endo/common` is the package for utilities that don't fit elsewhere.

## §Synthesis-target

Slot machine library §low-level-game-utilities-package:

- §Ten-utility-files-with-one-purpose-per-file borrowable for §game-utility-package with §tree-shaking-friendly architecture.
- §Four-named-inclusion-criteria borrowable to define §what-goes-in-the-utilities-package vs §what-goes-elsewhere.
- §applyLabelingError pattern borrowable for §game-event-pipeline-error-relabeling (label = event name; sync + async).
- §fromUniqueEntries pattern borrowable for §game-config-property-name-validation (defend against §user-config property-name injection).
- §listDifference borrowable for §missing-game-mode-diagnostic.
- §objectMap toolkit borrowable for §game-state-transformation with §five-named-edge-cases documenting the discipline.
- §JSDoc-typed-cast borrowable for §game-API-with-narrower-generics than the built-ins they wrap.
- §Tree-shaking-friendly deep-imports borrowable for §game-utilities-that-bundlers-can-eliminate.

## §Cycle 211 meta-observations

§The-forty-fifth-consecutive-designs/chat-alternation-cycle 166-211.

§Papers-lane-blocked 105+ consecutive cycles (since cycle ~106).

§Library-reaches-716-sections at cycle 211.

§Twenty-fourth-member of §small-files-with-large-knowledge-density family.

§Three-utility-cluster-shapes now in the library:
- Cycle 195 cli/src cluster (6 files, CLI layer).
- Cycle 199 trampoline/memoize/nat trio (3 packages, marshal/ocapn dependency layer).
- Cycle 211 (this) common (10 files, low-level shared layer).

§Each-cluster has §a-different-layer-and-purpose. §The-three-cluster-shapes complement each other.

§Cycle-198-patterns-diagnostic-feedback's §central-discovery (§the-data-is-already-there-just-locked) referenced §applyLabelingError as §the-substrate. §Cycle-211-ingests-that-substrate-directly. §The-cycle-198-and-cycle-211-pair completes the §design-and-substrate picture.

§Three-canonical-uncurry-shapes in @endo now observed: §bind.bind(bind.call) (cycle 199 trampoline); §Reflect.apply-form (cycle 207 env-options); §Function.prototype.call.bind(...) (cycle 211 common's typedMap). §Three-different-shapes-for-the-same-operation.
