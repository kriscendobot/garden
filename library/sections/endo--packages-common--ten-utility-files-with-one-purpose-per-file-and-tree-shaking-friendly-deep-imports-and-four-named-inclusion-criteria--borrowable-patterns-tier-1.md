---
title: §Borrowable patterns (tier-1)
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
