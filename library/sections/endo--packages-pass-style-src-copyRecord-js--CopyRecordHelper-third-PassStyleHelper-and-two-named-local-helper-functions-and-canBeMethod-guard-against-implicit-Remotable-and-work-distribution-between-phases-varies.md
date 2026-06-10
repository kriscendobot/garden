---
title: "@endo/pass-style/src/copyRecord.js — CopyRecordHelper third PassStyleHelper concrete instance + two named local helper functions + canBeMethod guard against implicit-Remotable + work-distribution-between-phases varies per helper"
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/copyRecord.js` — third PassStyleHelper concrete instance, completing the leaf-pass-style triplet

A 70-line file that exports `CopyRecordHelper` for the `'copyRecord'` pass-style. **Third concrete instance** of the `PassStyleHelper` shape — the library has now ingested three (cycle 260 byteArray + cycle 262 copyArray + cycle 264 copyRecord), which together form the cluster's **triplet-of-leaf-pass-style helpers** that teach the protocol's points of variation across three different substrate shapes.

§Three-cycles-with-PassStyleHelper-concrete-instance (260 byteArray + 262 copyArray + 264 copyRecord); §the-triplet-IS-the-pedagogy — §each-helper-teaches-a-different-substrate-discipline + §reading-all-three-side-by-side-reveals-the-cluster's-points-of-variation; §upgraded from cycle 262's §two-cycles-with-PassStyleHelper-concrete-instance §the-pair-IS-the-pedagogy; §the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern + §two-points-only-define-a-line.

## §The triplet-pedagogy — three points define the pattern

| Cycle | Helper            | Substrate                          | Phase-1 work                                                | Phase-2 work                                              | Side-channel arithmetic              | Notes                          |
|-------|-------------------|------------------------------------|-------------------------------------------------------------|-----------------------------------------------------------|--------------------------------------|--------------------------------|
| 260   | ByteArrayHelper   | Immutable ArrayBuffer (stage-3)    | `instanceof ArrayBuffer && candidate.immutable`             | prototype-identity + immutability + `ownKeys.length === 0`| `=== 0`                              | Adapter-factory needed         |
| 262   | CopyArrayHelper   | `Array` (universal)                | `isArray(candidate)`                                        | prototype-identity + length-shape + each-index + count    | `=== len + 1`                        | No adapter-factory             |
| 264   | CopyRecordHelper  | `Object` with `Object.prototype`   | object-prototype + each-key-string + each-value-not-method  | recursive walk only                                       | (no count-invariant)                 | Phase-1 does more work         |

§Three-points-of-variation-now-visible-across-the-triplet:

1. **§adapter-factory-presence varies**: byteArray needs one (stage-3 proposal); copyArray and copyRecord don't (universal intrinsics).
2. **§side-channel-arithmetic varies**: byteArray uses `=== 0` (no own keys); copyArray uses `=== len + 1` (length + indices); copyRecord uses **no count check at all** because §a-record's-key-set-has-no-canonical-count-invariant.
3. **§work-distribution-between-phases varies**: byteArray and copyArray do most work in phase-2; **copyRecord moves more work into phase-1** (the per-property key+value guard) and leaves phase-2 with only the recursive walk.

§First-explicit-observation in library: **§the-work-distribution-between-phases-varies-per-helper — §each-helper-puts-pass-style-specific-validation-in-the-phase-where-it-belongs**.

§First-explicit-observation in library: **§the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern**.

## §Module structure — imports plus two named local helper functions plus the helper export

Lines 1-12:
```js
import harden from '@endo/harden';
import { Fail } from '@endo/errors';
import { confirmOwnDataDescriptor } from './passStyle-helpers.js';
import { canBeMethod } from './remotable.js';

/**
 * @import {Rejector} from '@endo/errors/rejector.js';
 * @import {PassStyleHelper} from './internal-types.js';
 */

