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
kind: index
section_count: 15
---

Sections:

- [Source](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--source.md)
- [Single most structurally interesting move](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--single-most-structurally-interesting-move.md)
- [§Four-named-inclusion-criteria](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--four-named-inclusion-criteria.md)
- [§applyLabelingError — the substrate for cycle 198 patterns-diagnostic-feedback](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--applylabelingerror-the-substrate-for-cycle-198-patterns-diagnostic-feedback.md)
- [§throwLabeled — the companion](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--throwlabeled-the-companion.md)
- [§fromUniqueEntries — collision-throwing on user-data](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--fromuniqueentries-collision-throwing-on-user-data.md)
- [§identChecker — deprecated with forwarding-comment](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--identchecker-deprecated-with-forwarding-comment.md)
- [§listDifference — SameValueZero comparison](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--listdifference-samevaluezero-comparison.md)
- [§makeIterator + makeArrayIterator — hardening analog](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--makeiterator-makearrayiterator-hardening-analog.md)
- [§objectMap + objectMetaMap + objectMetaAssign + objectExtendEach — four-shape-toolkit](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--objectmap-objectmetamap-objectmetaassign-objectextendeach-four-shape-toolkit.md)
- [§typedEntries / typedMap / fromTypedEntries — JSDoc-typed-cast](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--typedentries-typedmap-fromtypedentries-jsdoc-typed-cast.md)
- [§`hideAndHardenFunction` on every export](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--hideandhardenfunction-on-every-export.md)
- [§Borrowable patterns (tier-1)](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--synthesis-target.md)
- [§Cycle 211 meta-observations](endo--packages-common--ten-utility-files-with-one-purpose-per-file-and-tree-shaking-friendly-deep-imports-and-four-named-inclusion-criteria--cycle-211-meta-observations.md)
