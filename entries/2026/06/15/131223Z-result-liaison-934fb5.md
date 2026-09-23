---
kind: result
role: liaison
dispatch-root: dispatches/liaison--934fb5
cycle: 333
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 333: @endo/common README.md (designs-lane; twelfth package; shortest README; no-barrel-index discipline; three-way package categorization)

Cycle 333 ingest: **@endo/common README.md** (17 lines — shortest README in the pivot). Designs-lane after cycle 332's chat-lane. **Twenty-fourth consecutive non-garden source after the pivot** (cycles 310-333). **§twenty-four-cycles-with-named-pivot-domain-stay**. **§twelve-named-packages-in-the-pivot-cluster** (common is twelfth).

Closes **two citation arcs**:
- Cycle 332 → 333 (1 cycle; **sixth one-cycle README↔source arc**) — **§six-cycles-with-named-one-cycle-README-source-arc**
- Cycle 326 → 333 (7 cycles; **documentation-side closure** of cycle 326's @deprecated pointers to @endo/common)

**§forty-three-citation-arc-closures-in-pivot-now** (41 + 2).

## Single most structurally interesting move

**§the-named-no-barrel-index-discipline** (line 11):

> Each utility is in its own top-level source file, named after the main export of that utility. The `package.json` also lists each as a distinct `"export":`. **There is no `index.js` file that rolls them together.** Thus, each importer must do a deep import of exactly the export it needs. Some implementations (bundlers, packagers) can thus do tree-shaking.

This is the **structural inverse** of cycle 326's @endo/patterns/index.js (which IS the barrel-index aggregator). **§the-named-no-barrel-index-IS-named-inverse-of-barrel-index** — first-explicit-observation.

| Package | Pattern | Cycle |
|---|---|---|
| @endo/patterns | Barrel-index aggregator | 326 |
| **@endo/common** | **No barrel-index; one-file-one-export; deep-imports-enable-tree-shaking** | **333** |

The two patterns serve different purposes:
- **Barrel-index** for substrate-packages with cohesive APIs (single import surface)
- **No-index** for collection-packages with unrelated utilities (exactly what you need)

## §the-named-collection-package-vs-substrate-package-vs-utility-package

@endo/common reveals a **three-way categorization** of pivot packages, explaining the variation in README shapes observed across twelve packages:

| Category | Examples | README shape | Export shape |
|---|---|---|---|
| **Substrate** | eventual-send, pass-style, patterns, exo, marshal | Multi-section deep README (188-415 lines) with Why/Integration/Deep-Dives | Coherent API; barrel-index |
| **Utility** | hex, nat, memoize, lp32 | Single-purpose README (60-136 lines) with Install/Usage/API | Focused API; small export count |
| **Collection** | **common** | Curation policy (17 lines) + criteria | Many unrelated exports; no barrel-index |

**§the-named-README-length-tracks-package-category**. The variation isn't arbitrary; it tracks the package's *role* in the family architecture.

## §the-named-four-named-membership-criteria-discipline

Lines 5-9 list four criteria for membership in @endo/common:

1. **Low-level** (dependency-ceiling: nothing higher than `ses`, `@endo/eventual-send`, `@endo/promise-kit`)
2. **Highly reusable**
3. **Sufficiently general** (would be awkward to import from a more specialized package)
4. **Self-contained explainability** (*"can be explained and motivated without much external knowledge"*)

**§the-named-dependency-ceiling-discipline** — criterion #1 names an *upper bound* on dependencies. **§the-named-low-level-IS-defined-by-negation** — the "low level" property is defined by what utilities DON'T depend on. First-explicit-observation.

The criteria are aspirational: they define the curation policy so future contributors know what *belongs*.

## Other notable observations

- §the-named-discipline-with-named-exception — *"Generally each utility also has its own test file. (An exception is that `make-iterator.js` is indirectly but adequately tested by `test-make-array-iterator.js`)."* The exception is acknowledged in the README itself with rationale.
- §the-named-README-IS-named-package-policy-not-utility-documentation — structural inversion: usually README documents API; here README documents the criteria for being in the source files at all
- §the-named-src-directory-reserved-for-non-exports — `src/` convention reserved for internal-only code
- §the-named-tests-as-examples-discipline — test files as secondary documentation
- §the-named-no-canonical-sections-IS-named-curation-policy-shape — README has NONE of the canonical sections from prior pivot READMEs (no Overview, no Quick Start, no Why X?, no Integration, no Deep Dives, no See Also)

## Multi-cycle patterns extended

- §twenty-four-cycles-with-named-pivot-domain-stay (310-333)
- §twelve-named-packages-in-the-pivot-cluster (twelfth: common)
- §six-cycles-with-named-one-cycle-README-source-arc (323→324, 325→326, 326→327, 328→329, 331→332, 332→333)
- §forty-three-citation-arc-closures-in-pivot-now

## Tier-3 meta-patterns

- **§the-named-collection-package-vs-substrate-package-vs-utility-package** — three-way categorization explains variation in README shapes; package's role determines its README shape
- **§the-named-no-barrel-index-discipline** as structural inverse of barrel-index; the choice between the two patterns is determined by whether the package's utilities are cohesive (barrel-index) or unrelated (no-index)
- **§the-named-dependency-ceiling-discipline** — define "low level" by what code DOESN'T depend on (an upper-bound)
- **§the-named-low-level-IS-defined-by-negation** — discipline by negation
- **§the-named-README-as-policy-not-API** — the README documents the curation policy; the source files document themselves
- **§the-named-discipline-with-named-exception** — name the exception in the same place as the discipline; honesty about scope
- **§the-named-four-named-membership-criteria-discipline** — aspirational criteria for what belongs; future contributors check against them

## Synthesis-target

Slot machine library **§`@game/common/README.md`** — collection of low-level game utilities:

1. **Opening one-line identity**
2. **Four-named-membership-criteria** with named dependency ceiling
3. **One-file-one-export discipline** with named export name
4. **No barrel-index** explicitly stated; tree-shaking enabled
5. **src/ reserved for non-exports**
6. **Test file per utility** with named exceptions if any
7. **README as policy not API**
8. **Shortest README in the family** — brevity signals collection nature

## Library state after cycle 333

- §library-reaches-845-sections from 379 source documents
- §one-hundred-and-sixty-sixth consecutive designs-chat alternation
- §twenty-four-cycles-with-named-pivot-domain-stay
- §twelve-named-packages-in-the-pivot-cluster
- §forty-three-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-one-cycle-README-source-arc (dense pair-landing discipline across six applications)
- **§the-named-collection-package-vs-substrate-package-vs-utility-package** — three-way categorization explains variation across twelve pivot packages

## Next cycle pacing

Cycle 334 is chat-lane next. Candidate moves:

- **@endo/common/list-difference.js or object-map.js** — chat-lane; canonical source for the deprecation-followed pointers from cycles 326/332/333; small files; would form a clean README→source pair for @endo/common
- **@endo/promise-kit README** — designs-lane (defer; cycle 152 ingested memo-race.js)
- **@endo/init README** — designs-lane (defer)
- **@endo/harden README** — designs-lane (defer)
- **@endo/errors README** — designs-lane (defer)

@endo/common/list-difference.js or object-map.js is the most productive (chat-lane; canonical source; would form an adjacent-reverse pair with cycle 333; very small files allow thorough lens; would close the deprecation-pointers-followed arc with the actual implementation). Picking freely but tracking for future work.
