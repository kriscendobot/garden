---
title: §the-named-typed-re-export-of-native-method
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

The file's first three exports are *TypeScript-typed re-exports* of native methods:

```js
export const typedEntries = /** @type {TypedEntries} */ (Object.entries);
export const fromTypedEntries = /** @type {FromTypedEntries} */ (Object.fromEntries);
export const typedMap = /** @type {TypedMap} */ (Function.prototype.call.bind(Array.prototype.map));
```

Each export wraps a native function with a *typed cast* that preserves key/value type information through the operation. **§the-named-typed-re-export-of-native-method** — first-explicit-observation. Sibling to cycle 326's @endo/patterns/types-index.js (which used a separate file for typed re-exports because JSDoc couldn't express certain TS features); cycle 334 uses inline `/** @type {X} */ (Y)` cast expressions instead.

Note the *parenthesization*: `/** @type {X} */ (Y)` — the cast is a *JSDoc inline cast* with the value in parentheses. TS-aware tooling treats this as a type assertion. **§the-named-JSDoc-inline-cast-syntax-discipline**. First-explicit-observation.
