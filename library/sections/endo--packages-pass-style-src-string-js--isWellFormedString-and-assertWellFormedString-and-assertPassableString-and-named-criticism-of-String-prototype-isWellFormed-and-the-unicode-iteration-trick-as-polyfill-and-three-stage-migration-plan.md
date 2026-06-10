---
title: "@endo/pass-style/src/string.js — isWellFormedString + assertWellFormedString + assertPassableString + named criticism of String.prototype.isWellFormed + the unicode-iteration-trick as polyfill + three-stage migration plan named explicitly"
source-slug: endo--packages-pass-style-src-string-js
section-slug: isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
source-repo: endojs/endo
source-path: packages/pass-style/src/string.js
source-author: Endo project (collective)
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/string.js` — the passable-string utility module

An 83-line file that is **not** a PassStyleHelper concrete instance but a utility module that exports **three named primitives** (`isWellFormedString` + `assertWellFormedString` + `assertPassableString`). Carries dense Unicode knowledge, feature-detection-at-module-load, named criticism of a standard API, and an explicit three-stage migration plan.

§First-explicit-observation in library: **§a-cluster-utility-module-that-IS-not-a-PassStyleHelper-but-carries-three-named-predicates-and-asserters — §the-pass-style-cluster-has-helper-files-(cycles 260 + 262 + 264 + 268)-and-utility-files-(cycle 272-string-js); §the-cluster-has-two-named-file-shapes-not-one**.

## §The named criticism of `String.prototype.isWellFormed`

Lines 10-19:
> *Unfortunately, the [standard built-in `String.prototype.isWellFormed`](https://github.com/tc39/proposal-is-usv-string) does a ToString on its input, causing it to judge non-strings to be well-formed strings if they coerce to a well-formed strings. This recapitulates the mistake in having the global `isNaN` coerce its inputs, causing it to judge non-string to be NaN if they coerce to NaN.*
>
> *This `isWellFormedString` function only judges well-formed strings to be well-formed strings. For all non-strings it returns false.*

§First-explicit-observation in library: **§named-criticism-of-a-standard-method-as-design-justification — §the-design-explicitly-criticizes-the-standard-built-in-API-by-name + §names-a-named-sibling-mistake (the global `isNaN` coercing its inputs) + §the-criticism-IS-the-design-justification**.

§Two-named-sibling-mistakes-in-the-criticism:
1. **`String.prototype.isWellFormed`** — does ToString; judges non-strings as well-formed.
2. **Global `isNaN`** — judges non-strings as NaN if they coerce to NaN.

§First-explicit-observation in library: **§two-named-existing-API-mistakes-as-paired-design-justification — §the-design-doesn't-just-criticize-the-current-API + §it-names-a-second-API-that-makes-the-same-class-of-mistake + §the-pair-IS-the-rhetorical-force-of-the-criticism**.

§"Unfortunately, the standard built-in..." — §named-pejorative-as-design-tone; §the-author-acknowledges-the-API-IS-standard-AND-the-author-IS-unhappy-with-the-design; §sibling-pattern to many `@endo/*` files that criticize standard APIs (e.g., cycle 245's panic-cluster on `eval` shadowing).

§the-fix-IS-trivial-AND-rhetorically-amplified — `typeof str === 'string' && str.isWellFormed()` adds one type-check before the method call, but the design takes ten lines of prose to explain why this matters.

## §The feature-detection-at-module-load with conditional binding

Lines 5 and 23-42 carry the §feature-detection pattern:

```js
const hasWellFormedStringMethod = !!String.prototype.isWellFormed;

export const isWellFormedString = hasWellFormedStringMethod
  ? str => typeof str === 'string' && str.isWellFormed()
  : str => {
      if (typeof str !== 'string') {
        return false;
      }
      for (const ch of str) {
        const cp = /** @type {number} */ (ch.codePointAt(0));
        if (cp >= 0xd800 && cp <= 0xdfff) {
          return false;
        }
      }
      return true;
    };
