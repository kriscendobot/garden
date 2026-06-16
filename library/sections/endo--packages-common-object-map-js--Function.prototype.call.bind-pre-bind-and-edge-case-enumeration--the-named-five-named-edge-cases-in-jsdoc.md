---
title: §the-named-five-named-edge-cases-in-JSDoc
source: endo--packages-common-object-map-js
url: https://github.com/endojs/endo/blob/master/packages/common/object-map.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/common/object-map.js
total-lines: 126
ingest-cycle: 334
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-Function.prototype.call.bind-as-method-extraction
  - the-named-callable-form-of-prototype-method-via-bind-call
  - the-named-tamper-resistance-via-pre-bind-at-module-load
  - the-named-typed-re-export-of-native-method
  - the-named-five-named-edge-cases-in-JSDoc
  - the-named-edge-cases-enumerated-in-JSDoc-discipline
  - the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable
  - the-named-objectExtendEach-with-mapped-type-example
  - the-named-JSDoc-as-tutorial-not-just-reference
  - the-named-constraint-discipline
  - the-named-rest-spread-of-primitive-silently-yields-empty
  - the-named-harden-on-every-export
  - the-named-only-one-import
  - the-named-deprecation-canonical-source-arc-closure
  - twenty-five-cycles-with-named-pivot-domain-stay
  - seven-cycles-with-named-one-cycle-README-source-arc
  - forty-six-citation-arc-closures-in-pivot-now
parent: endo--packages-common-object-map-js--Function.prototype.call.bind-pre-bind-and-edge-case-enumeration
---

The `objectMap` JSDoc (line 31-69) lists **five edge cases** for when the input isn't a CopyRecord:

1. *"No matter how mutable the original object, the returned object is hardened."*
2. *"Only the string-named enumerable own properties of the original are mapped. All other properties are ignored."*
3. *"If any of the original properties were accessors, `Object.entries` will cause its `getter` to be called and will use the resulting value."*
4. *"No matter whether the original property was an accessor, writable, or configurable, all the properties of the returned object will be non-writable, non-configurable, data properties."*
5. *"No matter what the original object may have inherited from, and no matter whether it was a special kind of object such as an array, the returned object will always be a plain object inheriting directly from `Object.prototype` and whose state is only these new mapped own properties."*

**§the-named-edge-cases-enumerated-in-JSDoc-discipline** — first-explicit-observation. The discipline of naming what's *almost* a CopyRecord but isn't. The reader learns the *normalization properties* of objectMap (the function actively converts the input to a CopyRecord-shaped output even if the input wasn't one).

**§the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable** (line 60-62) — *"if all the mapped values are Passable, then the returned object will be a CopyRecord."* The function's output type is conditional on the mapped values' passability. First-explicit-observation.
