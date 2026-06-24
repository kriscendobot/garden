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
title: §Reflect.ownKeys-not-Object.keys (the §full-key-enumeration)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// Use Reflect.ownKeys, not Object.keys, because we want both
// string-named and symbol-named properties. Note that
// Reflect.ownKeys also includes non-enumerable keys.
// This differs from the longer term agreement discussed at
// https://www.youtube.com/watch?v=xlR21uDigGE in these ways:
// ...
for (const prop of Reflect.ownKeys(inescapableGlobalProperties)) {
  Object.defineProperty(c.globalThis, prop, {
    value: inescapableGlobalProperties[prop],
    writable: true,
    enumerable: false,  // properties of globalThis are generally non-enumerable
    configurable: true,
  });
}
```

§Three-key-enumeration-decisions named-in-the-comment:

1. **§Reflect.ownKeys-not-Object.keys**: include symbol-
   named-properties + non-enumerable.
2. **§writable-true + configurable-true + enumerable-false**:
   match the convention for globalThis properties.
3. **§defineProperty-not-assignment**: explicit-descriptor-
   shape rather than implicit defaults.

§The-comment-cites-a-YouTube-discussion (TC39 Compartments
meeting). §URL-attribution-in-source — sibling to cycle 191-
zip's §`@see` URLs to Ralph-Brown-Interrupt-List + cycle 181-
base64's RFC-4648 citation.

§The-comment-also-names-four-deviations from the longer-term
TC39 agreement: §should-be-named-inescapableGlobals + §don't-
support-*Properties-options + §move-to-Compartment-itself +
§following-assign-semantics. §An-§honest-design-evolution-
record at the §implementation-vs-spec layer.

§Compare-to-cycle-185-check-bundle's §gap-between-design-and-
implementation (cycle 180-hex-package design predicted
§retained-at-boundary; actual source migrated). §Cycle-193's
gap is between §implementation and §future-spec rather than
§implementation and §design-document.
