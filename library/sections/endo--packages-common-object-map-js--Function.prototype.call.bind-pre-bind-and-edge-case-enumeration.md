---
title: "@endo/common object-map.js — Function.prototype.call.bind as one-step pre-bind tamper-resistance; five-named-edge-cases-in-JSDoc; constraint-discipline for type-runtime-agreement; seventh one-cycle README↔source arc"
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
---

# `@endo/common object-map.js` — Function.prototype.call.bind one-step pre-bind; five-named-edge-cases

The 126-line object-map.js — canonical source for cycle 326's deprecation pointer + cycle 332's direct import. Cycle 334 is **chat-lane after cycle 333's designs-lane @endo/common README**. **Twenty-fifth consecutive non-garden source after the pivot** (cycles 310-334). **§twenty-five-cycles-with-named-pivot-domain-stay**. **Twelfth package extends** (common; README → source adjacent-reverse pair, mirroring lp32 315-316 and patterns 326-327).

Cycle 334 closes **three citation arcs**:
- Cycle 333 → 334 (1 cycle; **seventh one-cycle README↔source arc** in source→README→source pattern)
- Cycle 326 → 334 (8 cycles; **deprecation-pointer-to-canonical-source closure**: cycle 326's `@deprecated / Import directly from @endo/common/object-map.js` arrives at THE actual file)
- Cycle 332 → 334 (2 cycles; **deprecation-followed-in-practice-to-canonical-source closure**: cycle 332 imported from this exact path; cycle 334 IS the file)

**§seven-cycles-with-named-one-cycle-README-source-arc** (323→324, 325→326, 326→327, 328→329, 331→332, 332→333, 333→334). **§forty-six-citation-arc-closures-in-pivot-now** (43 + 3).

**§the-named-deprecation-canonical-source-arc-closure** — three-cycle chain landed on the canonical source: cycle 326 deprecation pointer → cycle 332 deprecation followed in practice → cycle 333 documentation-side policy → cycle 334 canonical implementation. The deprecation discipline has now been demonstrated at four points in the chain. First-explicit-observation.

## The single most structurally interesting move

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

## §the-named-typed-re-export-of-native-method

The file's first three exports are *TypeScript-typed re-exports* of native methods:

```js
export const typedEntries = /** @type {TypedEntries} */ (Object.entries);
export const fromTypedEntries = /** @type {FromTypedEntries} */ (Object.fromEntries);
export const typedMap = /** @type {TypedMap} */ (Function.prototype.call.bind(Array.prototype.map));
```

Each export wraps a native function with a *typed cast* that preserves key/value type information through the operation. **§the-named-typed-re-export-of-native-method** — first-explicit-observation. Sibling to cycle 326's @endo/patterns/types-index.js (which used a separate file for typed re-exports because JSDoc couldn't express certain TS features); cycle 334 uses inline `/** @type {X} */ (Y)` cast expressions instead.

Note the *parenthesization*: `/** @type {X} */ (Y)` — the cast is a *JSDoc inline cast* with the value in parentheses. TS-aware tooling treats this as a type assertion. **§the-named-JSDoc-inline-cast-syntax-discipline**. First-explicit-observation.

## §the-named-five-named-edge-cases-in-JSDoc

The `objectMap` JSDoc (line 31-69) lists **five edge cases** for when the input isn't a CopyRecord:

1. *"No matter how mutable the original object, the returned object is hardened."*
2. *"Only the string-named enumerable own properties of the original are mapped. All other properties are ignored."*
3. *"If any of the original properties were accessors, `Object.entries` will cause its `getter` to be called and will use the resulting value."*
4. *"No matter whether the original property was an accessor, writable, or configurable, all the properties of the returned object will be non-writable, non-configurable, data properties."*
5. *"No matter what the original object may have inherited from, and no matter whether it was a special kind of object such as an array, the returned object will always be a plain object inheriting directly from `Object.prototype` and whose state is only these new mapped own properties."*

