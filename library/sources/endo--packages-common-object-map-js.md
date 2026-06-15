---
title: "@endo/common object-map.js — Function.prototype.call.bind one-step pre-bind; five-named-edge-cases; constraint-discipline; canonical source for cycle 326/332/333 deprecation-pointers; seventh one-cycle README↔source arc"
source-slug: endo--packages-common-object-map-js
url: https://github.com/endojs/endo/blob/master/packages/common/object-map.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/common/object-map.js
total-lines: 126
ingest-cycle: 334
ingest-date: 2026-06-15
lane: chat
---

# `@endo/common object-map.js`

The 126-line object-map.js — **canonical source** for cycle 326's deprecation pointers + cycle 332's direct imports. **Twenty-fifth consecutive non-garden source after the pivot** (cycles 310-334). **§twenty-five-cycles-with-named-pivot-domain-stay**. **Twelfth package extends** (common; README → source adjacent-reverse pair).

Closes **three citation arcs**:
- Cycle 333 → 334 (1 cycle; SEVENTH one-cycle README↔source arc)
- Cycle 326 → 334 (8 cycles; deprecation-pointer-to-canonical-source)
- Cycle 332 → 334 (2 cycles; deprecation-followed-in-practice-to-canonical-source)

**§the-named-deprecation-canonical-source-arc-closure** — four-cycle chain (326 deprecation pointer → 332 followed in practice → 333 documentation-side policy → 334 canonical implementation). **§seven-cycles-with-named-one-cycle-README-source-arc**. **§forty-six-citation-arc-closures-in-pivot-now**.

## Key moves

- **§the-named-Function.prototype.call.bind-as-method-extraction** — `Function.prototype.call.bind(Array.prototype.map)` is a one-step pre-lockdown method-capture; converts a method (needs `this`) into a callable function (doesn't). **Single most structurally interesting move**. §the-named-tamper-resistance-via-pre-bind-at-module-load; §the-named-callable-form-of-prototype-method-via-bind-call; §the-named-two-shapes-of-pre-lockdown-method-capture (Reflect.apply two-step vs Function.prototype.call.bind one-step). First-explicit-observation.
- **§the-named-typed-re-export-of-native-method** — `typedEntries`/`fromTypedEntries`/`typedMap` are TypeScript-typed re-exports of native functions via inline JSDoc casts; §the-named-JSDoc-inline-cast-syntax-discipline.
- **§the-named-five-named-edge-cases-in-JSDoc** — objectMap JSDoc lists five normalization properties: hardened-output + only-string-named-enumerable-own + accessors-called + non-writable-non-configurable-data-properties + plain-Object.prototype-inheritance; §the-named-edge-cases-enumerated-in-JSDoc-discipline.
- **§the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable** — output type conditional on mapped values' passability.
- **§the-named-objectExtendEach-with-mapped-type-example** — JSDoc includes worked TypeScript example with expected type-level output as comment; §the-named-JSDoc-as-tutorial-not-just-reference.
- **§the-named-constraint-discipline** — objectExtendEach constrained to `Record<string, object>` to prevent silent gotchas (spreading a primitive yields `{}` or per-character indices); §the-named-rest-spread-of-primitive-silently-yields-empty (JS-language gotcha named explicitly); §the-named-type-and-runtime-behavior-agree-by-constraint.
- **§the-named-harden-cast-vs-harden-function-distinction** — cast-exports of intrinsics don't need additional harden (already frozen by SES); function-exports do.
- **§the-named-only-one-import** — `import harden from '@endo/harden';` is the only import; minimal-dependency discipline of @endo/common; §the-named-canonical-low-level-utility-shape (well within cycle 333's dependency-ceiling: ses + @endo/eventual-send + @endo/promise-kit).
- **§the-named-local-helpers-not-elevated-to-exports** — mapEntry + newEntries declared inside function bodies; not exported.
- **§the-named-value-first-key-second-mapper-shape** — `(value, key) => R` matches Array.prototype.map's `(element, index, array)`.
- **§twenty-five-cycles-with-named-pivot-domain-stay**, **§seven-cycles-with-named-one-cycle-README-source-arc**, **§forty-six-citation-arc-closures-in-pivot-now**, **§the-named-deprecation-canonical-source-arc-closure** (four-cycle chain).

## Section files

- [§the-named-Function.prototype.call.bind-as-method-extraction + §the-named-typed-re-export-of-native-method + §the-named-five-named-edge-cases-in-JSDoc + §the-named-constraint-discipline + 15+ more first-explicit-observations](../sections/endo--packages-common-object-map-js--Function.prototype.call.bind-pre-bind-and-edge-case-enumeration.md) — full 126-line source in scope.

## Ingest scope

Cycle 334 (chat-lane after cycle 333's designs-lane @endo/common README). Full 126-line source in scope. Twenty-fifth consecutive @endo/* source; twelfth package extends (common; README → source adjacent-reverse pair). Closes three citation arcs (cycle 333 = 1 cycle SEVENTH one-cycle arc + cycle 326 = 8 cycles deprecation-pointer-to-canonical + cycle 332 = 2 cycles deprecation-followed-to-canonical). **First-explicit-observations** including §the-named-Function.prototype.call.bind-as-method-extraction, §the-named-callable-form-of-prototype-method-via-bind-call, §the-named-tamper-resistance-via-pre-bind-at-module-load, §the-named-two-shapes-of-pre-lockdown-method-capture, §the-named-typed-re-export-of-native-method, §the-named-JSDoc-inline-cast-syntax-discipline, §the-named-five-named-edge-cases-in-JSDoc, §the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable, §the-named-objectExtendEach-with-mapped-type-example, §the-named-JSDoc-as-tutorial-not-just-reference, §the-named-constraint-discipline, §the-named-rest-spread-of-primitive-silently-yields-empty, §the-named-type-and-runtime-behavior-agree-by-constraint, §the-named-harden-cast-vs-harden-function-distinction, §the-named-only-one-import, §the-named-canonical-low-level-utility-shape, §the-named-deprecation-canonical-source-arc-closure. Multi-cycle: §twenty-five-cycles-with-named-pivot-domain-stay, §seven-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329 + 331→332 + 332→333 + 333→334), §forty-six-citation-arc-closures-in-pivot-now.
