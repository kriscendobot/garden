---
title: "@endo/pass-style/src/makeTagged.js — the constructor counterpart to the TaggedHelper validator + the constructor-validator pair + asymmetric enumerability + Object.create with descriptor map"
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/makeTagged.js` — the constructor counterpart to the TaggedHelper validator

A 31-line file that exports `makeTagged(tag, payload)`, the **constructor** for tagged records. **Closes the loop with cycle 268's `TaggedHelper`** — cycle 268 ingested the validator that checks the structure; cycle 270 ingests the constructor that builds the structure. The two stand side by side as a constructor-validator pair.

§First-explicit-observation in library: **§the-constructor-and-validator-form-a-pair-where-the-validator-checks-what-the-constructor-builds — §`makeTagged`-builds-the-three-named-own-properties (PASS_STYLE + Symbol.toStringTag + payload) + §`TaggedHelper`-checks-the-three-named-own-properties + §the-pair-IS-the-tagged-record-protocol's-canonical-interface**.

§Two-cycles-with-constructor-validator-loops-closed (268 TaggedHelper validator + 270 makeTagged constructor); §sibling-pattern to cycle 267's spec-instance loop (CLAUDE.md spec + README instance) — §the-loop-closure-IS-an-emerging-meta-pattern.

## §The constructor structure — five operations in eleven lines

Lines 19-30:

```js
export const makeTagged = (tag, payload) => {
  typeof tag === 'string' ||
    Fail`The tag of a tagged record must be a string: ${tag}`;
  assertPassable(harden(payload));
  return harden(
    create(objectPrototype, {
      [PASS_STYLE]: { value: 'tagged' },
      [Symbol.toStringTag]: { value: tag },
      payload: { value: payload, enumerable: true },
    }),
  );
};
```

§Five-operations-in-the-constructor:

1. **§tag-must-be-string** check (line 20-21) — §the-predicate-OR-fail-idiom from cycle 260.
2. **§harden-the-payload-then-assertPassable** (line 22) — §harden-before-assert.
3. **§Object.create-with-descriptor-map** (line 24-28) — three property descriptors.
4. **§harden-the-result** (line 23, wrapping the return value).
5. **§return-the-hardened-CopyTagged**.

§First-explicit-observation in library: **§five-operations-in-a-thirty-line-constructor-with-explicit-harden-and-assertPassable-and-Object.create-and-descriptor-map**.

## §Asymmetric enumerability — payload is enumerable, marker fields are not

Lines 25-27 carry a structurally important asymmetry:

```js
[PASS_STYLE]: { value: 'tagged' },         // → non-enumerable by default
[Symbol.toStringTag]: { value: tag },      // → non-enumerable by default
payload: { value: payload, enumerable: true },  // → explicitly enumerable
```

§The-asymmetric-enumerability — §the-payload-IS-visible-to-iteration + §the-marker-fields-are-hidden; §sibling-pattern to JS's many-conventions-where-protocol-fields-are-hidden-and-user-fields-are-visible.

§The-descriptor-map's-default-behavior: `Object.defineProperty`-style descriptors default ALL boolean fields (writable + enumerable + configurable) to `false` when not specified. §the-marker-fields-default-to-non-enumerable + §the-explicit-`enumerable: true`-on-`payload`-IS-the-only-deviation; §the-default-IS-the-discipline-and-the-deviation-IS-the-feature.

§First-explicit-observation in library: **§the-asymmetric-enumerability-IS-encoded-by-omission — §the-defaults-IS-the-discipline + §the-explicit-`enumerable: true`-on-payload-IS-the-deviation + §the-pattern-`{ value: X }`-without-other-flags-IS-the-canonical-form-for-non-enumerable-protocol-fields**.

§The-validator-side (cycle 268 TaggedHelper) §assertRestValid §destructure-then-rest-then-count-zero relies on this descriptor shape — §`getOwnPropertyDescriptors(candidate)` returns the same descriptor shape that `Object.create` was given.

§First-explicit-observation in library: **§the-constructor-and-validator-share-the-descriptor-shape — §`Object.create`-with-descriptor-map-on-construction + §`Object.getOwnPropertyDescriptors`-on-validation + §the-two-functions-IS-protocol-duals**.

## §`harden(payload)` BEFORE `assertPassable` — the harden-before-assert discipline

Line 22: `assertPassable(harden(payload))`.

§The-order-IS-load-bearing — §`harden(payload)`-IS-called-first + §`assertPassable(harden(payload))`-checks-the-hardened-result; §this-IS-NOT `assertPassable(payload)` followed by `harden(payload)`.

§First-explicit-observation in library: **§the-harden-before-assert-discipline — §when-validating-a-value-as-passable, §harden-it-first-because-passability-checks-may-depend-on-the-value-being-immutable + §the-hardening-IS-part-of-the-passability-protocol-not-an-afterthought**.

§Sibling-pattern to cycle 134's make-far.js §mutate-harden-check-twice discipline; §two-cycles-with-the-harden-before-assert-discipline (134 + 270).

## §Two-level harden — harden(result) plus harden(makeTagged)

Lines 23 and 31:
- Line 23: `return harden(create(objectPrototype, {...}))` — harden the constructed result.
- Line 31: `harden(makeTagged)` — harden the factory itself.

§Two-level-harden:
- §**Result-harden** — every value the factory returns IS hardened.
- §**Factory-harden** — the factory function itself IS hardened (not just its closure-captured constants).

§First-explicit-observation in library: **§two-level-harden-discipline (result-harden + factory-harden) — §sibling-pattern to cycle 260's three-disciplines-in-one-export-line (const + harden + PascalCase-Helper-suffix) but for factory functions instead of helper-object exports**.

§The-factory-harden-IS-separate-from-the-export-statement — §`export const makeTagged = (...) => {...};` doesn't include `harden`, and then `harden(makeTagged)` appears below. §the-pattern-IS-NOT `export const makeTagged = harden((...) => {...})` because §the-recursive-`harden`-call-needs-the-named-binding.

§sibling-pattern to many factory-function exports in `@endo/*` — the harden-the-factory-after-export idiom; §first-explicit-observation in library of §the-factory-harden-after-export-idiom-IS-the-canonical-form-when-the-factory-is-named.

## §`Object.create(objectPrototype, descriptors)` — the canonical descriptor-map construction

Line 24-28:
```js
create(objectPrototype, {
  [PASS_STYLE]: { value: 'tagged' },
  [Symbol.toStringTag]: { value: tag },
  payload: { value: payload, enumerable: true },
}),
```

§The-`Object.create(proto, descriptors)`-form (rather than `{}` literal + `Object.defineProperty` × 3) carries three named advantages:

1. **§Atomicity** — all properties defined in one expression; no intermediate object state visible.
2. **§Symbol-key support** — `{ [PASS_STYLE]: ... }` works in the descriptor map; cleaner than `defineProperty(obj, PASS_STYLE, descriptor)`.
3. **§Explicit prototype** — `objectPrototype` named as the prototype; §explicit-prototype-naming-IS-the-discipline (matches `getPrototypeOf` checks in cycle 264's copyRecord).

§First-explicit-observation in library: **§three-named-advantages-of-`Object.create`-with-descriptor-map-over-object-literal-plus-defineProperty (atomicity + symbol-key support + explicit prototype)**.

§sibling-pattern to cycle 264's copyRecord destructured `{ getPrototypeOf, prototype: objectPrototype } = Object` — §the-same-`objectPrototype`-binding-is-used-by-the-constructor-and-the-validator; §the-two-files-import-the-same-prototype-reference-from-the-same-realm; §realm-aware-prototype-consistency.

## §The factory pattern — input-validation → harden-payload → assertPassable → construct → harden-result

§Five-step-factory-pattern in `makeTagged`:

1. Validate the **tag** (type-check).
2. Harden the **payload** (the user-provided value).
3. Assert the **hardened payload IS passable** (recursive check via `assertPassable`).
4. Construct the tagged record via `Object.create` with descriptor map.
5. Harden the constructed record (the top-level wrap).

§First-explicit-observation in library: **§the-five-step-factory-pattern-as-named-discipline (validate-input + harden-input + assert-input-IS-passable + construct + harden-output) — §each-step-IS-a-named-defensive-checkpoint**.

§sibling-pattern to capability-systems' make-X factory conventions; §the-factory-pattern-IS-the-canonical-form-for-constructors-in-`@endo/*`.

## §The generic typedef encodes both tag and payload types

Lines 12-18 carry a parametric typedef:
```js
/**
 * @template {string} T
 * @template {Passable} P
 * @param {T} tag
 * @param {P} payload
 * @returns {CopyTagged<T,P>}
 */
