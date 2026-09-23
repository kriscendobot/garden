---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-Function.prototype.call.bind-as-method-extraction** — one-step pre-lockdown method capture; transferable to any prototype method
- **§the-named-tamper-resistance-via-pre-bind-at-module-load** — same goal as Reflect.apply capture, different shape
- **§the-named-constraint-discipline** — when runtime would silently misbehave for some types, exclude those types at the type-system level; make type and runtime behavior agree by constraint
- **§the-named-edge-cases-enumerated-in-JSDoc-discipline** — name what's *almost* X but isn't (the normalization properties of a function)
- **§the-named-JSDoc-as-tutorial-not-just-reference** — worked examples in JSDoc that show expected type-level outputs
- **§the-named-harden-cast-vs-harden-function-distinction** — cast-exports don't need additional harden (intrinsics already frozen by SES); function-exports do
