---
title: "@endo/common README.md — twelfth package; shortest README in pivot (17 lines); no-barrel-index discipline (inverse of cycle 326); four-named-membership-criteria; sixth one-cycle README↔source arc"
source-slug: endo--packages-common-README-md
url: https://github.com/endojs/endo/blob/master/packages/common/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/common/README.md
total-lines: 17
ingest-cycle: 333
ingest-date: 2026-06-15
lane: designs
---

# `@endo/common README.md`

The 17-line README for `@endo/common` — **shortest README in pivot**. **Twenty-fourth consecutive non-garden source after the pivot** (cycles 310-333). **§twelve-named-packages-in-the-pivot-cluster** (twelfth: common). **§six-cycles-with-named-one-cycle-README-source-arc** (332→333 is sixth).

## Key moves

- **§the-named-no-barrel-index-discipline** — explicit *"There is no `index.js` file that rolls them together"*; deep imports required; enables tree-shaking. **Single most structurally interesting move**. §the-named-no-barrel-index-IS-named-inverse-of-barrel-index (cycle 326 had barrel-index; cycle 333 is structural inverse). First-explicit-observation.
- **§the-named-collection-package-vs-substrate-package-vs-utility-package** — three-way categorization of pivot packages explaining variation in README shapes (Collection: common 17 lines; Substrate: eventual-send/pass-style/patterns/exo/marshal 188-415 lines; Utility: hex/nat/lp32/memoize 60-136 lines). First-explicit-observation.
- **§the-named-four-named-membership-criteria-discipline** — low-level (dependency-ceiling) + highly reusable + sufficiently general + self-contained explainability. §the-named-low-level-IS-defined-by-negation (defined by what utilities DON'T depend on).
- **§the-named-dependency-ceiling-discipline** — upper bound: ses + @endo/eventual-send + @endo/promise-kit. The "low level" property is by-negation.
- **§the-named-one-file-one-export-with-named-export-name** + **§the-named-deep-imports-enable-tree-shaking** — coherent design: each utility in own file named after export; bundlers can omit unreachable code.
- **§the-named-src-directory-reserved-for-non-exports** — `src/` reserved for internal-only code; doesn't exist yet but the convention is named.
- **§the-named-discipline-with-named-exception** — *"Generally each utility also has its own test file. (An exception is that `make-iterator.js` is indirectly but adequately tested by `test-make-array-iterator.js`)"*. Honesty about scope.
- **§the-named-README-IS-named-package-policy-not-utility-documentation** — README documents curation policy; utilities document themselves via inline doc-comments. §the-named-README-as-policy-not-API.
- **§the-named-tests-as-examples-discipline** — *"Sometimes the associated test files also serve as informative examples."*
- **§the-named-shortest-README-in-pivot** (17 lines) — by far the shortest of twelve pivot READMEs.
- **§the-named-no-canonical-sections-IS-named-curation-policy-shape** — README has NONE of the canonical sections from prior pivot READMEs (no Overview, no Quick Start, no Why, no Integration, no Deep Dives, no See Also).
- **§the-named-README-length-tracks-package-category**.
- **§the-named-low-level-utilities-collection** — opening defines package identity as a *collection*.
- **§twenty-four-cycles-with-named-pivot-domain-stay**, **§twelve-named-packages-in-the-pivot-cluster**, **§six-cycles-with-named-one-cycle-README-source-arc**, **§forty-three-citation-arc-closures-in-pivot-now**.

## Section files

- [§the-named-no-barrel-index-discipline + §the-named-collection-package-vs-substrate-package-vs-utility-package + §the-named-four-named-membership-criteria-discipline + 15+ more first-explicit-observations](../sections/endo--packages-common-README-md--twelfth-package-no-barrel-index-discipline-and-curation-policy-shape.md) — full 17-line README in scope.

## Ingest scope

Cycle 333 (designs-lane after cycle 332's chat-lane @endo/exo src/exo-tools.js). Full 17-line README in scope. Twenty-fourth consecutive @endo/* source; **twelfth package** added to pivot cluster (@endo/common). Closes two citation arcs: cycle 332 → 333 (1 cycle; SIXTH one-cycle README↔source arc) + cycle 326 → 333 (7 cycles; documentation-side closure of deprecation pointers). **First-explicit-observations** including §the-named-no-barrel-index-discipline, §the-named-no-barrel-index-IS-named-inverse-of-barrel-index, §the-named-collection-package-vs-substrate-package-vs-utility-package, §the-named-four-named-membership-criteria-discipline, §the-named-dependency-ceiling-discipline, §the-named-low-level-IS-defined-by-negation, §the-named-one-file-one-export-with-named-export-name, §the-named-deep-imports-enable-tree-shaking, §the-named-src-directory-reserved-for-non-exports, §the-named-discipline-with-named-exception, §the-named-README-IS-named-package-policy-not-utility-documentation, §the-named-tests-as-examples-discipline, §the-named-shortest-README-in-pivot, §the-named-no-canonical-sections-IS-named-curation-policy-shape, §the-named-README-length-tracks-package-category. Multi-cycle: §twenty-four-cycles-with-named-pivot-domain-stay, §twelve-named-packages-in-the-pivot-cluster, §six-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329 + 331→332 + 332→333), §forty-three-citation-arc-closures-in-pivot-now.
