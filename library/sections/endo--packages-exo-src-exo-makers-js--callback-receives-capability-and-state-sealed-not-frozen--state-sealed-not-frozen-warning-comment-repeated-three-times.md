---
title: State sealed not frozen — warning comment repeated three times
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

**§the-named-state-is-sealed-not-frozen** + **§the-named-warning-comment-repeated-thrice-IS-named-load-bearing** — the comment `// Be careful not to freeze the state record` appears **three times** in the file:

- Line 88-89 (in `defineExoClass.makeInstance`)
- Line 163-164 (in `defineExoClassKit.makeInstanceKit`)
- Line 175-176 (also in `defineExoClassKit.makeInstanceKit`, just before the freeze of context)

The repetition makes the hazard impossible to miss. **§the-named-warning-IS-named-paid-by-repetition** — when a discipline is one keystroke away from violating, name it at every site. First-explicit-observation.

**§the-named-seal-vs-freeze-distinction** — JS-language fact made load-bearing. `Object.seal` prevents adding/removing properties but allows existing-property reassignment; `Object.freeze` prevents all changes. Exo state needs *reassignment* (state mutates across method calls) but not new properties (class discipline). The state must be sealed, not frozen. **§the-named-deliberate-non-freezing-of-state-record**. First-explicit-observation.

**§the-named-frozen-outer-and-sealed-inner-discipline** (line 95, 174-176) — `const context = freeze({ state, self });` — the context object is frozen, but the `state` *inside* it is only sealed. The freeze applies to the outer record's shape (state and self can't be replaced or added to); the seal on state allows its property values to mutate. §the-named-two-level-immutability-discipline. First-explicit-observation.