```

§The-conditional-binding (ternary on the feature-detection bool) yields two different implementations of `isWellFormedString` at module load. §sibling-pattern to cycle 260's `adaptImmutableArrayBuffer`-factory but instantiated as a ternary rather than a factory function.

§Two-cycles-with-feature-detection-at-module-load (260 byteArray's adapter-factory + 272 string's conditional-binding); §the-pattern-IS-the-same-discipline-with-two-different-implementations.

§First-explicit-observation in library: **§the-conditional-binding-via-ternary-on-feature-detection-bool-as-alternative-to-the-adapter-factory-pattern — §when-the-feature-detection-yields-a-binary-choice, §a-ternary-IS-sufficient + §when-it-yields-multiple-values-an-adapter-factory-IS-needed; §two-named-shapes-of-feature-detection-at-module-load**.

## §The unicode-iteration-trick as polyfill strategy

Lines 29-39 (the polyfill body):

```js
for (const ch of str) {
  // The string iterator iterates by Unicode code point, not
  // UTF16 code unit. But if it encounters an unpaired surrogate,
  // it will produce it.
  const cp = /** @type {number} */ (ch.codePointAt(0));
  if (cp >= 0xd800 && cp <= 0xdfff) {
    // All surrogates are in this range. The string iterator only
    // produces a character in this range for unpaired surrogates,
    // which only happens if the string is not well-formed.
    return false;
  }
}
```

§The-trick:
1. JS's string iterator (`for (const ch of str)`) iterates **by Unicode code point, not UTF-16 code unit**.
2. **BUT** it produces a single character in the surrogate range `0xd800-0xdfff` ONLY when it encounters an **unpaired surrogate**.
3. Therefore: if any iterated character has a code point in the surrogate range, the string IS not well-formed.

§First-explicit-observation in library: **§the-unicode-iteration-trick-as-named-polyfill-strategy — §JS's-string-iterator-produces-single-surrogate-characters-ONLY-for-unpaired-surrogates + §iterating-and-checking-the-code-point-range-against-surrogates-IS-the-well-formed-check**.

§The-polyfill-IS-trickier-than-the-naive-implementation — §the-naive-implementation-would-iterate-by-UTF-16-code-unit-and-track-pairs; §the-trick-leverages-the-iterator's-built-in-pair-resolution + §catches-only-unpaired-residue.

§Named-Unicode-knowledge-encoded-in-the-comment — §two-paragraphs-of-Unicode-explanation; §the-author-named-the-key-property + §the-property-IS-load-bearing + §without-it-the-polyfill-is-obscure; §first-explicit-observation in library of §named-Unicode-iteration-property-as-load-bearing-polyfill-discipline.

§Surrogate-range-0xd800-0xdfff-named-explicitly — §the-magic-numbers-aren't-named-with-a-constant + §the-comment-names-them-instead; §the-discipline-IS-comment-IS-the-constant; §sibling-pattern to cycle 260's named-constant-with-comment-as-the-vocabulary-source.

## §Three named exports — predicate + asserter + extended-asserter

Lines 23, 52, 79 carry three exports:

1. **`isWellFormedString(str): str is string`** — the predicate (returns boolean; narrows type).
2. **`assertWellFormedString(str): asserts str is string`** — the asserter (throws if not).
3. **`assertPassableString(str): asserts str is string`** — the extended asserter (uses env-option to decide whether to check well-formed).

§First-explicit-observation in library: **§three-named-exports-as-predicate-asserter-extended-asserter — §the-cluster's-canonical-discipline-from-cycle-150's-typeGuards.js's-predicate-assertion-pairs (predicate + asserter); §here-extended-with-an-extended-asserter-that-uses-a-runtime-flag**.

§Sibling-pattern to cycle 150's typeGuards.js four-predicate-assertion-pairs; §the-cluster's-canonical-shape (predicate + asserter) extended here with §a-third-asserter-with-runtime-toggle.

§`asserts str is string` — TypeScript narrowing predicate via JSDoc. §sibling-pattern to many @endo/* asserters.

§All-three-exports-IS-`hideAndHardenFunction`-wrapped (lines 43, 55, 83) — §the-cluster's-canonical-wrap-discipline; §three-times-in-83-lines.

## §The ONLY_WELL_FORMED_STRINGS_PASSABLE environment option

Lines 57-60:
```js
const ONLY_WELL_FORMED_STRINGS_PASSABLE =
  getEnvironmentOption('ONLY_WELL_FORMED_STRINGS_PASSABLE', 'disabled', [
    'enabled',
  ]) === 'enabled';
