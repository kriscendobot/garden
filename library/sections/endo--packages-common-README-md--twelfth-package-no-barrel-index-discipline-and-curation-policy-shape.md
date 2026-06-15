---
title: "@endo/common README.md — twelfth package; shortest README in pivot (17 lines); no-barrel-index discipline (inverse of cycle 326); four-named-membership-criteria; collection-package-shape; sixth one-cycle README↔source arc 332→333"
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
---

# `@endo/common README.md` — twelfth package; shortest README in pivot; no-barrel-index discipline

The 17-line README for `@endo/common` — by far the **shortest README in the pivot cluster**. Cycle 333 is **designs-lane after cycle 332's chat-lane @endo/exo src/exo-tools.js**. **Twenty-fourth consecutive non-garden source after the pivot** (cycles 310-333). **§twenty-four-cycles-with-named-pivot-domain-stay**. **§twelve-named-packages-in-the-pivot-cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + marshal + **common** — TWELFTH package adds).

**§the-named-citation-arc-from-cycle-332-takes-1-cycle-to-close** — **sixth one-cycle README↔source arc** (323→324, 325→326, 326→327, 328→329, 331→332, 332→333). **§six-cycles-with-named-one-cycle-README-source-arc**.

**§the-named-citation-arc-from-cycle-326-takes-7-cycles-to-close** as a *documentation-side closure* of cycle 326's deprecation pointers. Cycle 326's patterns/index.js had `@deprecated / Import directly from @endo/common/...` tags; cycle 332's exo-tools.js followed those pointers (implementation-side closure at 6 cycles); cycle 333 is the README of `@endo/common` itself (documentation-side closure at 7 cycles).

**§forty-three-citation-arc-closures-in-pivot-now** (41 + 2 new).

## The single most structurally interesting move

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

## §the-named-collection-package-vs-substrate-package-vs-utility-package

@endo/common reveals a three-way categorization of pivot packages, with distinct README shapes, export shapes, and curation rules:

| Category | Examples | README shape | Export shape |
|---|---|---|---|
| **Substrate** | eventual-send, pass-style, patterns, exo, marshal | Multi-section deep README with Why/Integration/Deep-Dives | Coherent API surface; barrel-index |
| **Utility** | hex, nat, memoize, lp32 | Single-purpose README with Install/Usage/API | Focused API; small export count |
| **Collection** | **common** | Curation policy + criteria | Many unrelated exports; no barrel-index |

**§the-named-collection-package-vs-substrate-package-vs-utility-package** — first-explicit-observation. The three categories explain the *variation in README shapes* observed across cycles 311 (nat) + 313 (memoize) + 315 (lp32) + 317 (hex) + 319 (stream) + 321 (eventual-send) + 323 (captp) + 325 (pass-style) + 327 (patterns) + 329 (marshal) + 331 (exo) + 333 (common).

The shape variation isn't arbitrary; it tracks the package's *role* in the family architecture. Substrate packages need to teach the reader the whole conceptual model; utility packages need to show the reader the canonical use case; collection packages need to document the curation policy so future contributors know what belongs.

## §the-named-four-named-membership-criteria-discipline

Lines 5-9 list four criteria for membership in @endo/common:

1. **Low level** — *"not depending on anything higher level than `ses`, `@endo/eventual-send`, and `@endo/promise-kit`. Many depend on nothing beyond plain old JavaScript."*
2. **Highly reusable** — *"potentially useful many places."*
3. **Sufficiently general** — *"would be awkward to import from a more specialized package."*
4. **Self-contained explainability** — *"can be explained and motivated without much external knowledge."*

**§the-named-dependency-ceiling-discipline** — criterion #1 names an *upper bound* on dependencies. The "low level" property is defined by what utilities don't depend on (three named foundations: ses + eventual-send + promise-kit). **§the-named-low-level-IS-defined-by-negation**. First-explicit-observation as a discipline-by-negation pattern.

**§the-named-four-named-membership-criteria-discipline** — first-explicit-observation. The criteria are *aspirational*: they define the package's curation policy so future contributors know what *belongs* and what *doesn't*. A utility that fails any criterion shouldn't be added to @endo/common.

The fourth criterion (*"can be explained and motivated without much external knowledge"*) is structurally striking: it constrains the utilities to be *teachable in isolation*. This is the README's *self-imposed limit* on complexity.

## §the-named-discipline-with-named-exception

