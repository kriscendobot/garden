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
title: §prototype-preserving for `instanceof` (the canonical move)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// ensure `(c isinstance Compartment)` remains true
NewCompartment.prototype = OldCompartment.prototype;
```

§The-§prototype-aliasing: the wrapper's `.prototype` is set
to the original Compartment's `.prototype`. §This-means
`instanceof NewCompartment === instanceof OldCompartment` —
the wrapped constructor doesn't break `instanceof` checks
elsewhere in the code.

§Why-this-works: `instanceof` walks the prototype chain
looking for the constructor's `.prototype`. §If-NewCompartment-
.prototype === OldCompartment.prototype, then any instance of
either tests true against both constructors.

§Compare-to-cycle-185-check-bundle's §three-class-property-
rejection (no getter properties + no non-string values). §Both-
are-§invariant-preserving-discipline at different layers;
cycle 185 preserves "bundle is a record-of-strings"; cycle
193 preserves "instanceof Compartment".
