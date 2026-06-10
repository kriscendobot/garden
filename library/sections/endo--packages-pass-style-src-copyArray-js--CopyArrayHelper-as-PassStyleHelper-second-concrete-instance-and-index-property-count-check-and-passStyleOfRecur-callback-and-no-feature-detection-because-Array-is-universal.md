---
title: "@endo/pass-style/src/copyArray.js — CopyArrayHelper second PassStyleHelper concrete instance + index-property-count check + passStyleOfRecur callback + no feature-detection because Array is universal"
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/copyArray.js` — second PassStyleHelper concrete instance, structurally simpler than byteArray

A 38-line file that exports `CopyArrayHelper` for the `'copyArray'` pass-style. **Second concrete instance** of the `PassStyleHelper` shape ingested into the library (the first was cycle 260's [byteArray.js](endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline.md)); the helpers cluster's uniform shape was documented at the helpers-cluster sibling page.

§Two-cycles-with-PassStyleHelper-concrete-instance (260 byteArray + 262 copyArray); §the-two-helpers-stand-side-by-side-as-the-canonical-pair-the-cluster-uses-to-teach-the-pattern; §each-helper-illustrates-a-different-substrate-relationship: byteArray depends on a stage-3 proposal and needs §feature-detection-at-module-load + §adapter-factory; copyArray uses the universal `Array` intrinsic and needs §no-adapter-factory; §the-pair-IS-the-pedagogy.

## §Module structure — the three concerns template with adapter-factory step omitted

Cycle 260's byteArray.js had §the-three-concerns-template: (1) imports + destructuring + (2) **adapter factory** + (3) named-helper-export. Cycle 262's copyArray.js has §the-template-with-the-middle-step-omitted: (1) imports + destructuring + (3) named-helper-export. §The-template-flexes-to-its-concrete-instance — §when-the-substrate-is-a-universal-intrinsic-no-adapter-factory-is-needed.

§first-explicit-observation in library: **§the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic** — the §two-helpers-side-by-side-make-this-conditional-explicit; §the-adapter-factory-IS-a-feature-detection-step + §it-is-needed-only-when-the-substrate-is-conditional.

## §Imports + destructuring at the top

Lines 1-7:

```js
import harden from '@endo/harden';
import { Fail, X } from '@endo/errors';
import { confirmOwnDataDescriptor } from './passStyle-helpers.js';

const { getPrototypeOf } = Object;
const { ownKeys } = Reflect;
const { isArray, prototype: arrayPrototype } = Array;
```

§Three-named-import-styles in seven lines:

1. **§Default import** — `harden` from `@endo/harden` (cycle 254/258 sibling — the canonical lockdown vocabulary).
2. **§Named imports** — `{ Fail, X }` from `@endo/errors` (the structured-errors vocabulary).
3. **§Sibling-module import** — `confirmOwnDataDescriptor` from `./passStyle-helpers.js` (the cluster's shared helpers — referenced by name not by namespace).

§Three-named-destructurings of platform intrinsics:

- `const { getPrototypeOf } = Object;` — §canonical-prototype-walker (matches byteArray's line 8).
- `const { ownKeys } = Reflect;` — §all-own-keys-including-symbols-and-non-enumerable (matches byteArray's line 9).
- `const { isArray, prototype: arrayPrototype } = Array;` — §two-destructurings-from-one-source-with-rename — `Array.prototype` becomes `arrayPrototype` for readability + `Array.isArray` becomes `isArray` without rename.

§The-rename-of-`prototype`-to-`arrayPrototype` — §destructuring-with-rename-when-the-source-name-is-too-generic; §sibling-pattern to cycle 260's destructuring of Object/Reflect (those don't need rename because the source method names are specific); §the-rename-IS-the-readability-fix-for-a-source-name-too-generic-for-the-local-scope; §first-explicit-observation in library of §destructuring-with-rename-when-source-name-is-too-generic.

§Five-cycles-with-named-import-isolation-via-destructuring (242 elevator + 254 no-shim + 258 curated-re-export + 260 byteArray + 262 copyArray) — §discipline-now-canonical-across-five-cycles.

§Sibling-module-import-by-named-function — `confirmOwnDataDescriptor` is the cluster's §shared-helper-imported-by-name; §each-PassStyleHelper-can-call-into-shared-validation-logic-without-re-implementing-it; §first-explicit-observation in library of §shared-validation-helper-imported-by-name-into-each-PassStyleHelper.

## §The CopyArrayHelper export structure

Lines 9-38:

```js
/**
 *
 * @type {import('./internal-types.js').PassStyleHelper}
 */