const { ownKeys } = Reflect;
const { getPrototypeOf, prototype: objectPrototype } = Object;
```

§The-three-concerns-template (cycle 260's named pattern) takes a new variation: lines 14-41 introduce **two named local helper functions** between the imports and the named-helper-export. The shape is now:

1. **§Imports + destructuring** (lines 1-12).
2. **§Two named local helper functions** (lines 14-41): `confirmObjectPrototype` + `confirmPropertyCanBeValid`.
3. **§Named-helper-export** (lines 43-70): `CopyRecordHelper`.

§First-explicit-observation in library: **§the-three-concerns-template-with-named-local-helpers-extracted — §when-confirmCanBeValid-needs-multiple-checks, §extract-each-check-into-a-named-local-function + §the-function-name-IS-the-check's-pass-style-discipline**.

§Sibling-pattern to cycle 142's pass-style helpers cluster: helpers cluster carries `confirmOwnDataDescriptor`; copyRecord carries `confirmObjectPrototype` and `confirmPropertyCanBeValid`. §the-`confirm`-prefix-IS-the-naming-convention for the predicate-with-rejecter shape; §all-three-named-local-helpers-share-the-prefix.

§Three-cycles-with-named-import-of-sibling-module-cluster-helper (260 + 262 + 264; each imports something from `./passStyle-helpers.js`); §the-discipline-is-canonical-across-the-cluster.

§Four-named-imports-in-copyRecord — `harden` (default) + `Fail` (named from @endo/errors) + `confirmOwnDataDescriptor` (named from sibling `./passStyle-helpers.js`) + `canBeMethod` (named from sibling `./remotable.js`); §the-fourth-import-is-the-cross-helper-cluster-disambiguation — copyRecord must consult the remotable cluster to know what a method looks like; §first-explicit-observation in library of §cross-helper-cluster-disambiguation-import-when-one-pass-style-must-distinguish-itself-from-another.

## §The `@import {Rejector}` JSDoc-named-protocol

Lines 6-9 (the JSDoc `@import` block):
```js
/**
 * @import {Rejector} from '@endo/errors/rejector.js';
 * @import {PassStyleHelper} from './internal-types.js';
 */
