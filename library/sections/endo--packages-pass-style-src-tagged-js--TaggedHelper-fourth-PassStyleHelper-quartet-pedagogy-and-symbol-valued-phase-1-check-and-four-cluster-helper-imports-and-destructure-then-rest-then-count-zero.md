---
title: "@endo/pass-style/src/tagged.js — TaggedHelper fourth PassStyleHelper, quartet pedagogy + symbol-valued phase-1 check + four cluster-helper imports + destructure-then-rest-then-count-zero"
source-slug: endo--packages-pass-style-src-tagged-js
section-slug: TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/tagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/tagged.js
source-author: Endo project (collective)
total-lines: 49
ingest-cycle: 268
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/tagged.js` — fourth PassStyleHelper concrete instance, extending the triplet to a quartet

A 49-line file that exports `TaggedHelper` for the `'tagged'` pass-style. **Fourth concrete instance** of the `PassStyleHelper` shape — the cluster pedagogy now extends from the triplet (cycle 264's named pattern) to a **quartet**: cycle 260 byteArray + cycle 262 copyArray + cycle 264 copyRecord + cycle 268 tagged.

§Four-cycles-with-PassStyleHelper-concrete-instance (260 + 262 + 264 + 268) — §upgraded from cycle 264's §three-cycles-with-PassStyleHelper-concrete-instance.

§First-explicit-observation in library: **§the-quartet-extends-the-triplet-pedagogy-by-introducing-a-substrate-shape-that-uses-a-symbol-marker-not-a-platform-intrinsic-test — §byteArray (instanceof ArrayBuffer) + §copyArray (Array.isArray) + §copyRecord (getPrototypeOf === Object.prototype) + §tagged (the candidate's PASS_STYLE symbol value equals 'tagged')**.

## §The quartet — four different phase-1 tactics across four substrate shapes

| Cycle | Helper           | Substrate                          | Phase-1 tactic                                              | Notable structural move                       |
|-------|------------------|------------------------------------|-------------------------------------------------------------|-----------------------------------------------|
| 260   | ByteArrayHelper  | Immutable ArrayBuffer (stage-3)    | `instanceof ArrayBuffer && candidate.immutable`             | Adapter-factory for stage-3 detection         |
| 262   | CopyArrayHelper  | `Array` (universal)                | `Array.isArray(candidate)`                                  | Realm-aware intrinsic test                    |
| 264   | CopyRecordHelper | `Object` with `Object.prototype`   | Prototype + each-key-string + each-value-not-method         | Named local helpers extracted                  |
| 268   | TaggedHelper     | Tagged record (Tag-Record + payload)| `candidate[PASS_STYLE] === 'tagged'` via `confirmPassStyle` | **Symbol-marker phase-1**; four cluster imports|

§First-explicit-observation in library: **§four-different-phase-1-tactics-across-the-quartet — §each-helper's-phase-1-tactic-reflects-its-substrate's-discriminator + §the-tagged-helper-introduces-symbol-marker-discrimination-because-tagged-records-carry-an-explicit-PASS_STYLE-marker**.

## §Four imports from `./passStyle-helpers.js` — the most cluster-integrated helper

Lines 3-8:
```js
import {
  confirmTagRecord,
  PASS_STYLE,
  confirmOwnDataDescriptor,
  confirmPassStyle,
} from './passStyle-helpers.js';
```

§Four-named-imports-from-the-sibling-helpers-cluster — the most of any PassStyleHelper:

- **byteArray** imported nothing from `./passStyle-helpers.js`.
- **copyArray** imported `confirmOwnDataDescriptor` (one helper).
- **copyRecord** imported `confirmOwnDataDescriptor` (one helper).
- **tagged** imports `confirmTagRecord` + `PASS_STYLE` + `confirmOwnDataDescriptor` + `confirmPassStyle` (**four** items).

§First-explicit-observation in library: **§the-fourth-helper-imports-four-cluster-helpers-the-most-of-any-PassStyleHelper-because-tagged-records-require-the-most-cluster-aware-validation — §the-cluster-helper-import-count-correlates-with-the-helper's-cluster-integration**.

§Each-import-encodes-a-named-discipline:
- **`confirmTagRecord`** — checks PASS_STYLE + Symbol.toStringTag own data properties.
- **`PASS_STYLE`** — the symbol constant that marks tagged records.
- **`confirmOwnDataDescriptor`** — shared property-shape validator (cycle 262 sibling).
- **`confirmPassStyle`** — checks that `candidate[PASS_STYLE]` equals an expected style name.

§First-explicit-observation in library: **§confirmPassStyle-as-named-cluster-helper-for-symbol-marker-validation — §when-a-helper-must-discriminate-by-symbol-marker, §the-cluster-provides-a-shared-helper-that-takes-the-expected-style-name-as-an-argument**.

§The `PASS_STYLE` symbol IS the cluster's discriminator for any-pass-style that carries an explicit marker. §sibling-pattern to cycle 142's pass-style helpers cluster.

## §The phase-1 check uses confirmPassStyle — a symbol-marker check

Line 24-25:
```js
confirmCanBeValid: (candidate, reject) =>
  confirmPassStyle(candidate, candidate[PASS_STYLE], 'tagged', reject),
