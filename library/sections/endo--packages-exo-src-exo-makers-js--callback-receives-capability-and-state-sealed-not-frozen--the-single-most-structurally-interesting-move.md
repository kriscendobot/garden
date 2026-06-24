---
title: The single most structurally interesting move
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
