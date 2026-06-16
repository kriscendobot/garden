---
title: §the-named-constraint-discipline
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

Lines 104-110 explain *why* `objectExtendEach` is constrained to `Record<string, object>` rather than `Record<string, unknown>`:

> Each value in `original` must be an object, because the implementation spreads `v` (`{ ...v, ...extendFn(v, k) }`) — spreading a primitive would silently yield an empty object (or, for strings, per-character indices) and the intersection `O[K] & Ex` would collapse to `never` for primitive `O[K]`. **Constraining `O` to `Record<string, object>` makes the type and runtime behavior agree.**

**§the-named-constraint-discipline** — first-explicit-observation. The discipline of *making type and runtime behavior agree by constraining types*. The TypeScript constraint isn't arbitrary; it prevents a *silent JS-language gotcha* (spreading a primitive yields `{}` for numbers/booleans or per-character indices for strings).

**§the-named-rest-spread-of-primitive-silently-yields-empty** — first-explicit-observation. JS-language gotcha named: `{...42}` is `{}`, `{...'hello'}` is `{0: 'h', 1: 'e', 2: 'l', 3: 'l', 4: 'o'}`, and spreading either to extend with another object yields a result of useless type. The constraint discipline prevents this from compiling.

**§the-named-type-and-runtime-behavior-agree-by-constraint** — first-explicit-observation as a tier-3 meta-pattern. When the runtime would behave silently-but-wrongly for some types, constrain the TS type to exclude those cases. The constraint is *load-bearing* for correctness.