```

§The-phase-1-tactic is §pass-the-candidate's-own-PASS_STYLE-value-and-the-expected-style-name. Three operands of `confirmPassStyle`:
1. **The candidate** — the value being validated.
2. **`candidate[PASS_STYLE]`** — what the candidate claims it is.
3. **`'tagged'`** — what we want it to be.

§The-symbol-marker-check is §the-helper-asks-"do-you-claim-to-be-tagged?" — §if-the-candidate-says-yes-AND-the-claim-is-honestly-`tagged`-not-some-other-style, §the-phase-1-passes; §otherwise-the-phase-1-fails-and-reject-fires.

§The-symbol-IS-the-marker — §sibling-pattern to JS's Symbol.toStringTag conventions; §the-PASS_STYLE-symbol-IS-not-the-same-symbol-as-Symbol.toStringTag-but-they-coexist-on-tagged-records.

## §The destructure-then-rest-then-count-zero pattern — first cycle in library

Lines 27-41 carry a structurally novel side-channel-strip pattern:

```js
assertRestValid: (candidate, passStyleOfRecur) => {
  confirmTagRecord(candidate, 'tagged', Fail);

  // Typecasts needed due to https://github.com/microsoft/TypeScript/issues/1863
  const passStyleKey = /** @type {unknown} */ (PASS_STYLE);
  const tagKey = /** @type {unknown} */ (Symbol.toStringTag);
  const {
    // confirmTagRecord already verified PASS_STYLE and Symbol.toStringTag own data properties.
    [/** @type {string} */ (passStyleKey)]: _passStyleDesc,
    [/** @type {string} */ (tagKey)]: _labelDesc,
    payload: _payloadDesc, // value checked by recursive walk at the end
    ...restDescs
  } = getOwnPropertyDescriptors(candidate);
  ownKeys(restDescs).length === 0 ||
    Fail`Unexpected properties on tagged record ${ownKeys(restDescs)}`;
  ...
};
```

§First-explicit-observation in library: **§the-destructure-then-rest-then-count-zero-pattern — §a-side-channel-strip-pattern-that-(1) enumerates-all-own-descriptors-at-once-via-`getOwnPropertyDescriptors` + (2) destructures-out-the-three-known-keys (PASS_STYLE + Symbol.toStringTag + payload) + (3) collects-everything-else-into-`...restDescs` + (4) asserts-`restDescs`-has-zero-keys**.

§The-pattern-IS-structurally-different-from-cycle-264's-`ownKeys(candidate).length === len + 1`-arithmetic — §here-the-arithmetic-IS-zero-but-the-zero-applies-to-`restDescs`-not-to-`ownKeys(candidate)`; §the-destructuring-discharges-the-three-known-keys + §the-zero-applies-to-the-leftover.

§Three-cycles-with-own-keys-side-channel-strip-with-pass-style-specific-arithmetic-or-shape:
- **byteArray** (cycle 260) — `ownKeys.length === 0` (no own keys at all).
- **copyArray** (cycle 262) — `ownKeys.length === len + 1` (length + indices).
- **copyRecord** (cycle 264) — no count check; per-key-and-per-value rules.
- **tagged** (cycle 268) — destructure-out-three-known-then-`restDescs.length === 0`.

§Four-cycles-with-pass-style-specific-side-channel-defense-takes-four-forms:
1. **count-zero** (byteArray).
2. **count-equal-to-len-plus-1** (copyArray).
3. **per-key-and-per-value-rules** (copyRecord).
4. **destructure-then-rest-then-count-zero** (tagged).

§First-explicit-observation in library: **§the-side-channel-defense-takes-four-forms-across-the-quartet — §the-cycle-264-pedagogy-extends-with-a-fourth-form: §destructure-then-rest-then-count-zero**.

## §Three known own properties of a tagged record

Lines 33-37 enumerate the three known properties:

1. **`PASS_STYLE` symbol** with value `'tagged'` — the cluster discriminator.
2. **`Symbol.toStringTag`** — the developer-visible string label (per JS conventions).
3. **`payload`** — the wrapped value (validated via `passStyleOfRecur` at line 45).

§First-explicit-observation in library: **§tagged-records-have-three-named-own-properties (PASS_STYLE + Symbol.toStringTag + payload) — §the-pattern-IS-canonical-for-extending-the-marshal-protocol-with-new-sub-styles**.

§Symbol.toStringTag IS the §developer-visible-string-label — §when-you-`console.log`-a-tagged-record, §its-Symbol.toStringTag-determines-the-prefix; §the-cluster-uses-this-for-runtime-debugging.

§The-`payload`-property-name-IS-canonical — §sibling-pattern to many wrapper-types in JS (e.g., `value`-properties on iterators); §the-tagged-helper-fixes-`payload`-as-the-wrapped-value-key.

## §The microsoft/TypeScript#1863 workaround citation

Line 30: `// Typecasts needed due to https://github.com/microsoft/TypeScript/issues/1863`

