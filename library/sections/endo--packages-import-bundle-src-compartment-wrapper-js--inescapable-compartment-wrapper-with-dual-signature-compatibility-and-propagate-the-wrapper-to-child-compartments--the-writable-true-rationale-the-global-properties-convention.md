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
title: "§The-`writable: true`-rationale (the §global-properties-convention)"
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// properties of globalThis are generally non-enumerable
```

§But-also-§writable. §Why: globalThis properties are usually
writable; otherwise common JS patterns (`globalThis.foo = bar`)
would throw. §The-Compartment-isolates-confined-code-from-the-
outer-realm; within the Compartment, code can reassign
globalThis properties as usual.

§The-§inescapable-defense-is-not-that-the-property-is-
immutable; it's-that-§the-Compartment-constructor-is-
replaced. §If-confined-code-overwrites-`globalThis.WeakMap`,
the next `new Compartment()` will re-install the wrapped
WeakMap from `inescapableGlobalProperties`.

§Compare-to-cycle-175-make-selector.js' §race-to-install-
at-well-known-slot + §pin-on-first-install. §Cycle-193-
compartment-wrapper does §not-pin; the inescapable-defense
relies on §reinstall-per-Compartment instead. §Different-
disciplines for different-threat-models.
