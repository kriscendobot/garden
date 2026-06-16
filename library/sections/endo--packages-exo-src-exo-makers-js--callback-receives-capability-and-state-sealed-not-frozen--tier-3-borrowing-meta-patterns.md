---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-callback-receives-capability-discipline** — capability born inside constructor, handed to single recipient via callback, then forgotten
- **§the-named-introduce-and-forget-capability-handoff** — discipline for one-way capability flow
- **§the-named-option-applicability-by-shape** — option validity depends on the constructed object's shape; fail at construction if mis-applied
- **§the-named-seal-vs-freeze-distinction** — JS-language seal-vs-freeze made load-bearing
- **§the-named-warning-comment-repeated-thrice-IS-named-load-bearing** — when a discipline is one keystroke away from violation, repeat the warning at every site
- **§the-named-frozen-outer-and-sealed-inner-discipline** — two-level immutability for records containing mutable-by-design state
- **§the-named-circular-reference-via-late-binding** — bind then freeze; resolve self-reference by stage
- **§the-named-membership-IS-named-WeakMap-key-test** — the WeakMap is itself the type predicate