```

§The-runtime-toggle-pattern — §a-named-environment-option + §a-default-value + §a-named-set-of-allowed-non-default-values; §sibling-pattern to cycle 130's `@endo/env-options` from `ENDO_SEND_BREAKPOINTS` and related options.

§`getEnvironmentOption`-third-argument-IS-the-allowed-non-default-values-list — §the-function-IS-strict-about-recognized-values + §typos-are-rejected-at-load-time; §sibling-pattern to enum-like type narrowing at runtime.

§First-explicit-observation in library: **§the-runtime-toggle-pattern-with-named-environment-option-and-allowed-non-default-values-list — §sibling-pattern to cycle 130's message-breakpoints env-option discipline**.

## §The three-stage migration plan named explicitly

Lines 62-74:
> *Currently, `ONLY_WELL_FORMED_STRINGS_PASSABLE` defaults to `'disabled'` because we do not yet know the performance impact. Later, if we decide we can afford it, we'll **first** change the default to `'enabled'` and **ultimately** remove the switch altogether. Be prepared for these changes.*
>
> *TODO once the switch is removed, simplify `assertPassableString` to simply be `assertWellFormedString`.*

§Three-stage-migration-plan:
1. **Stage 1 (current)** — default `disabled`; performance impact unknown; users can opt in.
2. **Stage 2 (future)** — default `enabled`; the switch still exists but is rarely changed.
3. **Stage 3 (eventual)** — switch removed; `assertPassableString` simplifies to `assertWellFormedString`.

§First-explicit-observation in library: **§the-three-stage-migration-plan-named-explicitly-in-prose-doc-comment — §the-author-names-the-three-stages-of-an-API-evolution-in-the-source-code + §the-stages-IS-temporal-not-spatial + §the-TODO-IS-anchored-to-the-final-stage**.

§"Be prepared for these changes" — §named-future-change-warning-in-prose-doc-comment; §the-warning-IS-explicit-not-implicit; §first-explicit-observation in library of §named-future-change-warning-as-design-tone.

§The-author-uses-"first... ultimately"-as-the-temporal-sequencing — §two-named-temporal-markers + §the-prose-encodes-the-migration-graph; §sibling-pattern to roadmap-as-prose conventions.

## §The performance-uncertainty acknowledgment

Line 65: *"we do not yet know the performance impact"*.

§First-explicit-observation in library: **§the-performance-uncertainty-acknowledgment-as-named-default-rationale — §the-conservative-default-IS-justified-by-named-unknown-cost + §the-design-doesn't-pretend-to-know-what-it-doesn't-know**.

§Sibling-pattern to many honest-uncertainty admissions in design docs; §the-honest-uncertainty-IS-the-source-of-the-conservative-default + §when-the-cost-IS-known, §the-default-can-change.

§The-empirical-velocity-discipline-applied-to-feature-defaults — §sibling-pattern to cycle 267's README empirical-velocity calibration but applied at the per-feature-default level rather than at the per-design-size level; §two-cycles-with-empirical-uncertainty-as-named-discipline (267 velocity-recalibration + 272 feature-default-performance).

## §Cycle 272 first-explicit-observations roundup (eleven)

1. §a-cluster-utility-module-that-IS-not-a-PassStyleHelper-but-carries-three-named-predicates-and-asserters.
2. §named-criticism-of-a-standard-method-as-design-justification.
3. §two-named-existing-API-mistakes-as-paired-design-justification (String.prototype.isWellFormed + global isNaN).
4. §the-conditional-binding-via-ternary-on-feature-detection-bool-as-alternative-to-the-adapter-factory-pattern.
5. §two-named-shapes-of-feature-detection-at-module-load (adapter-factory + conditional-binding).
6. §the-unicode-iteration-trick-as-named-polyfill-strategy.
7. §named-Unicode-iteration-property-as-load-bearing-polyfill-discipline.
8. §three-named-exports-as-predicate-asserter-extended-asserter.
9. §the-runtime-toggle-pattern-with-named-environment-option-and-allowed-non-default-values-list.
10. §the-three-stage-migration-plan-named-explicitly-in-prose-doc-comment.
11. §named-future-change-warning-in-prose-doc-comment.

Plus: §the-performance-uncertainty-acknowledgment-as-named-default-rationale + §two-cycles-with-empirical-uncertainty-as-named-discipline (267 + 272).

## §Recurring meta-pattern counters bumped at cycle 272

- §**two-cycles-with-feature-detection-at-module-load** (260 byteArray's adapter-factory + 272 string's conditional-binding) — §upgraded-to-two with explicit observation of the shape variation.
- §**two-cycles-with-empirical-uncertainty-as-named-discipline** (267 velocity-recalibration + 272 feature-default-performance).
- §**one-hundred-and-fifth consecutive designs-chat alternation cycles 166-250 + 252-272** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-passable-string-utility-pattern applies to the §game-engine-cluster:

- §**`isWellFormedGameValue` + `assertWellFormedGameValue` + `assertPassableGameValue`** — three named exports as predicate + asserter + extended-asserter.
- §**§named-criticism-of-a-standard-game-API-as-design-justification** when an existing standard does the wrong thing for the protocol.
- §**§feature-detection-at-module-load** for stage-3 game-platform features.
- §**§the-runtime-toggle-pattern** with `getGameOption(name, default, allowed-list)`.
- §**§the-three-stage-migration-plan-named-explicitly** for switching defaults: (1) disabled-by-default + (2) change-default-to-enabled + (3) remove-switch-and-simplify.
- §**§the-performance-uncertainty-acknowledgment** as the conservative-default's rationale.

## §Tier-1 borrowing

§a-cluster-utility-module-that-IS-not-a-helper-but-carries-three-named-predicates-and-asserters + §named-criticism-of-a-standard-method-as-design-justification + §two-named-existing-API-mistakes-as-paired-design-justification + §the-conditional-binding-via-ternary-on-feature-detection-bool + §two-named-shapes-of-feature-detection-at-module-load + §the-unicode-iteration-trick-as-named-polyfill-strategy + §three-named-exports-as-predicate-asserter-extended-asserter + §the-runtime-toggle-pattern-with-named-environment-option-and-allowed-non-default-values-list + §the-three-stage-migration-plan-named-explicitly-in-prose-doc-comment + §named-future-change-warning-in-prose-doc-comment + §the-performance-uncertainty-acknowledgment-as-named-default-rationale.

## §Tier-2 borrowing

§named-Unicode-iteration-property-as-load-bearing-polyfill-discipline + §the-cluster-has-two-named-file-shapes-not-one (helper-files + utility-files) + §"first...ultimately"-as-named-temporal-sequencing-in-prose.

## §Tier-3 borrowing

§two-cycles-with-feature-detection-at-module-load (260 + 272) + §two-cycles-with-empirical-uncertainty-as-named-discipline (267 + 272) + §library-reaches-778-sections at cycle 272 + §one-hundred-and-fifth consecutive designs-chat alternation cycles 166-250 + 252-272.

## Pattern summary (tag-prefixed)

§the-passable-string-utility-module + §a-cluster-utility-module-that-IS-not-a-PassStyleHelper + §three-named-exports-as-predicate-asserter-extended-asserter (isWellFormedString + assertWellFormedString + assertPassableString) + §named-criticism-of-a-standard-method-as-design-justification + §two-named-existing-API-mistakes-as-paired-design-justification (String.prototype.isWellFormed + global isNaN) + §the-conditional-binding-via-ternary-on-feature-detection-bool + §two-named-shapes-of-feature-detection-at-module-load (adapter-factory + conditional-binding) + §the-unicode-iteration-trick-as-named-polyfill-strategy + §named-Unicode-iteration-property-as-load-bearing-polyfill-discipline + §surrogate-range-0xd800-0xdfff-named-via-comment-as-the-vocabulary-source + §the-runtime-toggle-pattern-with-named-environment-option-and-allowed-non-default-values-list + §the-three-stage-migration-plan-named-explicitly-in-prose-doc-comment + §named-future-change-warning-in-prose-doc-comment + §the-performance-uncertainty-acknowledgment-as-named-default-rationale + §"first...ultimately"-as-named-temporal-sequencing-in-prose + §two-cycles-with-feature-detection-at-module-load + §two-cycles-with-empirical-uncertainty-as-named-discipline + §the-cluster-has-two-named-file-shapes-not-one.
