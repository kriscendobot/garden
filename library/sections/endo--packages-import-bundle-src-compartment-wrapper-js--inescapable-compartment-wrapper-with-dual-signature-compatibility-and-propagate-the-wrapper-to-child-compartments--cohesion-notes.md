---
source: packages/import-bundle/src/compartment-wrapper.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_path: packages/import-bundle/src/compartment-wrapper.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
topics:
  - compartments
  - hardened-javascript
  - bundles
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
status: current
title: §Cohesion notes
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

- §Inescapable-compartment-pattern with §three-named-
  requirements (wrap-constructor + merge-options-in-order +
  propagate-wrapper).
- §Dual-signature-compatibility via §`__options__`-sigil
  detection: §three-detection-branches (zero / new / old) +
  §two-double-binding-asserts in old-shape.
- §`NewCompartment`-as-local-name-but-`Compartment`-as-
  function-name preserves `.name` while satisfying ESLint.
- §`new.target===undefined`-throw enforces constructor-only-
  call with §honest-uncertainty-comment about delegating to
  the real Compartment.
- §`Reflect.construct(OldCompartment, [newOptions], new.target)`
  preserves subclass inheritance.
- §`c.globalThis.Compartment = NewCompartment` propagates the
  wrapper transitively, with §named-TODO about the module-
  table-divergence future-issue.
- §`NewCompartment.prototype = OldCompartment.prototype`
  preserves `instanceof Compartment`.
- §SECURITY-NOTE comment names the non-SES leak with §"Kris
  says"-attribution and §"hard-to-fix-until-rewrite" deferral.
- §`Reflect.ownKeys`-not-`Object.keys` includes symbol-named
  + non-enumerable keys; comment cites a TC39 YouTube
  discussion and names four deviations from longer-term
  agreement.
- §writable: true, configurable: true, enumerable: false for
  globalThis-properties convention.
- §Co-located-design-doc (compartment-wrapper.md) named-three-
  requirements that the source implements.
- §Trailing-comment names §canonical-consumer (Agoric
  swingset / dynamic vats).
- §The-design-doc-and-source-adjacent is the §local-design-
  doc-pattern at package scale (cycle 190 §source-mirror-to-
  PLAN at workspace scale).
