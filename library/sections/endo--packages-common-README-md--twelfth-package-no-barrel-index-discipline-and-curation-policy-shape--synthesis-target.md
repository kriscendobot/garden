---
title: Synthesis-target
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

Slot machine library **§`@game/common/README.md`** — collection of low-level game utilities:

1. **Opening one-line identity**: *"A collection of common low level utilities for the slot machine library."*
2. **Four-named-membership-criteria**: low-level (named dependency ceiling) + highly reusable + sufficiently general + self-contained explainability
3. **Dependency ceiling** named explicitly (e.g., "not depending on anything higher level than `@game/random` and `@game/passable`")
4. **One-file-one-export discipline** with named export name; package.json lists each as a distinct export
5. **No barrel-index** — explicit; bundlers can tree-shake
6. **src/ reserved for non-exports** — internal-only code
7. **Test file per utility** with named exceptions if any
8. **README as policy not API** — point to doc-comments and test files for utility-specific documentation
9. **Shortest README in the family** — the brevity itself signals the package's collection nature
