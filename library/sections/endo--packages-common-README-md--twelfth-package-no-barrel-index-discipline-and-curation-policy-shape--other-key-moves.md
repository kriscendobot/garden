---
title: Other key moves
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

- **§the-named-low-level-utilities-collection** (line 3) — opening defines the package's identity as *"A collection of common low level utilities."* §the-named-collection-as-curation-not-API.

- **§the-named-src-directory-reserved-for-non-exports** (line 13) — *"Currently there are no `src/something.js` files. The only source files that would go in `src/` are those that do not represent separately exported utilities."* The `src/` directory is *reserved* for internal-only code. First-explicit-observation. Sibling to cycle 311's organization observations.

- **§the-named-README-IS-named-package-policy-not-utility-documentation** (line 17) — *"See the doc-comments within the source file of each utility for documentation of that utility."* The README documents the *package's curation policy*; the utilities document themselves via inline doc-comments. **§the-named-README-as-policy-not-API**. First-explicit-observation as a structural inversion: usually the README documents the API and the source files implement it; here the README documents *the criteria for being in the source files at all*.

- **§the-named-tests-as-examples-discipline** (line 17) — *"Sometimes the associated test files also serve as informative examples."* Tests are secondary documentation. First-explicit-observation as a recurring pattern (the test-as-example pattern appeared informally in many earlier cycles but is named here for the first time).

- **§the-named-shortest-README-in-pivot** (17 lines) — by far the shortest of the twelve pivot READMEs. Compare to:

  | Package | README lines | Category |
  |---|---|---|
  | @endo/common (333) | 17 | Collection |
  | @endo/hex (317) | 60 | Utility |
  | @endo/captp (323) | 65 | Substrate (light) |
  | @endo/nat (311) | 116 | Utility |
  | @endo/lp32 (315) | 136 | Utility |
  | @endo/stream (319) | 140 | Substrate |
  | @endo/marshal (329) | 188 | Substrate |
  | @endo/pass-style (325) | 216 | Substrate |
  | @endo/eventual-send (321) | 332 | Substrate (deep) |
  | @endo/exo (331) | 364 | Substrate (deep) |
  | @endo/patterns (327) | 415 | Substrate (deep) |

  The collection-package is the shortest; the substrate-packages are the longest; utility-packages are in between. **§the-named-README-length-tracks-package-category**.

- **§the-named-no-canonical-sections-IS-named-curation-policy-shape** — the README has *none* of the canonical sections from prior pivot READMEs (no Overview, no Quick Start, no Why X?, no Integration, no Deep Dives, no See Also). Just five short paragraphs of curation policy. The *absence* of canonical sections is itself the README's signature. First-explicit-observation.
