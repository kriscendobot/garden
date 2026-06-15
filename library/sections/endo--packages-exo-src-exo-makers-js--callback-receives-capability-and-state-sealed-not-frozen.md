---
title: "@endo/exo src/exo-makers.js — callback-receives-capability discipline; state-sealed-not-frozen warning thrice; seventh package; closes cycle 321 Defensive Objects arc"
source: endo--packages-exo-src-exo-makers-js
url: https://github.com/endojs/endo/blob/master/packages/exo/src/exo-makers.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/exo/src/exo-makers.js
total-lines: 242
ingest-cycle: 322
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-callback-receives-capability-discipline
  - the-named-introduce-and-forget-capability-handoff
  - the-named-state-is-sealed-not-frozen
  - the-named-warning-comment-repeated-thrice-IS-named-load-bearing
  - the-named-seal-vs-freeze-distinction
  - the-named-amplify-IS-named-cross-facet-access
  - the-named-circular-reference-via-late-binding
  - the-named-makeExo-IS-named-singleton-wrapper
  - the-named-defineExoClass-vs-defineExoClassKit-named-pair
  - the-named-WeakMap-contextMap-keyed-by-instance
  - the-named-isInstance-via-WeakMap-has
  - the-named-five-name-Object-destructure-at-module-load
  - the-named-import-graph-from-exo-IS-named-fan-out
  - the-named-multi-package-composition-IS-named-dependency-fanout
  - the-named-LABEL_INSTANCES-gated-debug-feature
  - the-named-instanceCount-as-named-monotonic-counter
  - the-named-emptyRecord-hardened-and-shared
  - thirteen-cycles-with-named-pivot-domain-stay
  - seven-named-packages-in-the-pivot-cluster
  - eleven-cycles-with-named-Hardened-JS-discipline
  - the-named-citation-arc-closure-with-cycle-239
  - the-named-citation-arc-closure-with-cycle-321
---

# `@endo/exo src/exo-makers.js` — capability-by-callback; state-sealed-not-frozen; seventh package

The 242-line exo-makers.js brings **@endo/exo** into the **pivot cluster** as the **seventh package** (within cycles 310-322). Cycle 322 is **chat-lane after cycle 321's designs-lane eventual-send README**. **Thirteenth consecutive non-garden source after the pivot** (cycles 310-322). **§thirteen-cycles-with-named-pivot-domain-stay**. **§seven-named-packages-in-the-pivot-cluster** (nat + memoize + hex + lp32 + stream + eventual-send + **exo**).

**Note on prior ingest**: The same file (`exo-makers.js`) was previously ingested as a **comment-fragment** in cycle 108 with a different framing — the *factory trio* lens (defineExoClass + defineExoClassKit + makeExo as a unified construction surface). This cycle 322 ingest is a **full-source re-ingest with a different lens** — the *capability-discipline* lens (callback-receives-capability + state-sealed-not-frozen + circular-reference-via-late-binding). The two ingests are complementary; the prior section file lives at `endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio.md`. **§the-named-complementary-lens-re-ingest** — when a file warrants a second look with a different framing, the new section sits alongside the prior one rather than replacing it. First-explicit-observation as a librarian discipline.

Cycle 322 closes **three citation arcs**:
- **§the-named-citation-arc-closure-with-cycle-321** — cycle 321 named *@endo/exo* as "Defensive Objects: Exos are the ideal targets for `E()`" with a worked example; cycle 322 ingests an exo source. One-cycle arc.
- **§the-named-citation-arc-closure-with-cycle-239** — cycle 239 ingested @endo/exo's `get-interface.js` (28 lines) as a tiny standalone constant file; cycle 322 ingests exo-makers.js in the new pivot framing. 83-cycle arc.
- **§the-named-citation-arc-closure-with-cycle-108** — cycle 108 ingested the same exo-makers.js file as a comment-fragment with a factory-trio framing; cycle 322 re-ingests with a complementary capability-discipline lens. 214-cycle arc — the second-longest arc closure in the pivot, after cycle 321's 255-cycle closure with cycle 66.

## The single most structurally interesting move

**§the-named-callback-receives-capability-discipline** — the `defineExoClassKit` options surface includes `receiveAmplifier` and `receiveInstanceTester`. The caller passes a *callback*; the constructor calls *that callback* with the capability:

