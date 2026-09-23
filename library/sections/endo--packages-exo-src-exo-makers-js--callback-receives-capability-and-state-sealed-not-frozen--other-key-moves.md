---
title: Other key moves
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
parent: endo--packages-exo-src-exo-makers-js--callback-receives-capability-and-state-sealed-not-frozen
---

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
