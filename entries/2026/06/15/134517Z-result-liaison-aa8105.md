---
kind: result
role: liaison
dispatch-root: dispatches/liaison--aa8105
cycle: 334
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 334: @endo/common object-map.js (chat-lane; seventh one-cycle arc; four-cycle deprecation-canonical-source chain closes)

Cycle 334 ingest: **@endo/common object-map.js** (126 lines) — canonical source for cycle 326's deprecation pointers + cycle 332's direct imports + cycle 333's documentation. Chat-lane after cycle 333. **Twenty-fifth consecutive non-garden source after the pivot** (cycles 310-334). **§twenty-five-cycles-with-named-pivot-domain-stay**. **Twelfth package extends** (common; README → source adjacent-reverse pair).

Closes **three citation arcs**:
- Cycle 333 → 334 (1 cycle; **seventh one-cycle README↔source arc**)
- Cycle 326 → 334 (8 cycles; **deprecation-pointer-to-canonical-source**)
- Cycle 332 → 334 (2 cycles; **deprecation-followed-to-canonical-source**)

**§seven-cycles-with-named-one-cycle-README-source-arc** (323→324, 325→326, 326→327, 328→329, 331→332, 332→333, 333→334). **§forty-six-citation-arc-closures-in-pivot-now**.

**§the-named-deprecation-canonical-source-arc-closure** — **four-cycle chain** completes: cycle 326 (deprecation pointer) → cycle 332 (followed in practice) → cycle 333 (documentation-side policy) → **cycle 334 (canonical implementation)**. The deprecation discipline has now been demonstrated at four distinct points in the chain.

## Single most structurally interesting move

**§the-named-Function.prototype.call.bind-as-method-extraction** — line 27-29:

```js
export const typedMap = /** @type {TypedMap} */ (
  Function.prototype.call.bind(Array.prototype.map)
);
```

This is the **canonical pre-lockdown method-extraction technique** in @endo. The trick:
- `Array.prototype.map` is a method (needs `this`-binding to call)
- `Function.prototype.call.bind(method)` pre-binds the receiver, returning a callable function
- When called as `typedMap(arr, fn)`, it behaves like `Array.prototype.map.call(arr, fn)`
- Captured at module load → **tamper resistant** post-lockdown

**§the-named-two-shapes-of-pre-lockdown-method-capture** — parameterized by step-count:

| Technique | Steps | Cycles |
|---|---|---|
| `const { apply } = Reflect; apply(method, thisArg, args)` | Two-step (capture + apply) | 314, 318, 328 |
| `Function.prototype.call.bind(method)` | One-step (pre-bind) | **334** |

Both achieve tamper resistance via pre-lockdown capture. The Function.prototype.call.bind technique is *more compact* — one expression evaluated at module load, no separate capture step.

## Other notable observations

- **§the-named-typed-re-export-of-native-method** — typedEntries/fromTypedEntries/typedMap are TS-typed re-exports via inline JSDoc casts `/** @type {X} */ (Y)`; preserve key/value type information through native operations.
- **§the-named-five-named-edge-cases-in-JSDoc** — objectMap's JSDoc lists FIVE normalization properties for when input isn't a CopyRecord (hardened-output + only-string-named-enumerable-own + accessors-called + non-writable-non-configurable + plain-Object.prototype-inheritance). §the-named-edge-cases-enumerated-in-JSDoc-discipline.
- **§the-named-CopyRecord-result-IS-conditional-on-mapped-values-Passable** — output type depends on mapped values' passability.
- **§the-named-objectExtendEach-with-mapped-type-example** — JSDoc includes worked TypeScript example with expected type-level output as comment. §the-named-JSDoc-as-tutorial-not-just-reference.
- **§the-named-constraint-discipline** — objectExtendEach constrained to `Record<string, object>` to prevent silent gotchas. §the-named-rest-spread-of-primitive-silently-yields-empty (JS-language gotcha: `{...42}` is `{}`; `{...'hello'}` is per-character indices). §the-named-type-and-runtime-behavior-agree-by-constraint.
- **§the-named-harden-cast-vs-harden-function-distinction** — cast-exports of intrinsics don't need additional harden (already frozen by SES); function-exports do.
- **§the-named-only-one-import** — `import harden from '@endo/harden';` is the only import; minimal-dependency discipline for low-level utility.
- **§the-named-value-first-key-second-mapper-shape** — `(value, key) => R` matches Array.prototype.map's convention.

## Multi-cycle patterns extended

- §twenty-five-cycles-with-named-pivot-domain-stay (310-334)
- §seven-cycles-with-named-one-cycle-README-source-arc
- §forty-six-citation-arc-closures-in-pivot-now
- §the-named-deprecation-canonical-source-arc-closure (four-cycle chain: 326 → 332 → 333 → 334)
- §the-named-two-shapes-of-pre-lockdown-method-capture (Reflect.apply vs Function.prototype.call.bind)

## Tier-3 meta-patterns

- **§the-named-Function.prototype.call.bind-as-method-extraction** — one-step pre-lockdown method capture
- **§the-named-tamper-resistance-via-pre-bind-at-module-load**
- **§the-named-two-shapes-of-pre-lockdown-method-capture** — parameterized by step-count
- **§the-named-constraint-discipline** — when runtime would silently misbehave for some types, constrain at type-system level
- **§the-named-type-and-runtime-behavior-agree-by-constraint**
- **§the-named-edge-cases-enumerated-in-JSDoc-discipline** — name what's *almost* X but isn't
- **§the-named-JSDoc-as-tutorial-not-just-reference** — worked examples with expected type-level outputs
- **§the-named-harden-cast-vs-harden-function-distinction** — cast-exports of intrinsics don't need additional harden

## Synthesis-target

Slot machine library **§`@game/common/object-map.js`** — typed object-mapping utility:

1. Typed re-exports of native methods via inline JSDoc casts
2. **Function.prototype.call.bind** for tamper-resistant method extraction (one-step pre-lockdown capture)
3. Five-named-edge-cases enumerated in JSDoc for normalization-to-canonical-shape
4. Constraint discipline (exclude types that would silently misbehave at runtime)
5. JSDoc as tutorial with worked examples
6. harden-cast-vs-harden-function distinction
7. Only-one-import for low-level utility
8. Value-first-key-second mapper shape

## Library state after cycle 334

- §library-reaches-846-sections from 380 source documents
- §one-hundred-and-sixty-seventh consecutive designs-chat alternation
- §twenty-five-cycles-with-named-pivot-domain-stay
- §twelve-named-packages-in-the-pivot-cluster
- §forty-six-citation-arc-closures-in-pivot-now
- §seven-cycles-with-named-one-cycle-README-source-arc (dense pair-landing across seven applications — the rhythm is firmly established)
- §the-named-deprecation-canonical-source-arc-closure (four-cycle chain demonstrates the deprecation discipline at four points)

## Next cycle pacing

Cycle 335 is designs-lane next. Candidate moves:

- **@endo/promise-kit README** — would introduce a thirteenth package; cycle 152 ingested memo-race.js
- **@endo/init README** — designs-lane; cycle 329 marshal README + cycle 331 exo README both cite @endo/init as canonical harden installer
- **@endo/harden README** — designs-lane; harden is imported by virtually every pivot source; would close many implicit arcs
- **@endo/errors README** — designs-lane; Fail + q + X imported by many pivot sources

@endo/promise-kit README is the most productive (thirteenth package; closes cycle 152 memo-race arc which is also in the pivot lineage). Picking freely but tracking for future work.
