---
title: Synthesis-target
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
