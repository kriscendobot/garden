---
title: §the-named-isFake-deprecated-with-named-regret
source: endo--packages-harden-README-md
url: https://github.com/endojs/endo/blob/master/packages/harden/README.md
authors: [Kris Kowal, Mark S. Miller, Jean-Francois Paradis, Endo project (collective)]
repo: endojs/endo
path: packages/harden/README.md
total-lines: 158
ingest-cycle: 337
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-tier-defense-named-in-the-opening
  - the-named-threat-model-named-first
  - the-named-supply-chain-attack-IS-named-threat-model
  - the-named-place-to-stand-toward-its-own-defense-metaphor
  - the-named-dual-purpose-of-harden
  - the-named-Object-Symbol.for-harden-intrinsic
  - the-named-intrinsic-over-endowment-discipline
  - the-named-build-condition-as-policy-knob
  - the-named-two-named-build-conditions
  - the-named-multiple-instances-first-call-wins
  - the-named-shim-like-behavior-pre-lockdown
  - the-named-with-OR-without-NOT-both-policy
  - the-named-temporal-ordering-creates-vulnerability
  - the-named-helpful-stack-on-misuse
  - the-named-stack-points-to-the-offending-module
  - the-named-isFake-deprecated-with-named-regret
  - the-named-honest-regret-in-README
  - the-named-migration-path-with-named-alternative
  - the-named-Without-HardenedJS-degradation-mode
  - the-named-partial-safety-with-named-tradeoff
  - the-named-test-and-UI-framework-acknowledgment
  - the-named-six-section-policy-README-shape
  - the-named-fourteenth-package-in-the-pivot-cluster
  - twenty-eight-cycles-with-named-pivot-domain-stay
  - fifty-six-citation-arc-closures-in-pivot-now
  - the-named-substrate-package-with-policy-README
parent: endo--packages-harden-README-md--fourteenth-package-three-tier-defense-named-in-the-opening
---

Section heading lines 127-149 — *"isFake (deprecated)"*:

> We **regret this misfeature**.

**§the-named-isFake-deprecated-with-named-regret** — first-explicit-observation. The package's own README **explicitly regrets a past design decision**. This is stronger language than "deprecated" — deprecation says *don't use this*; regret says *we made a mistake*.

**§the-named-honest-regret-in-README** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 326 @endo/patterns/index.js: @deprecated tags with canonical pointers (deprecation with redirect)
- Cycle 336 @endo/promise-kit/src/memo-race.js: §the-named-honest-TODO-with-named-obstacle (incomplete refactor honestly named)
- Cycle 337 @endo/harden README: §the-named-isFake-deprecated-with-named-regret (past design choice explicitly regretted)

**§three-shapes-of-honesty-about-past-decisions** — deprecation-with-redirect (326) + TODO-with-named-obstacle (336) + deprecated-with-named-regret (337). First-explicit-observation as a tier-3 meta-pattern.

**§the-named-migration-path-with-named-alternative** — lines 137-145:

> Code, especially tests, migrating to use `@endo/harden` should refactor `harden.isFake` to use a more legible indicator of the misbehavior of `isFrozen` and its compatriots. (...)
> For example, `Object.isFrozen({})` when `harden.isFake` and more clearly conveys the reason a test might be invalidated by `unsafe` `hardenTaming`.
> Testing that the outcome of `Object.isFrozen({})` is the same as the outcome of `Object.isFrozen(object)` for an object that should not be frozen makes a test work just as well between `safe` and `unsafe` `hardenTaming`.

The README provides the **migration code itself** for the deprecated feature. Not just *"don't use isFake"*; rather *"here's the more-legible code to use instead"*. **§the-named-migration-path-with-named-alternative** — first-explicit-observation. Compare to cycle 326's @deprecated *"Import directly from `@endo/common/list-difference.js` instead"* — different deprecation shape (pointer to canonical location); cycle 337's shape is *worked-migration-code-with-named-rationale*.

**§the-named-deprecation-explains-WHY-the-alternative-works** — first-explicit-observation. Lines 143-145 explain WHY `Object.isFrozen({})` is the right alternative: *"makes a test work just as well between `safe` and `unsafe` `hardenTaming`"*. The migration code is justified, not just provided.

**§the-named-hardenIsNoop-as-replacement-API** — line 147-148:

> The module `@endo/harden/is-noop.js` provides `hardenIsNoop(harden)` to detect whether `harden` is a no-op, regardless of `hardenTaming`.

A separate module (is-noop.js) provides a **named replacement API** for the deprecated isFake. Cycle 337 sees the README pointing to a separate file in the same package as the canonical replacement. **§the-named-deprecation-points-to-named-replacement-in-same-package** — first-explicit-observation. Compare to cycle 326's deprecation-points-to-different-package; §the-named-deprecation-points-to-named-replacement-in-same-package is the intra-package variant.