```js
const makeKit = defineExoClassKit(tag, guards, init, methods, {
  receiveAmplifier: amplify => { /* save the amplify capability */ },
  receiveInstanceTester: isInstance => { /* save the isInstance capability */ },
});
```

This is a **capability-security pattern** that contrasts with three more common alternatives:

| Pattern | Who gets capability? |
|---|---|
| Return the capability | Caller; can freely pass to anyone |
| Constructor input | Caller must already have it |
| Global registry | Everyone has access |
| **Callback receives capability** | **Single named recipient via callback** |

**§the-named-introduce-and-forget-capability-handoff** — the capability is *born* inside the constructor, *immediately* handed to a single named recipient via callback, and then the constructor *forgets it*. The recipient holds the capability; the constructor doesn't. The discipline ensures the capability flows *one way* (constructor → receiver) and gives the *consumer* control over which downstream code receives the capability. First-explicit-observation in library.

**§the-named-option-applicability-by-shape** — `defineExoClass` (non-kit) rejects `receiveAmplifier` with an explicit error: `receiveAmplifier === undefined || Fail\`Only facets of an exo class kit can be amplified\`` (line 71-72). The amplify capability only makes sense for kits (which have multiple facets to amplify *between*); a non-kit rejects the option at construction time. §the-named-fail-on-misapplied-option; §the-named-shape-determines-which-options-are-valid. First-explicit-observation.

## State sealed not frozen — warning comment repeated three times

**§the-named-state-is-sealed-not-frozen** + **§the-named-warning-comment-repeated-thrice-IS-named-load-bearing** — the comment `// Be careful not to freeze the state record` appears **three times** in the file:

- Line 88-89 (in `defineExoClass.makeInstance`)
- Line 163-164 (in `defineExoClassKit.makeInstanceKit`)
- Line 175-176 (also in `defineExoClassKit.makeInstanceKit`, just before the freeze of context)

The repetition makes the hazard impossible to miss. **§the-named-warning-IS-named-paid-by-repetition** — when a discipline is one keystroke away from violating, name it at every site. First-explicit-observation.

**§the-named-seal-vs-freeze-distinction** — JS-language fact made load-bearing. `Object.seal` prevents adding/removing properties but allows existing-property reassignment; `Object.freeze` prevents all changes. Exo state needs *reassignment* (state mutates across method calls) but not new properties (class discipline). The state must be sealed, not frozen. **§the-named-deliberate-non-freezing-of-state-record**. First-explicit-observation.

**§the-named-frozen-outer-and-sealed-inner-discipline** (line 95, 174-176) — `const context = freeze({ state, self });` — the context object is frozen, but the `state` *inside* it is only sealed. The freeze applies to the outer record's shape (state and self can't be replaced or added to); the seal on state allows its property values to mutate. §the-named-two-level-immutability-discipline. First-explicit-observation.

## Other key moves

- **§the-named-amplify-IS-named-cross-facet-access** (line 184-196) — `amplify(exoFacet) → facets` — given one facet of a kit, returns *all* sibling facets (including the input). Iterates over each facet's WeakMap to find which contains the input. §the-named-facet-sibling-access; §the-named-amplification-IS-named-capability-uplift (a single-facet handle uplifts to the full kit). First-explicit-observation.

- **§the-named-circular-reference-via-late-binding** (line 166-176) — `const context = { state, facets: null };` (line 167) creates the context with facets unset; the facets are constructed *next* (line 169-173), each referencing the context via WeakMap; then `context.facets = facets;` (line 174) closes the cycle; finally `freeze(context);` (line 176) seals it. **§the-named-don't-freeze-context-until-facets-attached** is the discipline. First-explicit-observation.

- **§the-named-defineExoClass-vs-defineExoClassKit-named-pair** — symmetric pair of factories. ExoClass = one face; ExoClassKit = multiple facets sharing state. The kit is the multi-facet generalization. §the-named-kit-IS-multi-facet-class; §the-named-one-class-many-facets-IS-named-shape.

