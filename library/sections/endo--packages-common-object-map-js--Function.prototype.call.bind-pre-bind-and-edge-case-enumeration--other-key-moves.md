---
title: Other key moves
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

- **§the-named-harden-on-every-export** — three harden() calls in 126 lines (line 21 typedEntries — wait, line 21 was end of list-difference.js. Let me recount for object-map.js): line 8 typedEntries cast (no harden — it's a cast of `Object.entries`), line 17 fromTypedEntries cast (no harden), line 27 typedMap (no harden), line 78 `harden(objectMap)`, line 125 `harden(objectExtendEach)`. Two of the five exports are hardened; three are casts of native functions (which are already deeply immutable in SES post-lockdown). **§the-named-harden-cast-vs-harden-function-distinction** — first-explicit-observation. Cast-exports don't need additional hardening because they're aliases of frozen-by-SES intrinsics; function-exports need harden() because they're newly defined.

- **§the-named-only-one-import** (line 1) — `import harden from '@endo/harden';` is the ONLY import. The minimal-dependency discipline of @endo/common; cycle 333 README named the dependency ceiling (ses + @endo/eventual-send + @endo/promise-kit); this file imports only harden, well within the ceiling. **§the-named-canonical-low-level-utility-shape** — first-explicit-observation. Sibling to cycle 333's §the-named-four-named-membership-criteria-discipline (criterion #1: dependency-ceiling).

- **§the-named-typedMap-IS-named-callable-Array.prototype.map** — the typedMap export's typed cast (`TypedMap`) preserves the original `Array.prototype.map`'s type information through the Function.prototype.call.bind transformation. The cast is non-trivial because `bind` strips type information; the inline `@type` cast restores it.

- **§the-named-internal-helpers-not-exported** — the file has internal helpers (`mapEntry`, `newEntries` etc. in objectMap; `newEntries` in objectExtendEach) that are declared inside the function body. These are *not* exports; they're local variables. **§the-named-local-helpers-not-elevated-to-exports** — first-explicit-observation. Discipline: keep helpers local unless they're independently useful.

- **§the-named-mapper-receives-value-then-key** (line 67) — `(value: O[K], key: K) => R` — the mapFn signature is `(value, key)`, not `(key, value)`. Same order as Array.prototype.map (which is `(element, index, array)`). **§the-named-value-first-key-second-mapper-shape**. Sibling to cycle 326's mapping disciplines.