§First-explicit-observation in library: **§three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations**:
- **cycle 146** — `microsoft/TypeScript#50319` in E.js (the `@ts-expect-error` for computed-property-key naming).
- **cycle 264** — `microsoft/TypeScript#1863` referenced (need to cross-check; could be the same issue).
- **cycle 268** — `microsoft/TypeScript#1863` here (typecasts for symbol-keyed destructuring).

§the-named-issue-citation-IS-the-honest-workaround-acknowledgment — §when-the-type-system-can't-express-what-the-runtime-needs, §the-source-cites-the-TypeScript-issue-by-URL + §the-issue-becomes-a-named-witness-for-the-workaround.

§The-microsoft/TypeScript#1863 issue (per the URL pattern) — likely the issue about computed property keys with symbol literals not being recognized by destructuring.

## §The defense-in-depth comment continues the cycle 264 pattern

Line 34:
```js
// confirmTagRecord already verified PASS_STYLE and Symbol.toStringTag own data properties.
```

§Four-cycles-with-doc-comment-documenting-defense-in-depth-redundancy (260 + 262 + 264 + 268) — §the-discipline-now-reified-across-four-cycles.

§The-comment-IS-the-evidence — §the-`confirmTagRecord`-call-at-line-28-has-already-checked-PASS_STYLE-and-Symbol.toStringTag + §the-destructure-uses-them-defensively-rather-than-relying-on-the-confirmation.

## §The two-line `payload` recursion at the end

Lines 45-47:
```js
passStyleOfRecur(
  confirmOwnDataDescriptor(candidate, 'payload', true, Fail).value,
);
```

§The-payload-recursion-uses-the-same-shape-as-copyArray's-index-recursion (cycle 262) + copyRecord's per-property-recursion (cycle 264) — §`confirmOwnDataDescriptor(candidate, key, true, Fail).value` followed by `passStyleOfRecur(value)`; §the-shape-IS-now-canonical-across-three-cycles (262 + 264 + 268).

§First-explicit-observation in library: **§three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value (262 indices + 264 each-property + 268 payload)**.

## §Cycle 268 first-explicit-observations roundup (eight)

1. **§four-cycles-with-PassStyleHelper-concrete-instance** (260 + 262 + 264 + 268) — §upgraded from three-cycles to four-cycles.
2. **§the-quartet-extends-the-triplet-pedagogy-by-introducing-a-substrate-shape-that-uses-a-symbol-marker-not-a-platform-intrinsic-test**.
3. **§four-different-phase-1-tactics-across-the-quartet** — each helper's phase-1 tactic reflects its substrate's discriminator.
4. **§the-fourth-helper-imports-four-cluster-helpers-the-most-of-any-PassStyleHelper** — the cluster-helper-import-count correlates with the helper's cluster integration.
5. **§confirmPassStyle-as-named-cluster-helper-for-symbol-marker-validation**.
6. **§the-destructure-then-rest-then-count-zero-pattern** — a side-channel-strip pattern.
7. **§the-side-channel-defense-takes-four-forms-across-the-quartet** (count-zero + count-equal-to-len-plus-1 + per-key-and-per-value-rules + destructure-then-rest-then-count-zero).
8. **§tagged-records-have-three-named-own-properties** (PASS_STYLE + Symbol.toStringTag + payload).
9. **§three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations** (146 + 264 + 268).
10. **§three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value** (262 + 264 + 268).