- **§the-named-makeExo-IS-named-singleton-wrapper** (line 232-242) — `makeExo` is a thin wrapper that calls `defineExoClass + initEmpty + makeInstance()` in one go. Returns an instance directly. §the-named-singleton-via-immediate-call; §the-named-defineExoClass-and-makeExo-relationship (class-vs-singleton).

- **§the-named-initEmpty-IS-named-init-function-stub** (line 39-46) — `const initEmpty = () => emptyRecord;` returns a shared frozen empty record. **§the-named-emptyRecord-hardened-and-shared** — `const emptyRecord = harden({})` at module scope; one frozen empty object reused across all initEmpty-based instances. Memoization at zero cost. §the-named-shared-singleton-for-zero-state.

- **§the-named-WeakMap-contextMap-keyed-by-instance** (line 74-75, 146-150) — `contextMap` maps instance → context. The context is *not accessible from outside* because the WeakMap is closed over by the maker; only methods (which receive `self`) can look up their own context via `contextMap.get(self)`. **§the-named-instance-context-via-WeakMap**; §the-named-context-is-not-accessible-from-outside (encapsulation via WeakMap). First-explicit-observation.

- **§the-named-per-facet-WeakMap-discipline** (line 146) — `const contextMapKit = objectMap(methodsKit, () => new WeakMap());` — one WeakMap *per facet name*. Each facet has its own instance-membership lookup. §the-named-contextMapKit-IS-named-one-WeakMap-per-facet. First-explicit-observation.

- **§the-named-isInstance-via-WeakMap-has** (line 105-110, 200-211) — the WeakMap is *itself* the instance-membership predicate: `contextMap.has(exo)`. No separate type-tag check; membership is determined by whether the WeakMap was set during construction. **§the-named-membership-IS-named-WeakMap-key-test**. First-explicit-observation.

- **§the-named-isInstance-with-optional-facetName** (line 200-211) — for kits, `isInstance(exo, facetName?)` can optionally filter by facet name. Three cases: no facetName (any facet matches), valid facetName (only that facet matches), invalid facetName (Fail with named error). §the-named-membership-test-with-named-filter.

- **§the-named-defineProperty-toStringTag-with-instanceCount** (line 23-34, in `makeSelf`) — when `LABEL_INSTANCES` is set, each instance gets a unique `Symbol.toStringTag` of the form `${proto[Symbol.toStringTag]}#${instanceCount}`. Manual property descriptor with `writable/enumerable/configurable: false` because debug-instance labels must be non-mutable. §the-named-debug-label-via-Symbol.toStringTag; first-explicit-observation.

- **§the-named-LABEL_INSTANCES-gated-debug-feature** (line 15) — `const LABEL_INSTANCES = environmentOptionsListHas('DEBUG', 'label-instances');` — the entire toStringTag setup is gated on this flag. §the-named-debug-flag-via-env-var; §the-named-zero-cost-when-debug-flag-off (the if-statement short-circuits cleanly).

- **§the-named-instanceCount-as-named-monotonic-counter** (line 83, 90, 158, 168) — `let instanceCount = 0; instanceCount += 1;` inside makeInstance. §the-named-counter-bumped-before-use-discipline; §the-named-monotonic-counter-for-debug-labels.

- **§the-named-five-name-Object-destructure-at-module-load** (line 12) — `const { create, seal, freeze, defineProperty, values } = Object;` — five named bindings captured. **§the-named-builtin-destructure-at-module-load** (large-form). §two-cycles-with-named-Object-destructure (cycle 310 `const { freeze } = Object;` was the smallest; cycle 322 is the largest). First-explicit-observation as a large-destructure shape.

- **§the-named-import-graph-from-exo-IS-named-fan-out** (line 1-6) — exo-makers.js imports from FIVE @endo packages (harden + common + env-options + errors + local exo-tools). **§the-named-multi-package-composition-IS-named-dependency-fanout**. The deepest import-fan-out in any pivot source so far. First-explicit-observation.

- **§the-named-objectMap-IS-named-canonical-record-functor** (lines 2, 146-150, 169-173) — `objectMap(obj, fn) → obj'` maps values while preserving keys; like Array.prototype.map but for plain objects. Used as the canonical record functor across exo. **§the-named-double-objectMap-discipline** (line 146-150 has nested objectMap calls: outer maps facetName → WeakMap; inner makes a get-from-this-WeakMap closure). First-explicit-observation.