Line 15 — *"Generally each utility also has its own test file. (An exception is that `make-iterator.js` is indirectly but adequately tested by `test-make-array-iterator.js`)."*

The discipline is *one test file per utility*, with a *named exception* acknowledged in the README. **§the-named-discipline-with-named-exception** — first-explicit-observation. The exception isn't a violation; it's a known and accepted deviation, named in the documentation. This is the README's *honesty about its own scope*. Sibling to cycle 326's @deprecated discipline (acknowledged-but-still-working) and cycle 320 lp32 writer's verbatim-comment-across-sibling-files (acknowledged shared content).

## Other key moves

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

## Patterns the cycle extends

- §twenty-four-cycles-with-named-pivot-domain-stay (310-333)
- §twelve-named-packages-in-the-pivot-cluster (twelfth: common)
- §six-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327, 328→329, 331→332, 332→333)
- §forty-three-citation-arc-closures-in-pivot-now (41 + 2 new)
- §the-named-citation-arc-from-cycle-326-takes-7-cycles-to-close (documentation-side closure of deprecation pointers)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags above marked first-explicit-observation. Highest-portability:

- **§the-named-no-barrel-index-discipline** with **§the-named-no-barrel-index-IS-named-inverse-of-barrel-index** (structural contrast with cycle 326)
- **§the-named-collection-package-vs-substrate-package-vs-utility-package** (three-way categorization of pivot packages)
- **§the-named-four-named-membership-criteria-discipline** (low level + highly reusable + sufficiently general + self-contained explainability)
- **§the-named-dependency-ceiling-discipline** (low-level defined by what utilities DON'T depend on)
- **§the-named-low-level-IS-defined-by-negation**
- **§the-named-one-file-one-export-with-named-export-name** with **§the-named-deep-imports-enable-tree-shaking**
- **§the-named-discipline-with-named-exception** (test file per utility; make-iterator.js named exception)
- **§the-named-README-IS-named-package-policy-not-utility-documentation**
- **§the-named-no-canonical-sections-IS-named-curation-policy-shape**
- **§the-named-README-length-tracks-package-category**
- **§the-named-src-directory-reserved-for-non-exports**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-four-cycles-with-named-pivot-domain-stay
- §twelve-named-packages-in-the-pivot-cluster
- §six-cycles-with-named-one-cycle-README-source-arc
- §forty-three-citation-arc-closures-in-pivot-now

## Tier-3 borrowing (meta-patterns)

- **§the-named-collection-package-vs-substrate-package-vs-utility-package** — three-way categorization that explains the variation in README shapes across packages; the package's *role* in the family determines its README shape
- **§the-named-no-barrel-index-discipline** as the structural inverse of barrel-index
- **§the-named-dependency-ceiling-discipline** — define "low level" by what code DOESN'T depend on (an upper-bound)
- **§the-named-low-level-IS-defined-by-negation** — discipline by negation
- **§the-named-README-as-policy-not-API** — the README documents the curation policy; the source files document themselves
- **§the-named-discipline-with-named-exception** — name the exception in the same place as the discipline; honesty about scope
- **§the-named-four-named-membership-criteria-discipline** — aspirational criteria for what belongs in a package; future contributors check against them

## Synthesis-target

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

## Library state after cycle 333

- §library-reaches-845-sections from 379 source documents
- §one-hundred-and-sixty-sixth consecutive designs-chat alternation
- §twenty-four-cycles-with-named-pivot-domain-stay
- §twelve-named-packages-in-the-pivot-cluster
- §forty-three-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-one-cycle-README-source-arc (dense pair-landing discipline across six applications)
- §the-named-collection-package-vs-substrate-package-vs-utility-package as a three-way categorization of pivot packages

## Next cycle pacing

Cycle 334 is chat-lane next. Candidate moves:

- **@endo/common/list-difference.js or object-map.js** — chat-lane; cycle 326 + 332 + 333 all named these as canonical; small files; would close the deprecation-pointers-followed arc with the actual canonical source files
- **@endo/promise-kit README** — designs-lane (defer)
- **@endo/init README** — designs-lane (defer)
- **@endo/harden README** — designs-lane (defer)

@endo/common/list-difference.js or object-map.js is the most productive (chat-lane; canonical source for the deprecation-followed pointers from cycles 326/332/333; small file allows thorough exploration). Picking freely but tracking for future work.