## §Recurring meta-pattern counters bumped at cycle 268

- §**four-cycles-with-PassStyleHelper-concrete-instance** (260 + 262 + 264 + 268).
- §**four-cycles-with-the-binding-name-convention** (260 ByteArrayHelper + 262 CopyArrayHelper + 264 CopyRecordHelper + 268 TaggedHelper).
- §**four-cycles-with-named-import-of-sibling-module-cluster-helper** (260 — actually byteArray imported nothing from passStyle-helpers; let me recount: 262 + 264 + 268 import; so §three-cycles-with-named-import-of-sibling-module-cluster-helper stays at three — the cycle 268 import count is FOUR-named-imports-but-from-ONE-sibling-module).
- §**four-cycles-with-doc-comment-documenting-defense-in-depth-redundancy** (260 + 262 + 264 + 268).
- §**three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations** (146 + 264 + 268).
- §**three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value** (262 + 264 + 268).
- §**seven-cycles-with-doc-comment-IS-the-contract** (253 + 257 + 260 + 262 + 264 + 266 + 268).
- §**one-hundred-and-first consecutive designs-chat alternation cycles 166-250 + 252-268 (251 was out-of-band)**.

## §Synthesis target — slot machine library

§The-quartet-of-leaf-game-value-helpers extends cycle 264's triplet:

- §**GameTokenHelper** (cycle 260 sibling) — single-byte token, instanceof check.
- §**GameRollHelper** (cycle 262 sibling) — ordered sequence, isArray check.
- §**GameRecordHelper** (cycle 264 sibling) — open key-value, prototype check.
- §**GameTaggedHelper** (cycle 268 sibling) — extensible game-value-with-marker, symbol-marker check via `confirmGameStyle(candidate, candidate[GAME_STYLE], 'gameTagged', reject)`.

§The-quartet-IS-the-extended-pedagogy — §the-implementer-reads-all-four-side-by-side-and-sees-the-cluster-pattern's-four-different-discriminators; §four-points-define-the-pattern-with-the-discriminator-axis-now-visible.

§The-game-engine-cluster-imports-game-style-helpers-the-most-when-the-game-value-type-requires-the-most-cluster-aware-validation — §sibling-pattern to tagged.js's four-imports.

## §Tier-1 borrowing

§the-quartet-extends-the-triplet-pedagogy + §four-different-phase-1-tactics-across-the-quartet + §the-fourth-helper-imports-four-cluster-helpers-the-most-of-any-PassStyleHelper + §confirmPassStyle-as-named-cluster-helper-for-symbol-marker-validation + §the-destructure-then-rest-then-count-zero-pattern + §the-side-channel-defense-takes-four-forms-across-the-quartet + §tagged-records-have-three-named-own-properties + §three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations + §three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value.

## §Tier-2 borrowing

§four-cycles-with-PassStyleHelper-concrete-instance + §four-cycles-with-the-binding-name-convention + §four-cycles-with-doc-comment-documenting-defense-in-depth-redundancy + §the-cluster-helper-import-count-correlates-with-the-helper's-cluster-integration.

## §Tier-3 borrowing

§seven-cycles-with-doc-comment-IS-the-contract + §one-hundred-and-first-consecutive-designs-chat-alternation-cycles 166-250 + 252-268 + §library-reaches-774-sections at cycle 268.

## Pattern summary (tag-prefixed)

§TaggedHelper-fourth-PassStyleHelper-concrete-instance + §the-quartet-extends-the-triplet-pedagogy + §four-different-phase-1-tactics-across-the-quartet (instanceof + isArray + prototype-identity + symbol-marker) + §the-fourth-helper-imports-four-cluster-helpers-the-most-of-any-PassStyleHelper + §confirmPassStyle-as-named-cluster-helper-for-symbol-marker-validation + §the-symbol-marker-check (pass-the-candidate's-own-PASS_STYLE-value-and-the-expected-style-name) + §the-destructure-then-rest-then-count-zero-pattern + §the-side-channel-defense-takes-four-forms-across-the-quartet + §tagged-records-have-three-named-own-properties (PASS_STYLE + Symbol.toStringTag + payload) + §three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations (146 + 264 + 268) + §the-defense-in-depth-comment-continues-the-cycle-264-pattern + §three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value (262 + 264 + 268) + §four-cycles-with-PassStyleHelper-concrete-instance + §four-cycles-with-the-binding-name-convention + §four-cycles-with-doc-comment-documenting-defense-in-depth-redundancy + §seven-cycles-with-doc-comment-IS-the-contract.
