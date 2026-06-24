---
title: §applyLabelingError — the substrate for cycle 198 patterns-diagnostic-feedback
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
parent: endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria
---

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
