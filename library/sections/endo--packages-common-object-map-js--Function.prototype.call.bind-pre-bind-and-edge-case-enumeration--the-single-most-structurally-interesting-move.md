---
title: The single most structurally interesting move
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

**§the-named-Function.prototype.call.bind-as-method-extraction** (line 27-29):

```js
export const typedMap = /** @type {TypedMap} */ (
  Function.prototype.call.bind(Array.prototype.map)
);
```

This is the **canonical pre-lockdown method-extraction technique** in @endo. Decomposed:

- `Array.prototype.map` is a method; normally called as `arr.map(fn)`
- `Function.prototype.call` lets you invoke a function with a custom `this`: `f.call(thisArg, ...args)`
- `Function.prototype.call.bind(Array.prototype.map)` pre-binds the receiver, returning a *function* that takes the array as its first argument
- When called as `typedMap(arr, fn)`, it behaves like `Array.prototype.map.call(arr, fn)`

**§the-named-callable-form-of-prototype-method-via-bind-call** — first-explicit-observation. The technique converts a *method* (which requires `this`-binding to call) into a *callable function* (which doesn't).

**§the-named-tamper-resistance-via-pre-bind-at-module-load** — the entire expression is evaluated at module load. Post-lockdown mutations to `Array.prototype.map` cannot affect `typedMap` because the binding was captured *before* lockdown.

Compare to cycle 314/318 hex encode/decode's two-step `Reflect.apply` pattern:

| Technique | Steps | Cycles |
|---|---|---|
| `const { apply } = Reflect; apply(method, thisArg, args)` | Two-step (capture + apply) | 314, 318, 328 |
| `Function.prototype.call.bind(method)` | One-step (pre-bind) | **334** |

Both achieve tamper resistance via pre-lockdown capture. The Function.prototype.call.bind technique is *more compact* (one-step) but functionally equivalent. **§the-named-two-shapes-of-pre-lockdown-method-capture** — first-explicit-observation as a parameterized discipline (capture-and-apply vs pre-bind).
