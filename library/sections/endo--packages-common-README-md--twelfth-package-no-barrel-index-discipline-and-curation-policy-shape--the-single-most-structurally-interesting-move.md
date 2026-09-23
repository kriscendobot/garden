---
title: The single most structurally interesting move
source: endo--packages-common-README-md
url: https://github.com/endojs/endo/blob/master/packages/common/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/common/README.md
total-lines: 17
ingest-cycle: 333
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-no-barrel-index-discipline
  - the-named-no-barrel-index-IS-named-inverse-of-barrel-index
  - the-named-collection-package-vs-substrate-package-vs-utility-package
  - the-named-low-level-utilities-collection
  - the-named-dependency-ceiling-discipline
  - the-named-four-named-membership-criteria-discipline
  - the-named-one-file-one-export-with-named-export-name
  - the-named-deep-imports-enable-tree-shaking
  - the-named-src-directory-reserved-for-non-exports
  - the-named-discipline-with-named-exception
  - the-named-README-IS-named-package-policy-not-utility-documentation
  - the-named-tests-as-examples-discipline
  - the-named-shortest-README-in-pivot
  - the-named-no-canonical-sections-IS-named-curation-policy-shape
  - twenty-four-cycles-with-named-pivot-domain-stay
  - twelve-named-packages-in-the-pivot-cluster
  - six-cycles-with-named-one-cycle-README-source-arc
  - forty-three-citation-arc-closures-in-pivot-now
parent: endo--packages-common-README-md--twelfth-package-no-barrel-index-discipline-and-curation-policy-shape
---

**§the-named-no-barrel-index-discipline** (line 11):

> Each utility is in its own top-level source file, named after the main export of that utility. (This is often that file's only export.) The `package.json` also lists each as a distinct `"export":`. There is no `index.js` file that rolls them together. Thus, each importer must do a deep import of exactly the export it needs. Some implementations (bundlers, packagers) can thus do tree-shaking, omitted code that isn't reachable by imports.

The discipline has three coherent parts:

1. **§the-named-one-file-one-export-with-named-export-name** — each utility lives in its own top-level file; the file is named after the export; often the file's only export
2. **§the-named-no-barrel-index** — no `index.js` aggregator
3. **§the-named-deep-imports-enable-tree-shaking** — bundlers can omit unreachable code because each import is direct

**§the-named-no-barrel-index-IS-named-inverse-of-barrel-index** — first-explicit-observation. Cycle 326's @endo/patterns/index.js IS the barrel-index aggregator (eight source files exported through one index, with deprecation tags pointing externally). @endo/common is the **structural inverse**: no aggregator, deep imports required.

| Package | Pattern | Cycle |
|---|---|---|
| @endo/patterns | Barrel-index aggregator | 326 |
| **@endo/common** | **No barrel-index; one-file-one-export** | **333** |

The two patterns serve different purposes:
- **Barrel-index** for substrate-packages where users want a *single import surface* and the package's API is *cohesive* (M-namespace + matchers + collections)
- **No-index** for collection-packages where the utilities are *unrelated* and users want *exactly what they need* (listDifference + objectMap + apply-labeling-error + etc.)

This is the **inverse of cycle 326's discipline** — and the README explicitly documents the choice and its consequence (tree-shaking). The choice isn't accidental; it's the curation policy.