```

§Two-template-parameters:
- **`T extends string`** — the tag's literal string type.
- **`P extends Passable`** — the payload's passable type.

§The-return-type-IS-`CopyTagged<T,P>` — §the-returned-type-encodes-BOTH-the-tag-and-the-payload + §the-TypeScript-narrowing-distinguishes `CopyTagged<'foo', number>` from `CopyTagged<'bar', string>`.

§First-explicit-observation in library: **§two-template-parameters-with-`Passable`-as-constraint-and-`CopyTagged<T,P>`-as-parameterized-return-type — §the-narrowed-return-type-encodes-both-the-tag's-literal-and-the-payload's-passable-shape**.

§sibling-pattern to cycle 264's `PassStyle` string-literal-union narrowing — §narrow-types-at-the-type-system-boundary-not-just-at-the-runtime-boundary.

## §Cycle 270 first-explicit-observations roundup (eleven)

1. **§the-constructor-and-validator-form-a-pair-where-the-validator-checks-what-the-constructor-builds** (closes the loop with cycle 268).
2. **§five-operations-in-a-thirty-line-constructor**.
3. **§the-asymmetric-enumerability-IS-encoded-by-omission** (defaults are non-enumerable; explicit `enumerable: true` on payload).
4. **§the-constructor-and-validator-share-the-descriptor-shape** (`Object.create` on construction; `Object.getOwnPropertyDescriptors` on validation).
5. **§the-harden-before-assert-discipline** — `harden(payload)` BEFORE `assertPassable`.
6. **§two-level-harden-discipline** (result-harden + factory-harden).
7. **§the-factory-harden-after-export-idiom-IS-the-canonical-form-when-the-factory-is-named**.
8. **§three-named-advantages-of-`Object.create`-with-descriptor-map** (atomicity + symbol-key support + explicit prototype).
9. **§the-five-step-factory-pattern** (validate-input + harden-input + assert-input-IS-passable + construct + harden-output).
10. **§two-template-parameters-with-`Passable`-as-constraint-and-`CopyTagged<T,P>`-as-parameterized-return-type**.

Plus: §two-cycles-with-constructor-validator-loops-closed (268 + 270) + §two-cycles-with-the-harden-before-assert-discipline (134 + 270).

## §Recurring meta-pattern counters bumped at cycle 270

- §**two-cycles-with-constructor-validator-loops-closed** (268 TaggedHelper validator + 270 makeTagged constructor).
- §**two-cycles-with-the-harden-before-assert-discipline** (134 make-far + 270 makeTagged).
- §**five-cycles-with-spec-and-instance-or-validator-and-constructor-discipline-alignment** (263 fragment-vs-template + 265 spec-prescribes + 267 README-instantiates + 269 design-honors-template + 270 constructor-and-validator-pair).
- §**one-hundred-and-third consecutive designs-chat alternation cycles 166-250 + 252-270** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-constructor-validator-pair-pattern applies to the §game-engine-value-cluster:

- §**`makeGameTagged(tag, payload)`** — the constructor for tagged game values; mirrors `makeTagged`.
- §**`GameTaggedHelper`** — the validator (cycle 268 sibling).
- §**§the-asymmetric-enumerability** — the payload visible; the GAME_STYLE marker hidden.
- §**§Object.create with descriptor map** for atomic construction with symbol keys.
- §**§harden-before-assert** — `assertGameStyle(harden(payload))`.
- §**§two-level-harden** — result-harden + factory-harden.
- §**§five-step-factory-pattern** — validate-tag + harden-payload + assertGameStyle + construct + harden-result.
- §**§parameterized return type** — `GameCopyTagged<T,P>` narrows both the tag and the payload.

## §Tier-1 borrowing

§the-constructor-and-validator-form-a-pair + §five-operations-in-a-thirty-line-constructor + §the-asymmetric-enumerability-IS-encoded-by-omission + §the-constructor-and-validator-share-the-descriptor-shape + §the-harden-before-assert-discipline + §two-level-harden-discipline + §the-factory-harden-after-export-idiom + §three-named-advantages-of-`Object.create`-with-descriptor-map + §the-five-step-factory-pattern + §two-template-parameters-with-`Passable`-as-constraint-and-`CopyTagged<T,P>`-as-parameterized-return-type.

## §Tier-2 borrowing

§realm-aware-prototype-consistency (the same `objectPrototype` binding used by constructor and validator) + §the-pattern-`{ value: X }`-without-other-flags-IS-the-canonical-form-for-non-enumerable-protocol-fields.

## §Tier-3 borrowing

§two-cycles-with-constructor-validator-loops-closed (268 + 270) + §two-cycles-with-the-harden-before-assert-discipline (134 + 270) + §five-cycles-with-spec-and-instance-or-validator-and-constructor-discipline-alignment (263 + 265 + 267 + 269 + 270) + §library-reaches-776-sections at cycle 270 + §one-hundred-and-third consecutive designs-chat alternation cycles 166-250 + 252-270.

## Pattern summary (tag-prefixed)

§the-constructor-counterpart-to-the-TaggedHelper-validator + §the-constructor-and-validator-form-a-pair + §two-cycles-with-constructor-validator-loops-closed + §five-operations-in-a-thirty-line-constructor + §the-asymmetric-enumerability-IS-encoded-by-omission + §the-constructor-and-validator-share-the-descriptor-shape + §the-harden-before-assert-discipline + §two-level-harden-discipline (result-harden + factory-harden) + §the-factory-harden-after-export-idiom + §`Object.create`-with-descriptor-map + §three-named-advantages-of-`Object.create`-with-descriptor-map (atomicity + symbol-key support + explicit prototype) + §the-five-step-factory-pattern (validate-input + harden-input + assert-input-IS-passable + construct + harden-output) + §two-template-parameters-with-`Passable`-as-constraint + §`CopyTagged<T,P>`-as-parameterized-return-type + §realm-aware-prototype-consistency + §the-pattern-`{ value: X }`-as-canonical-form-for-non-enumerable-protocol-fields + §five-cycles-with-spec-and-instance-or-validator-and-constructor-discipline-alignment.