```

§The-`Rejector`-type-from-`@endo/errors/rejector.js` is the named protocol for the reject callback signature; §sibling-pattern to cycle 102's checkKey trio's Rejector vocabulary; §the-type-is-imported-via-JSDoc-`@import`-not-runtime-import — §types-only-import-via-JSDoc; §named-import-discipline-via-JSDoc-rather-than-runtime-import-when-the-import-is-types-only; §first-explicit-observation in library of §the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs-comma-separated-not-but-each-on-its-own-line.

§the-`@import`-block-IS-the-types-only-imports-list — §two-named-import-styles-across-the-cluster (runtime imports at top + JSDoc `@import` block for types-only); §two-cycles-with-types-only-`@import`-block (243 + 264 — actually look earlier cycles too; the @import discipline is throughout but the cluster-block form here is distinctive).

## §confirmObjectPrototype — the first named local helper

Lines 14-23:
```js
const confirmObjectPrototype = (candidate, reject) => {
  return (
    getPrototypeOf(candidate) === objectPrototype ||
    (reject && reject`Records must inherit from Object.prototype: ${candidate}`)
  );
};
```

§The-canonical-prototype-validation-pattern from cycles 260 + 262, now extracted into a named function — §the-direct-prototype-equality-check-IS-named.

§Three-cycles-with-direct-prototype-equality-as-canonical-validation (260 immutableArrayBufferPrototype + 262 arrayPrototype + 264 objectPrototype) — the discipline is now canonical across the cluster's leaf-helpers; §the-pattern-named-three-times-IS-the-discipline.

§The-reject-callback-pattern (cycle 260's named pattern): `reject &&` short-circuit returns the rejected diagnostic string when reject is passed; returns false (via the `||` left-falsy result) when reject is not.

§First-explicit-observation in library: **§extracting-the-canonical-prototype-check-into-a-named-local-function-is-the-shape-the-third-instance-takes — §when-a-pattern-recurs-three-times-across-siblings, §extract-it-from-each-into-a-named-helper-function**.

## §confirmPropertyCanBeValid — the second named local helper

Lines 25-41:
```js
const confirmPropertyCanBeValid = (candidate, key, value, reject) => {
  return (
    (typeof key === 'string' ||
      (reject &&
        reject`Records can only have string-named properties: ${candidate}`)) &&
    (!canBeMethod(value) ||
      (reject &&
        // TODO: Update message now that there is no such thing as "implicit Remotable".
        reject`Records cannot contain non-far functions because they may be methods of an implicit Remotable: ${candidate}`))
  );
};
```

§The-property-validator-is-a-two-rule-AND-conjunction:

1. **§Key-must-be-string** — rejects symbol-keyed properties.
2. **§Value-must-not-be-method-like** — rejects properties whose value `canBeMethod()` returns true.

§The-key-must-be-string-discipline: §record-keys-are-string-only-because-symbol-keys-carry-non-passable-identity; §sibling-pattern to cycle 148's symbol.js Hilbert-Hotel encoding — symbols ARE passable as values but NOT as keys; §the-discipline-IS-encoded-at-the-helper-level.

§The-value-must-not-be-method-like-discipline: §a-method-shaped-value-suggests-this-IS-secretly-a-Remotable + §if-it's-a-Remotable-it-should-go-through-the-RemotableHelper-not-the-CopyRecordHelper + §the-CopyRecordHelper-rejects-method-shaped-values-to-force-the-correct-pass-style; §canBeMethod-from-`./remotable.js`-IS-the-cross-cluster-disambiguation-import.

§The-TODO-comment (line 38): *"Update message now that there is no such thing as 'implicit Remotable'"*. §The-TODO-acknowledges-the-error-message-has-design-drift; §sibling-pattern to git's `TODO(name):` comment convention; §two-cycles-with-honest-TODO-acknowledgment (152 memo-race's TODO about consolidation + 264 copyRecord's TODO about message-update); §two-cycles-with-named-design-drift-acknowledged-in-comment-without-fix.

§First-explicit-observation in library: **§the-cross-cluster-disambiguation-discipline — §when-one-pass-style-could-be-confused-with-another, §the-helper-imports-the-other-helper's-detector-to-reject-the-overlap**.

## §The `every` short-circuits at first rejection

Lines 50-59 (the helper's `confirmCanBeValid`):
```js
confirmCanBeValid: (candidate, reject) => {
  return (
    confirmObjectPrototype(candidate, reject) &&
    // Reject any candidate with a symbol-keyed property or method-like property
    // (such input is potentially a Remotable).
    ownKeys(candidate).every(key =>
      confirmPropertyCanBeValid(candidate, key, candidate[key], reject),
    )
  );
},
```

§Phase-1-uses-`.every()`-over-ownKeys to enforce the per-property rules — §the-`.every()`-short-circuits-at-first-rejection + §the-reject-callback-fires-on-the-first-failing-property + §subsequent-properties-not-checked-after-rejection; §this-IS-fail-fast-with-named-property-identification.

§The-comment-on-line-53-explains-the-WHY: *"such input is potentially a Remotable"*. §the-comment-documents-why-we-distinguish-CopyRecord-from-Remotable-here-rather-than-in-RemotableHelper.

§ownKeys-IS-used-twice (in confirmCanBeValid and assertRestValid) — §a-named-redundancy + §the-comment-on-line-63-acknowledges-it (*"we already know from confirmCanBeValid that the other constraints are satisfied"*) — §sibling-pattern to cycle 262's "ensured" comment + cycle 264's reuse-after-confirmation; §three-cycles-with-doc-comment-documenting-defense-in-depth-redundancy (260 + 262 + 264).

§The-helper-DOESN'T-use-`for...of`-like-copyArray — instead uses functional `.every()`. §the-functional-style-suits-the-AND-reduction-shape; §sibling-pattern to copyArray's `for (let i = 0; i < len; i += 1)` loop; §two-cycles-with-different-iteration-styles-for-different-validation-shapes (copyArray uses indexed-for; copyRecord uses ownKeys.every) — §the-iteration-style-matches-the-validation-shape-not-the-substrate.

## §assertRestValid — only the recursive walk

Lines 61-69:
```js
assertRestValid: (candidate, passStyleOfRecur) => {
  // Validate that each own property has a recursively passable associated
  // value (we already know from confirmCanBeValid that the other constraints are
  // satisfied).
  for (const name of ownKeys(candidate)) {
    const { value } = confirmOwnDataDescriptor(candidate, name, true, Fail);
    passStyleOfRecur(value);
  }
},
```

§Phase-2-does-only-the-recursive-walk — §the-other-rejection-criteria-were-already-applied-in-phase-1; §the-comment-documents-this. §the-work-distribution-between-phases-varies-per-helper.

§For-of-loop-here — copyArray uses indexed-for; copyRecord uses for-of over ownKeys; §the-iteration-shape-suits-the-validation; §each-name-is-validated-as-`confirmOwnDataDescriptor(_, name, true, Fail)` (the `true` says enumerableRequired); §sibling-pattern to copyArray's index validation.

§The-record's-recursive-walk-is-simpler-than-copyArray's because §no-index-count-check + §no-length-check + §only-the-per-property-recursion-matters.

## §No own-keys-count check — records have no count invariant

In contrast to cycle 262 copyArray's `ownKeys(candidate).length === len + 1`, copyRecord has **no count check at all**. The implications:

- §a-record's-key-set-has-no-canonical-count-invariant — §the-keys-ARE-whatever-the-data-says-they-are.
- §the-side-channel-defense-is-different — §record-side-channels-can-only-come-via-non-string-keys-or-method-shaped-values + §those-are-caught-in-phase-1-not-via-count.
- §three-cycles-with-ownKeys-length-check-with-pass-style-specific-arithmetic-but-the-arithmetic-flavors-now-include-the-empty-set: byteArray `=== 0` + copyArray `=== len + 1` + copyRecord **no count check**; §three-cycles-with-pass-style-specific-side-channel-defense-but-not-always-arithmetic; §the-arithmetic-IS-replaced-by-key-and-value-rules-in-the-record-case.

§First-explicit-observation in library: **§the-side-channel-defense-takes-three-forms-across-the-triplet — count-zero (byteArray) + count-equal-to-len-plus-1 (copyArray) + per-key-and-per-value-rules (copyRecord)**.

## §Three orthogonal kinds-of-side-channel-defense

The triplet now demonstrates **three orthogonal kinds of side-channel-defense** appropriate to three different substrate shapes:

1. **§Count-zero** — byteArray. The substrate is opaque bytes; any own key IS a side channel.
2. **§Count-equal-to-len-plus-1** — copyArray. The substrate has required structure (`length` + indices); anything else IS a side channel.
3. **§Per-key-string-and-per-value-not-method** — copyRecord. The substrate has open structure; the side channel arrives via the *kind* of key or value, not via count.

§The-three-forms-IS-the-cluster's-side-channel-defense-vocabulary — §the-helpers-cluster-teaches-three-defense-shapes-by-instantiation; §first-explicit-observation in library of §the-cluster's-side-channel-defense-vocabulary-has-three-named-forms.

## §Cycle 264 first-explicit-observations roundup

1. **§the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern**.
2. **§the-work-distribution-between-phases-varies-per-helper** — copyRecord puts more in phase-1.
3. **§the-three-concerns-template-with-named-local-helpers-extracted** — when confirmCanBeValid needs multiple checks, extract each into a named local function.
4. **§cross-helper-cluster-disambiguation-import-when-one-pass-style-must-distinguish-itself-from-another** (canBeMethod from `./remotable.js`).
5. **§the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs**.
6. **§extracting-the-canonical-prototype-check-into-a-named-local-function-is-the-shape-the-third-instance-takes**.
7. **§the-cross-cluster-disambiguation-discipline — when one pass-style could be confused with another, the helper imports the other helper's detector to reject the overlap**.
8. **§the-side-channel-defense-takes-three-forms-across-the-triplet — count-zero + count-equal-to-len-plus-1 + per-key-and-per-value-rules**.

## §Recurring meta-pattern counters bumped at cycle 264

- §**three-cycles-with-PassStyleHelper-concrete-instance** (260 + 262 + 264) — §upgraded from §two-cycles-with to §three-cycles-with; §the-pattern-is-now-canonical-across-the-cluster.
- §**three-cycles-with-direct-prototype-equality-as-canonical-validation** (260 immutableArrayBufferPrototype + 262 arrayPrototype + 264 objectPrototype).
- §**three-cycles-with-doc-comment-documenting-defense-in-depth-redundancy** (260 + 262 + 264).
- §**three-cycles-with-the-binding-name-convention** (260 ByteArrayHelper + 262 CopyArrayHelper + 264 CopyRecordHelper).
- §**three-cycles-with-named-import-of-sibling-module-cluster-helper** (260 + 262 + 264; each imports something from `./passStyle-helpers.js`).
- §**three-cycles-with-doc-comment-IS-the-contract** at the helper level (now reified across the helpers cluster) — actually now **§five-cycles** counting 253 + 257 + 260 + 262 + 264.
- §**five-cycles-with-named-import-isolation-via-destructuring** stays at five (242 + 254 + 258 + 260 + 262); §wait-it-bumps-to-six (242 + 254 + 258 + 260 + 262 + 264) — copyRecord destructures from Object and Reflect too.
- §**six-cycles-with-named-import-isolation-via-destructuring** (242 + 254 + 258 + 260 + 262 + 264).
- §**two-cycles-with-honest-TODO-acknowledgment** (152 + 264) — §two-cycles-with-named-design-drift-acknowledged-in-comment-without-fix.
- §**two-cycles-with-destructuring-with-rename-when-source-name-is-too-generic** (262 arrayPrototype + 264 objectPrototype).
- §**ninety-seventh consecutive designs-chat alternation cycles 166-250 + 252-264 (251 was out-of-band)**.

## §Synthesis target — slot machine library

§The-triplet-of-leaf-pass-styles instantiates for game-engine as a §triplet-of-leaf-game-value-helpers:

- §**GameTokenHelper** (cycle 260 sibling) — single-byte token, no internal structure, no own keys allowed.
- §**GameRollHelper** (cycle 262 sibling) — ordered sequence (length + indices), `len + 1` own keys required.
- §**GameRecordHelper** (cycle 264 sibling) — open key-value structure, string keys only, no method-shaped values (else the value is a Remotable game-rule-callback).

§The-triplet-IS-the-pedagogy — §the-implementer-reads-all-three-side-by-side-and-sees-three-points-of-variation-in-the-cluster-pattern; §three-points-define-the-pattern-better-than-two; §the-triplet-IS-the-canonical-cluster-shape.

§Each-game-helper-extracts-its-pass-style-specific-checks-into-named-local-functions: GameTokenHelper has confirmTokenPrototype + confirmTokenImmutable; GameRollHelper has confirmRollLength + confirmRollIndices; GameRecordHelper has confirmRecordPrototype + confirmRecordKeyString + confirmRecordValueNotCallback.

§The-cross-cluster-disambiguation-discipline — §when-a-GameRecord-might-be-confused-with-a-GameRuleCallback, §GameRecordHelper-imports-canBeCallback-from-`./game-rule.js`-to-reject-the-overlap.

## §Tier-1 borrowing

§the-triplet-is-the-pedagogy + §the-work-distribution-between-phases-varies-per-helper + §the-three-concerns-template-with-named-local-helpers-extracted + §cross-helper-cluster-disambiguation-import + §the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs + §extracting-the-canonical-prototype-check-into-a-named-local-function-is-the-shape-the-third-instance-takes + §the-cross-cluster-disambiguation-discipline + §the-side-channel-defense-takes-three-forms-across-the-triplet.

## §Tier-2 borrowing

§three-cycles-with-PassStyleHelper-concrete-instance + §three-cycles-with-direct-prototype-equality-as-canonical-validation + §three-cycles-with-doc-comment-documenting-defense-in-depth-redundancy + §three-cycles-with-the-binding-name-convention + §three-cycles-with-named-import-of-sibling-module-cluster-helper + §two-cycles-with-honest-TODO-acknowledgment + §two-cycles-with-destructuring-with-rename-when-source-name-is-too-generic.

## §Tier-3 borrowing

§six-cycles-with-named-import-isolation-via-destructuring + §five-cycles-with-doc-comment-IS-the-contract + §library-reaches-770-sections at cycle 264 + §ninety-seventh consecutive designs-chat alternation cycles 166-250 + 252-264.

## Pattern summary (tag-prefixed)

§CopyRecordHelper-third-PassStyleHelper-concrete-instance + §the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern + §the-work-distribution-between-phases-varies-per-helper + §the-three-concerns-template-with-named-local-helpers-extracted + §two-named-local-helper-functions (confirmObjectPrototype + confirmPropertyCanBeValid) + §the-`confirm`-prefix-IS-the-naming-convention + §cross-helper-cluster-disambiguation-import (canBeMethod from `./remotable.js`) + §the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs + §Rejector-type-as-named-protocol-imported-via-JSDoc + §extracting-the-canonical-prototype-check-into-a-named-local-function + §three-cycles-with-direct-prototype-equality-as-canonical-validation + §key-must-be-string-discipline + §value-must-not-be-method-like-discipline + §the-cross-cluster-disambiguation-discipline + §honest-TODO-acknowledging-design-drift-without-fix + §`.every()`-short-circuits-at-first-rejection + §three-orthogonal-kinds-of-side-channel-defense (count-zero + count-equal-to-len-plus-1 + per-key-and-per-value-rules) + §the-side-channel-defense-takes-three-forms-across-the-triplet + §three-cycles-with-PassStyleHelper-concrete-instance + §three-cycles-with-the-binding-name-convention + §three-cycles-with-named-import-of-sibling-module-cluster-helper + §six-cycles-with-named-import-isolation-via-destructuring + §two-cycles-with-destructuring-with-rename-when-source-name-is-too-generic.