**§the-named-edge-cases-enumerated-in-JSDoc-discipline** — first-explicit-observation. The discipline of naming what's *almost* a CopyRecord but isn't. The reader learns the *normalization properties* of objectMap (the function actively converts the input to a CopyRecord-shaped output even if the input wasn't one).

**§the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable** (line 60-62) — *"if all the mapped values are Passable, then the returned object will be a CopyRecord."* The function's output type is conditional on the mapped values' passability. First-explicit-observation.

## §the-named-objectExtendEach-with-mapped-type-example

The `objectExtendEach` JSDoc (line 80-110) includes a *worked TypeScript example* showing the mapped-type behavior:

```js
const chains = {
  ethereum: { namespace: 'eip155', reference: '1' },
  solana: { namespace: 'solana', reference: 'mainnet' },
} as const;

const withChainId = objectExtendEach(chains, v => ({
  chainId: `${v.namespace}:${v.reference}`,
}));
// {
//   ethereum: { namespace: 'eip155'; reference: '1' } & { chainId: string };
//   solana:   { namespace: 'solana'; reference: 'mainnet' } & { chainId: string };
// }
```

**§the-named-JSDoc-as-tutorial-not-just-reference** — the JSDoc isn't just signature documentation; it's a worked example with expected type-level output shown in comment form. First-explicit-observation. Sibling to cycle 327 patterns README's Quick-Start-shows-error-output discipline.

## §the-named-constraint-discipline

Lines 104-110 explain *why* `objectExtendEach` is constrained to `Record<string, object>` rather than `Record<string, unknown>`:

> Each value in `original` must be an object, because the implementation spreads `v` (`{ ...v, ...extendFn(v, k) }`) — spreading a primitive would silently yield an empty object (or, for strings, per-character indices) and the intersection `O[K] & Ex` would collapse to `never` for primitive `O[K]`. **Constraining `O` to `Record<string, object>` makes the type and runtime behavior agree.**

**§the-named-constraint-discipline** — first-explicit-observation. The discipline of *making type and runtime behavior agree by constraining types*. The TypeScript constraint isn't arbitrary; it prevents a *silent JS-language gotcha* (spreading a primitive yields `{}` for numbers/booleans or per-character indices for strings).

**§the-named-rest-spread-of-primitive-silently-yields-empty** — first-explicit-observation. JS-language gotcha named: `{...42}` is `{}`, `{...'hello'}` is `{0: 'h', 1: 'e', 2: 'l', 3: 'l', 4: 'o'}`, and spreading either to extend with another object yields a result of useless type. The constraint discipline prevents this from compiling.

**§the-named-type-and-runtime-behavior-agree-by-constraint** — first-explicit-observation as a tier-3 meta-pattern. When the runtime would behave silently-but-wrongly for some types, constrain the TS type to exclude those cases. The constraint is *load-bearing* for correctness.

## Other key moves

- **§the-named-harden-on-every-export** — three harden() calls in 126 lines (line 21 typedEntries — wait, line 21 was end of list-difference.js. Let me recount for object-map.js): line 8 typedEntries cast (no harden — it's a cast of `Object.entries`), line 17 fromTypedEntries cast (no harden), line 27 typedMap (no harden), line 78 `harden(objectMap)`, line 125 `harden(objectExtendEach)`. Two of the five exports are hardened; three are casts of native functions (which are already deeply immutable in SES post-lockdown). **§the-named-harden-cast-vs-harden-function-distinction** — first-explicit-observation. Cast-exports don't need additional hardening because they're aliases of frozen-by-SES intrinsics; function-exports need harden() because they're newly defined.

- **§the-named-only-one-import** (line 1) — `import harden from '@endo/harden';` is the ONLY import. The minimal-dependency discipline of @endo/common; cycle 333 README named the dependency ceiling (ses + @endo/eventual-send + @endo/promise-kit); this file imports only harden, well within the ceiling. **§the-named-canonical-low-level-utility-shape** — first-explicit-observation. Sibling to cycle 333's §the-named-four-named-membership-criteria-discipline (criterion #1: dependency-ceiling).

- **§the-named-typedMap-IS-named-callable-Array.prototype.map** — the typedMap export's typed cast (`TypedMap`) preserves the original `Array.prototype.map`'s type information through the Function.prototype.call.bind transformation. The cast is non-trivial because `bind` strips type information; the inline `@type` cast restores it.

- **§the-named-internal-helpers-not-exported** — the file has internal helpers (`mapEntry`, `newEntries` etc. in objectMap; `newEntries` in objectExtendEach) that are declared inside the function body. These are *not* exports; they're local variables. **§the-named-local-helpers-not-elevated-to-exports** — first-explicit-observation. Discipline: keep helpers local unless they're independently useful.

- **§the-named-mapper-receives-value-then-key** (line 67) — `(value: O[K], key: K) => R` — the mapFn signature is `(value, key)`, not `(key, value)`. Same order as Array.prototype.map (which is `(element, index, array)`). **§the-named-value-first-key-second-mapper-shape**. Sibling to cycle 326's mapping disciplines.

## Patterns the cycle extends

- §twenty-five-cycles-with-named-pivot-domain-stay (310-334)
- §seven-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329 + 331→332 + 332→333 + 333→334)
- §forty-six-citation-arc-closures-in-pivot-now (43 + 3)
- §the-named-citation-arc-from-cycle-326-takes-8-cycles-to-close (deprecation-pointer to canonical source)
- §the-named-deprecation-canonical-source-arc-closure (four-cycle chain: 326 → 332 → 333 → 334)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation. Highest-portability:

- **§the-named-Function.prototype.call.bind-as-method-extraction** with **§the-named-tamper-resistance-via-pre-bind-at-module-load** (one-step pre-lockdown method-capture, more compact than two-step Reflect.apply)
- **§the-named-two-shapes-of-pre-lockdown-method-capture** (capture-and-apply vs pre-bind)
- **§the-named-typed-re-export-of-native-method** with inline JSDoc cast
- **§the-named-edge-cases-enumerated-in-JSDoc-discipline** (five named edge cases)
- **§the-named-constraint-discipline** (make type and runtime behavior agree by constraining types)
- **§the-named-rest-spread-of-primitive-silently-yields-empty** (JS-language gotcha named explicitly)
- **§the-named-JSDoc-as-tutorial-not-just-reference** (worked TypeScript example)
- **§the-named-harden-cast-vs-harden-function-distinction**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-five-cycles-with-named-pivot-domain-stay
- §seven-cycles-with-named-one-cycle-README-source-arc
- §forty-six-citation-arc-closures-in-pivot-now
- §the-named-deprecation-canonical-source-arc-closure (four-cycle chain)

## Tier-3 borrowing (meta-patterns)

- **§the-named-Function.prototype.call.bind-as-method-extraction** — one-step pre-lockdown method capture; transferable to any prototype method
- **§the-named-tamper-resistance-via-pre-bind-at-module-load** — same goal as Reflect.apply capture, different shape
- **§the-named-constraint-discipline** — when runtime would silently misbehave for some types, exclude those types at the type-system level; make type and runtime behavior agree by constraint
- **§the-named-edge-cases-enumerated-in-JSDoc-discipline** — name what's *almost* X but isn't (the normalization properties of a function)
- **§the-named-JSDoc-as-tutorial-not-just-reference** — worked examples in JSDoc that show expected type-level outputs
- **§the-named-harden-cast-vs-harden-function-distinction** — cast-exports don't need additional harden (intrinsics already frozen by SES); function-exports do

## Synthesis-target

Slot machine library **§`@game/common/object-map.js`** — typed object-mapping utility:

1. **Typed re-exports of native methods** with inline JSDoc casts (preserve type information through native calls)
2. **Function.prototype.call.bind for tamper-resistant method extraction** (one-step pre-lockdown capture; more compact than Reflect.apply)
3. **Five-named-edge-cases enumerated in JSDoc** for objectMap (normalization properties to CopyRecord-shape)
4. **Constraint discipline** — when runtime would silently misbehave for some types, constrain at type-system level
5. **JSDoc as tutorial** — worked examples with expected type-level outputs in comments
6. **harden-cast-vs-harden-function distinction** — cast-exports of intrinsics don't need additional harden
7. **Only-one-import discipline** — minimal dependency for low-level utility
8. **Value-first-key-second mapper shape** consistent with Array.prototype.map

## Library state after cycle 334

- §library-reaches-846-sections from 380 source documents
- §one-hundred-and-sixty-seventh consecutive designs-chat alternation
- §twenty-five-cycles-with-named-pivot-domain-stay
- §twelve-named-packages-in-the-pivot-cluster
- §forty-six-citation-arc-closures-in-pivot-now
- §seven-cycles-with-named-one-cycle-README-source-arc (dense pair-landing across seven applications — the rhythm is now firmly established)
- §the-named-deprecation-canonical-source-arc-closure (four-cycle deprecation chain: 326 → 332 → 333 → 334)