export const CopyArrayHelper = harden({
  styleName: 'copyArray',

  confirmCanBeValid: (candidate, reject) =>
    isArray(candidate) || (reject && reject`Array expected: ${candidate}`),

  assertRestValid: (candidate, passStyleOfRecur) => {
    getPrototypeOf(candidate) === arrayPrototype ||
      assert.fail(X`Malformed array: ${candidate}`, TypeError);
    // Since we're already ensured candidate is an array, it should not be
    // possible for the following get to fail.
    const len = /** @type {number} */ (
      confirmOwnDataDescriptor(candidate, 'length', false, Fail).value
    );
    // Validate that each index property is own/data/enumerable
    // and its associated value is recursively passable.
    for (let i = 0; i < len; i += 1) {
      passStyleOfRecur(
        confirmOwnDataDescriptor(candidate, i, true, Fail).value,
      );
    }
    // Expect one key per index plus one for 'length'.
    ownKeys(candidate).length === len + 1 ||
      assert.fail(X`Arrays must not have non-indexes: ${candidate}`, TypeError);
  },
});
```

§Three-disciplines-in-one-export-line (cycle 260 sibling) — `export const CopyArrayHelper = harden({...})`: const + harden + PascalCase-with-Helper-suffix. §The-binding-name-convention is consistent across both helpers; §the-style-name-pattern in lowercase camelCase too (`'copyArray'` mirrors `'byteArray'`).

§Two-cycles-with-the-binding-name-convention (260 ByteArrayHelper + 262 CopyArrayHelper); §discipline-now-emergent-pattern-across-the-cluster.

## §confirmCanBeValid uses isArray as the loose phase-1 check

Line 16-17:
```js
confirmCanBeValid: (candidate, reject) =>
  isArray(candidate) || (reject && reject`Array expected: ${candidate}`),
```

§Phase-1-loose-check uses `Array.isArray` not `instanceof Array`:

- §`Array.isArray`-IS-the-canonical-realm-aware-array-test — works across cross-realm boundaries (a TypedArray from another realm passes `isArray` but fails `instanceof Array`); §sibling-pattern to cycle 142's pass-style realm-aware checks.
- §the-helper-uses-`isArray`-not-`instanceof`-at-phase-1 — §loose-shape-question-uses-realm-aware-API-not-instance-walking; §the-phase-1-question-is-"is-this-an-array-at-all?".
- §the-phase-2-question-asks-something-tighter (whether the prototype is the realm's `Array.prototype` exactly).

§Two-cycles-with-phase-1-uses-realm-aware-platform-test (260 instanceof-ArrayBuffer-loose + 262 isArray-realm-aware) — §each-helper-picks-the-right-realm-aware-shape-test-for-its-substrate; §sibling-pattern that emerges from the §two-helpers-side-by-side.

§The-`reject &&`-short-circuit on line 17 — same as byteArray's line 55; §the-reject-callback-pattern-from-the-helpers-cluster.

## §assertRestValid carries four-line validity check (one more line than byteArray)

The phase-2 check has **four orthogonal rejection criteria** (one more than byteArray's three):

1. **§Prototype-identity** — `getPrototypeOf(candidate) === arrayPrototype` (lines 20-21). Strict equality, not instanceof.
2. **§Length-property-shape** — `confirmOwnDataDescriptor(candidate, 'length', false, Fail)` validates that `length` is an own data property (not an accessor; not inherited). `false` says non-enumerable is OK (Array.prototype.length is canonically non-enumerable).
3. **§Each-index-shape-and-recursive-passable** — loop from `0` to `len-1`; each index validated via `confirmOwnDataDescriptor(candidate, i, true, Fail)` (the `true` says enumerable required); each value recursively walked via `passStyleOfRecur`.
4. **§Index-property-count-check** — `ownKeys(candidate).length === len + 1` — the `+1` accounts for `length`; this rejects sparse arrays AND arrays with extra non-index own properties.

§Four-line-validity-check-with-four-orthogonal-rejection-criteria — one more than byteArray's three because §a-copyArray-has-internal-structure-(indices)-that-byteArray-does-not.

§First-explicit-observation in library: **§the-validity-check-arity-correlates-with-the-internal-structure-of-the-pass-style** — §byteArray-has-no-internal-structure-only-three-lines + §copyArray-has-indices-so-four-lines + §the-checks-arise-from-the-shape-of-the-thing-being-validated.

## §The index-property-count check — single line rejects two attack classes

Line 35-36:
```js
ownKeys(candidate).length === len + 1 ||
  assert.fail(X`Arrays must not have non-indexes: ${candidate}`, TypeError);
