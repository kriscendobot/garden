---
title: §the-named-collection-package-vs-substrate-package-vs-utility-package
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

@endo/common reveals a three-way categorization of pivot packages, with distinct README shapes, export shapes, and curation rules:

| Category | Examples | README shape | Export shape |
|---|---|---|---|
| **Substrate** | eventual-send, pass-style, patterns, exo, marshal | Multi-section deep README with Why/Integration/Deep-Dives | Coherent API surface; barrel-index |
| **Utility** | hex, nat, memoize, lp32 | Single-purpose README with Install/Usage/API | Focused API; small export count |
| **Collection** | **common** | Curation policy + criteria | Many unrelated exports; no barrel-index |

**§the-named-collection-package-vs-substrate-package-vs-utility-package** — first-explicit-observation. The three categories explain the *variation in README shapes* observed across cycles 311 (nat) + 313 (memoize) + 315 (lp32) + 317 (hex) + 319 (stream) + 321 (eventual-send) + 323 (captp) + 325 (pass-style) + 327 (patterns) + 329 (marshal) + 331 (exo) + 333 (common).

The shape variation isn't arbitrary; it tracks the package's *role* in the family architecture. Substrate packages need to teach the reader the whole conceptual model; utility packages need to show the reader the canonical use case; collection packages need to document the curation policy so future contributors know what belongs.