- **§the-named-amplify-throws-if-not-a-facet** (line 192) — `throw Fail\`Must be a facet of ${q(tag)}: ${exoFacet}\`` — explicit "not a member" check via exhaustive WeakMap search. §the-named-explicit-membership-failure-with-tag.

## Patterns the cycle extends

- §thirteen-cycles-with-named-pivot-domain-stay (310-322)
- §seven-named-packages-in-the-pivot-cluster (seventh adds: exo)
- §eleven-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320 + 321 + 322 — exo source uses harden everywhere)
- §four-citation-arc-closures-in-pivot-now (cycle 319 → 315; cycle 321 → 146, 66; cycle 322 → 321, 239)
- §two-cycles-with-named-Object-destructure (310 freeze + 322 five names)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations:

- **callback-receives-capability discipline** with introduce-and-forget handoff
- **state-sealed-not-frozen** with the warning-comment-repeated-thrice load-bearing pattern
- **seal-vs-freeze distinction** at the JS-language level
- **circular-reference-via-late-binding** + bind-then-freeze discipline
- **frozen-outer-sealed-inner two-level-immutability** for context records
- **per-facet WeakMap** with **isInstance-via-WeakMap-has** for closed-over-encapsulation
- **option-applicability-by-shape** (defineExoClass rejects receiveAmplifier; ExoClassKit accepts)

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirteen-cycles-with-named-pivot-domain-stay
- §seven-named-packages-in-the-pivot-cluster
- §eleven-cycles-with-named-Hardened-JS-discipline
- §four-citation-arc-closures-in-pivot-now
- §two-cycles-with-named-Object-destructure (310 + 322; small vs large)

## Tier-3 borrowing (meta-patterns)

- **§the-named-callback-receives-capability-discipline** — capability born inside constructor, handed to single recipient via callback, then forgotten
- **§the-named-introduce-and-forget-capability-handoff** — discipline for one-way capability flow
- **§the-named-option-applicability-by-shape** — option validity depends on the constructed object's shape; fail at construction if mis-applied
- **§the-named-seal-vs-freeze-distinction** — JS-language seal-vs-freeze made load-bearing
- **§the-named-warning-comment-repeated-thrice-IS-named-load-bearing** — when a discipline is one keystroke away from violation, repeat the warning at every site
- **§the-named-frozen-outer-and-sealed-inner-discipline** — two-level immutability for records containing mutable-by-design state
- **§the-named-circular-reference-via-late-binding** — bind then freeze; resolve self-reference by stage
- **§the-named-membership-IS-named-WeakMap-key-test** — the WeakMap is itself the type predicate

## Synthesis-target

Slot machine library **§`@game/exo/src/exo-makers.js`** — defensive class factories for game entities (bet records, payout tables, RNG state holders):

1. **Callback-receives-capability** for amplify and isInstance — single named recipient via constructor callback; constructor forgets capability after handoff.
2. **State sealed not frozen** — game-state fields (current bet amount, spins remaining, jackpot accumulator) must mutate but the schema must not extend.
3. **Repeat the warning thrice** — `// Be careful not to freeze the state record` at every site where state is constructed.
4. **Frozen-outer-sealed-inner** for context records that bundle mutable state with non-mutable self/facets references.
5. **Per-facet WeakMap** for multi-facet game entities (e.g., player-facet + admin-facet); membership via `WeakMap.has`.
6. **Late-bind facets onto context** — circular references between context and facets resolved by stage; freeze last.
7. **Option-applicability-by-shape**: single-facet entities reject amplify-option at construction time with a named error.
8. **LABEL_INSTANCES debug flag** via env-var; zero-cost when off.
9. **Large Object destructure at module load** (`const { create, seal, freeze, defineProperty, values } = Object;`) for tamper-resistance.
10. **objectMap as canonical record functor**; double-objectMap for nested per-key transformations.
11. **Singleton-via-immediate-call** wrapper (`makeGameEntity = defineGameClass(...) + initEmpty + makeInstance()`) for one-off entities.
12. **emptyRecord-hardened-and-shared** at module scope for zero-state init.