```

§A-single-line-structural-completeness-check rejects:

- **§Sparse arrays** — if `len = 5` but the array has indices `[0, 1, 3, 4]` (skipping 2), `ownKeys` would be `['0', '1', '3', '4', 'length']` = 5, but `len + 1 = 6`; the equality fails. §sparse-array-rejection-at-marshal-boundary; §when-a-passable-array-has-a-missing-index-the-receiver-cannot-tell-what-was-there-from-just-the-encoding; §strict-density-is-a-protocol-invariant.
- **§Arrays-with-extra-own-properties** — if someone attached `arr.secret = 'leaked'`, `ownKeys` would include `'secret'`; the equality fails. §side-channel-strip — §an-attacker-could-attach-a-hidden-credential-as-a-non-index-own-property-and-have-it-flow-through-marshal-as-a-side-channel; §sibling-pattern to byteArray's `ownKeys(candidate).length === 0` defense; §the-discipline-IS-the-same-across-both-helpers-but-with-different-arithmetic-because-the-structures-differ.

§Two-cycles-with-ownKeys-length-check-as-side-channel-strip (260 byteArray-no-own-keys + 262 copyArray-exactly-len+1-own-keys); §the-discipline-IS-canonical-for-passable-leaf-validation; §first-explicit-observation in library.

§the-`len + 1`-arithmetic — §the-`+1`-IS-the-length-property; §the-arithmetic-IS-the-invariant; §named-arithmetic-in-the-comment-as-self-documentation (*"Expect one key per index plus one for 'length'"*).

## §passStyleOfRecur — the helper's interaction with the marshal core

Line 30-32:
```js
for (let i = 0; i < len; i += 1) {
  passStyleOfRecur(
    confirmOwnDataDescriptor(candidate, i, true, Fail).value,
  );
}
```

§The-`passStyleOfRecur`-callback is the helper's hook back into the marshal core's recursion. §The-helper-validates-this-level + §the-core-handles-the-recursion-by-asking-the-right-helper-for-each-child. §inversion-of-control between helper and core; §the-helper-doesn't-know-which-helper-validates-its-children + §it-delegates-via-the-callback.

§First-explicit-observation in library: **§passStyleOfRecur-as-named-callback-for-helper-to-core-recursion-on-each-child-value** — §the-helpers-cluster's-protocol-for-recursive-validation; §the-callback-name-`Recur`-suffix-IS-the-canonical-naming-for-helper-to-core-callbacks; §sibling-pattern to byteArray's `_passStyleOfRecur` ignored parameter (byteArray has no children to walk; copyArray does).

§The-byteArray-helper-takes-the-callback-but-doesn't-use-it (`_passStyleOfRecur` with leading underscore-via-ESLint-disable). §The-copyArray-helper-takes-the-callback-and-uses-it-per-index. §the-API-IS-symmetric-because-the-marshal-core-treats-all-helpers-uniformly; §helpers-that-don't-need-recursion-receive-the-callback-anyway. §uniform-helper-interface-even-when-some-helpers-don't-need-all-arguments; §first-explicit-observation in library.

## §confirmOwnDataDescriptor — the shared validation helper

The helper is imported from `./passStyle-helpers.js` (the cluster's shared utilities — documented at the [helpers-cluster sibling](endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named.md) page). Its job: validate that a property is `{ value, writable: any, enumerable: <param>, configurable: any }`-shaped (not an accessor).

§Four-argument signature visible in the call sites: `confirmOwnDataDescriptor(candidate, key, enumerableRequired, rejecter)`:

- `candidate` — the object whose property is being validated.
- `key` — the property name (`'length'` or numeric index).
- `enumerableRequired` — boolean; `false` for `length` (which is canonically non-enumerable on arrays), `true` for indices (which must be enumerable to be visible to iteration).
- `rejecter` — `Fail` template-tag callback; thrown if validation fails.

§Three-named-arguments-of-the-shared-helper-each-encode-a-discipline:
- §the-property-must-be-own (no inheritance).
- §the-property-must-be-a-data-descriptor (no accessor side-effects).
- §the-property-enumerability-MAY-be-controlled-per-call (because indices and length differ).

§First-explicit-observation in library: **§confirmOwnDataDescriptor-as-named-cluster-helper-for-property-shape-validation-with-enumerability-as-a-per-call-parameter**.

## §The "ensured" comment as named invariant

Lines 22-23 (the canonical doc-comment-IS-the-contract sibling):
```
// Since we're already ensured candidate is an array, it should not be
// possible for the following get to fail.
```

§The-comment-IS-the-evidence-of-the-load-bearing-invariant:

- §the-confirmCanBeValid-step-has-already-confirmed-candidate-is-an-array.
- §therefore-the-`length`-property-MUST-exist-and-be-an-own-data-descriptor.
- §but-the-helper-validates-it-anyway-because-defense-in-depth + §the-comment-documents-the-redundancy.

§First-explicit-observation in library: **§the-comment-documents-the-redundancy-of-a-defense-in-depth-check** — §the-helper-could-skip-the-`length`-validation-after-confirmCanBeValid + §but-defense-in-depth-requires-validating-the-thing-the-helper-doesn't-trust-came-through-its-own-confirmCanBeValid.

§Four-cycles-with-doc-comment-IS-the-contract (253 + 257 + 260 + 262); §discipline-now-reified-at-four-cycles.

## §Two error-API styles maintained — cycle-260 pattern continues

Lines 21, 25, 31, 36:
- `assert.fail(X\`...\`, TypeError)` — structural rejections (prototype mismatch, count mismatch).
- `Fail` — passed *into* `confirmOwnDataDescriptor` as the rejecter for descriptor validation (semantic delegation).

§The-two-error-API-styles in copyArray match the byteArray pattern; §two-cycles-with-two-error-API-styles-encoding-distinction-between-structural-and-semantic-rejection (260 + 262); §discipline-now-emergent-pattern.

§The-Fail-callback-passed-INTO-the-shared-helper is a new variation — §the-rejecter-is-an-argument-to-the-shared-helper rather than thrown directly; §the-shared-helper-decides-when-to-call-it; §callback-based-rejection-API; §first-explicit-observation in library of §callback-based-rejection-API-where-the-rejecter-is-passed-into-a-shared-validation-helper.

## §No side-channel-strip arithmetic difference is itself the signal

Cycle 260 byteArray: `ownKeys(candidate).length === 0` — no own keys allowed.
Cycle 262 copyArray: `ownKeys(candidate).length === len + 1` — exactly `len + 1` own keys allowed.

§The-`= 0`-vs-`= len + 1`-arithmetic-difference encodes §the-structural-difference-between-the-two-pass-styles:

- §byteArray-is-a-canonical-bag-of-bytes-with-no-attached-metadata; §any-own-key-IS-a-side-channel.
- §copyArray-is-an-ordered-sequence-of-passable-values-with-a-`length`-property; §`length`-IS-the-required-metadata + §index-keys-ARE-the-required-payload-keys + §any-other-key-IS-a-side-channel.

§Two-cycles-with-ownKeys-length-check-with-pass-style-specific-arithmetic (260 zero + 262 len+1); §the-arithmetic-IS-the-pass-style's-shape-signature; §first-explicit-observation in library.

## §Cycle 262 first-explicit-observations roundup

1. **§the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic**.
2. **§the-validity-check-arity-correlates-with-the-internal-structure-of-the-pass-style** (byteArray 3 lines; copyArray 4 lines).
3. **§ownKeys-length-check-with-pass-style-specific-arithmetic** (`= 0` for byteArray; `= len + 1` for copyArray).
4. **§passStyleOfRecur-as-named-callback-for-helper-to-core-recursion-on-each-child-value**.
5. **§uniform-helper-interface-even-when-some-helpers-don't-need-all-arguments** (byteArray ignores the recur callback; copyArray uses it).
6. **§shared-validation-helper-imported-by-name-into-each-PassStyleHelper** (`confirmOwnDataDescriptor` from passStyle-helpers.js).
7. **§confirmOwnDataDescriptor-as-named-cluster-helper-for-property-shape-validation-with-enumerability-as-a-per-call-parameter**.
8. **§the-comment-documents-the-redundancy-of-a-defense-in-depth-check** (the *ensured* comment).
9. **§callback-based-rejection-API-where-the-rejecter-is-passed-into-a-shared-validation-helper** (`Fail` passed as 4th argument).
10. **§destructuring-with-rename-when-source-name-is-too-generic** (`prototype: arrayPrototype`).

## §Recurring meta-pattern counters bumped at cycle 262

- §**five-cycles-with-named-import-isolation-via-destructuring** (242 + 254 + 258 + 260 + 262).
- §**four-cycles-with-doc-comment-IS-the-contract** (253 + 257 + 260 + 262).
- §**two-cycles-with-PassStyleHelper-concrete-instance** (260 + 262).
- §**two-cycles-with-the-binding-name-convention** (260 ByteArrayHelper + 262 CopyArrayHelper).
- §**two-cycles-with-phase-1-uses-realm-aware-platform-test** (260 + 262).
- §**two-cycles-with-two-error-API-styles-encoding-distinction-between-structural-and-semantic-rejection** (260 + 262).
- §**two-cycles-with-ownKeys-length-check-as-side-channel-strip-with-pass-style-specific-arithmetic** (260 + 262).
- §**ninety-fifth consecutive designs-chat alternation cycles 166-250 + 252-262 (251 was out-of-band)**.

## §Synthesis target — slot machine library

§Two-PassStyleHelper-pairs-as-pedagogy — for the slot machine library §game-engine-protocol-helpers-cluster, instantiate a sibling-pair-pedagogy:

- §**§GameTokenHelper** (cycle 260 sibling) — single-byte game token, no internal structure, no own keys allowed, requires feature-detection-at-load if depending on a stage-3 game-feature.
- §**§GameRollHelper** (cycle 262 sibling) — ordered sequence of dice rolls, has `length` + index keys, validates each roll recursively via `passStyleOfRecur`, requires exactly `len + 1` own keys.

§The-pair-IS-the-pedagogy — §the-implementer-can-read-the-two-helpers-side-by-side-and-see-the-cluster-pattern's-points-of-variation; §sibling-pair-as-cluster-template; §each-pair-illustrates-which-discipline-applies-when.

§Tier-1 borrowing: §the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic + §the-validity-check-arity-correlates-with-the-internal-structure + §ownKeys-length-check-with-pass-style-specific-arithmetic + §passStyleOfRecur-as-named-callback + §uniform-helper-interface + §shared-validation-helper-imported-by-name + §confirmOwnDataDescriptor-as-named-cluster-helper + §the-comment-documents-the-redundancy-of-a-defense-in-depth-check.

§Tier-2 borrowing: §callback-based-rejection-API + §destructuring-with-rename-when-source-name-is-too-generic + §three-named-import-styles-in-seven-lines.

§Tier-3 borrowing: §five-cycles-with-named-import-isolation-via-destructuring + §four-cycles-with-doc-comment-IS-the-contract + §two-cycles-with-PassStyleHelper-concrete-instance (now-an-emergent-paired-pattern) + §two-cycles-with-the-binding-name-convention + §two-cycles-with-phase-1-uses-realm-aware-platform-test + §two-cycles-with-two-error-API-styles + §two-cycles-with-ownKeys-length-check-as-side-channel-strip-with-pass-style-specific-arithmetic + §library-reaches-768-sections at cycle 262 (chat-lane copyArray.js) + §ninety-fifth consecutive designs-chat alternation cycles 166-250 + 252-262.

## Pattern summary (tag-prefixed)

§CopyArrayHelper-as-PassStyleHelper-second-concrete-instance + §the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic + §the-validity-check-arity-correlates-with-the-internal-structure-of-the-pass-style + §four-line-validity-check-with-four-orthogonal-rejection-criteria + §index-property-count-check-rejects-sparse-arrays-and-extra-own-properties + §ownKeys-length-check-with-pass-style-specific-arithmetic + §passStyleOfRecur-as-named-callback-for-helper-to-core-recursion + §uniform-helper-interface-even-when-some-helpers-don't-need-all-arguments + §shared-validation-helper-imported-by-name + §confirmOwnDataDescriptor-as-named-cluster-helper + §the-comment-documents-the-redundancy-of-a-defense-in-depth-check + §callback-based-rejection-API-where-the-rejecter-is-passed-into-a-shared-validation-helper + §destructuring-with-rename-when-source-name-is-too-generic + §three-named-import-styles + §Array.isArray-IS-the-canonical-realm-aware-array-test + §five-cycles-with-named-import-isolation-via-destructuring + §four-cycles-with-doc-comment-IS-the-contract + §two-cycles-with-PassStyleHelper-concrete-instance.
