---
title: §throwLabeled — the companion
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
