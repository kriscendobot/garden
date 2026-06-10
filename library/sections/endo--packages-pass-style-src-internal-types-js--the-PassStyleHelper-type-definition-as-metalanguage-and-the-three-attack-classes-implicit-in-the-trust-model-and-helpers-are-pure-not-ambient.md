---
title: "@endo/pass-style/src/internal-types.js — the PassStyleHelper type definition as metalanguage to the three concrete helpers + the three attack classes implicit in the trust model + helpers are pure not ambient + mutual-exclusivity property named in the type"
source-slug: endo--packages-pass-style-src-internal-types-js
section-slug: the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/internal-types.js
source-repo: endojs/endo
source-path: packages/pass-style/src/internal-types.js
source-author: Endo project (collective)
total-lines: 30
ingest-cycle: 266
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/internal-types.js` — the PassStyleHelper type definition as metalanguage

A 30-line `export {};` typedef-only file that defines the **`PassStyleHelper`** typedef — the **metalanguage** of the cluster's three concrete helpers (cycle 260 `ByteArrayHelper` + cycle 262 `CopyArrayHelper` + cycle 264 `CopyRecordHelper`). The relationship is parallel to cycle 265's observation about the `designs/CLAUDE.md` standing in metalanguage position to the design docs.

§First-explicit-observation in library: **§two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side — §cycle-265-CLAUDE.md-IS-metalanguage-to-design-docs + §cycle-266-internal-types.js-IS-metalanguage-to-PassStyleHelper-instances**; §the-metalanguage-pattern-now-recognized-at-two-different-scopes-in-the-same-week.

## §The `export {};` typedef-only file pattern recurs

Line 1: `export {};` — the pony-vs-shim sibling pattern from cycle 254's no-shim + cycle 256's promise-kit types + cycle 258's far exports + cycle 266's internal-types.

§Four-cycles-with-`export {};`-typedef-only-file-pattern (254 no-shim + 256 promise-kit types + 258 far exports + 266 internal-types) — §the-pattern-now-firmly-established-across-four-cycles; §the-file-has-no-runtime-content + §the-file-IS-the-typedef-protocol.

§First-explicit-observation in library: **§four-cycles-with-`export {};`-typedef-only-file-pattern — discipline reified across four cycles**.

## §Two-typedef-via-`@import` at the file head

Lines 3-6:
```js
/**
 * @import {Rejector} from '@endo/errors/rejector.js';
 * @import {PassStyle} from './types.js';
 */
```

§The-`@import`-block-IS-the-types-only-imports-list (cycle 264 sibling). §two-cross-module-typedef-references:
- §`Rejector` from `@endo/errors/rejector.js` — the rejecter-callback type (sibling to cycle 264's same import).
- §`PassStyle` from `./types.js` — the public `PassStyle` string-literal-union (sibling-module).

§The-internal-types.js-file-imports-the-public-types.js — §the-internal-types-DEPEND-on-the-public-types-not-the-other-way-around; §the-public-types-ARE-stable + §the-internal-types-evolve-faster; §sibling-pattern to many internal-types.h conventions in C/C++ projects.

§First-explicit-observation in library: **§the-internal-types-file-depends-on-the-public-types-not-the-other-way-around — §when-a-package-has-both-internal-and-public-type-files, §the-public-IS-stable-and-the-internal-evolves-faster**.

## §The module doc-comment names the architectural discipline

Lines 8-18 (the most structurally important block of the file):

> *The PassStyleHelper are only used to make a `passStyleOf` function. Thus, it should not depend on an ambient one. Rather, each helper should be pure, and get its `passStyleOf` or similar function from its caller.*
>
> *For those methods that have a last `passStyleOf` or `passStyleOfRecur`, they must defend against the other arguments being malicious, but may *assume* that `passStyleOfRecur` does what it is supposed to do. Each such method is not trying to defend itself against a malicious `passStyleOfRecur`, though it may defend against some accidents.*

§This-doc-comment-IS-the-named-architectural-discipline of the helpers cluster:

### §Discipline 1 — helpers-are-pure-not-ambient

§"each helper should be pure, and get its `passStyleOf` or similar function from its caller"

- §**No ambient `passStyleOf`** — the helpers don't reach for a module-level binding.
- §**Caller-provided dependency** — the core invokes the helper and passes `passStyleOfRecur` in as a parameter.
- §**Inversion of control** — sibling-pattern to cycle 262's §passStyleOfRecur-as-named-callback observation; here at the type level, the architectural reason is named: §to-avoid-cyclic-module-dependency + §to-allow-the-core-to-vary-its-passStyleOf-implementation-without-the-helpers-knowing.

§First-explicit-observation in library: **§the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline-named-explicitly-in-the-internal-types-doc-comment**.

§The-discipline-IS-named-at-the-type-level-not-at-the-instance-level — §the-three-concrete-helpers-instantiate-the-discipline + §the-typedef-file-DECLARES-the-discipline; §the-architectural-rationale-IS-named-where-the-protocol-is-defined-not-where-it's-implemented.

### §Discipline 2 — the trust model

§"they must defend against the other arguments being malicious, but may *assume* that `passStyleOfRecur` does what it is supposed to do"

§Three-attack-classes-implicit-in-the-trust-model:

1. **§Malicious-candidate** — the helper **MUST defend**. The candidate is untrusted input; the helper's whole job is to validate it.
2. **§Bugs in passStyleOfRecur** — the helper **MAY defend** against "some accidents" (line 17). Best-effort defensive coding, not a security boundary.
3. **§Malicious passStyleOfRecur** — the helper need **NOT defend**. The core is trusted; the helper assumes its callback does what it's supposed to.

§First-explicit-observation in library: **§the-three-attack-classes-implicit-in-the-trust-model-named-explicitly-in-the-internal-types-doc-comment — §the-helpers-defend-against-malicious-candidates + §may-defend-against-bugs-in-passStyleOfRecur + §need-not-defend-against-malicious-passStyleOfRecur**.

§The-trust-model-IS-asymmetric — §the-helpers-trust-the-core-but-not-the-candidates; §sibling-pattern to capability-systems' asymmetric-trust between caller-and-callee.

§The-`*assume*`-emphasis (markdown italic in the comment) — §the-italicization-IS-the-named-emphasis-on-the-trust-relationship; §the-emphasis-IS-load-bearing-because-the-discipline-IS-not-the-default; §first-explicit-observation in library of §the-italicized-`*assume*`-as-named-emphasis-on-a-load-bearing-trust-assumption.

§"may defend against some accidents" (line 17) — §explicit-bug-defense-allowance + §not-a-security-boundary; §the-spectrum-of-defense (must-defend + may-defend + need-not-defend) IS named at the type level.

## §The PassStyleHelper typedef — three properties define the protocol

Lines 19-30:
```js
/**
 * @typedef {object} PassStyleHelper
 * @property {PassStyle} styleName
 * @property {(candidate: any, reject: Rejector) => boolean} confirmCanBeValid
 * If `confirmCanBeValid` returns true, then the candidate would
 * definitely not be valid for any of the other helpers.
 * `assertRestValid` still needs to be called to determine if it
 * actually is valid, but only after the `confirmCanBeValid` check has passed.
 *
 * @property {(candidate: any,
 *             passStyleOfRecur: (val: any) => PassStyle
 *            ) => void} assertRestValid
 */
```

§Three-properties-define-the-PassStyleHelper-protocol:

### §styleName: PassStyle
The pass-style tag — `'byteArray'` for `ByteArrayHelper`, `'copyArray'` for `CopyArrayHelper`, `'copyRecord'` for `CopyRecordHelper`. §the-typedef-uses-the-narrowed-`PassStyle`-string-literal-union-not-`string` — §typing-the-tag-as-an-enumeration-not-a-string + §the-type-system-catches-typos-at-the-helper-declaration-site.

### §confirmCanBeValid: (candidate, reject) => boolean
The phase-1 loose check. §The-doc-property-description carries a §mutual-exclusivity-property:

> *If `confirmCanBeValid` returns true, then the candidate would definitely not be valid for any of the other helpers. `assertRestValid` still needs to be called to determine if it actually is valid, but only after the `confirmCanBeValid` check has passed.*

§First-explicit-observation in library: **§the-mutual-exclusivity-property-named-explicitly-in-the-PassStyleHelper-type-definition — §when-one-helper's-`confirmCanBeValid`-returns-true, §no-other-helper's-`confirmCanBeValid`-would-also-return-true**.

§The-property-IS-a-protocol-invariant + §it-IS-not-enforced-by-the-type-system + §it-IS-enforced-by-the-helpers'-implementations + §the-typedef-DOCUMENTS-the-invariant.

§The-relationship-between-`confirmCanBeValid`-and-`assertRestValid` is §a-two-phase-progressive-tightening (cycle 260's named pattern) — §the-phase-1-narrows-to-the-right-helper + §the-phase-2-validates-that-helper's-specific-rules; §the-typedef-DOCUMENTS-the-phase-1-IS-mutually-exclusive-across-the-cluster-but-not-sufficient-on-its-own.

### §assertRestValid: (candidate, passStyleOfRecur) => void
The phase-2 thorough check. §Returns-void-but-throws-on-failure — §the-`void`-return-type-IS-the-conventional-encoding-of-"throws-or-completes"; §sibling-pattern to many `assert`-style APIs.

§The-`passStyleOfRecur`-parameter — §the-callback-into-the-marshal-core; §the-type-IS-`(val: any) => PassStyle`; §the-core-knows-how-to-walk-children-and-tell-the-helper-the-child's-pass-style.

§The-three-fields-IS-the-cluster's-protocol-contract-as-a-three-tuple — §`(styleName, confirmCanBeValid, assertRestValid)`; §each-concrete-helper-supplies-all-three; §sibling-pattern to functional-language records or Haskell typeclass instances.

## §The doc comment of `confirmCanBeValid` is itself a §two-phase-protocol-documentation

The property description for `confirmCanBeValid` (lines 22-25) is **multi-paragraph**, even though property descriptions in JSDoc are conventionally single-line. The author chose to use multi-line JSDoc property descriptions to encode the §two-phase-protocol — §the-typedef-DOCUMENTS-the-cluster-invariant-in-the-property-description.

§First-explicit-observation in library: **§multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants-as-named-discipline — §when-the-property's-shape-isn't-enough-to-encode-the-invariant, §use-multi-paragraph-prose-in-the-`@property`-description**.

§Sibling-pattern to cycle 265's CLAUDE.md spec — both files use prose to encode invariants the structure can't express. §two-cycles-with-prose-encoded-invariants-where-structure-cannot-express (265 design-doc-template + 266 PassStyleHelper-mutual-exclusivity).

## §Cycle 266 first-explicit-observations roundup (nine)

1. **§two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side** (265 CLAUDE.md + 266 internal-types).
2. **§four-cycles-with-`export {};`-typedef-only-file-pattern** (254 + 256 + 258 + 266).
3. **§the-internal-types-file-depends-on-the-public-types-not-the-other-way-around**.
4. **§the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline-named-explicitly-in-the-internal-types-doc-comment**.
5. **§the-three-attack-classes-implicit-in-the-trust-model-named-explicitly-in-the-internal-types-doc-comment** (must-defend + may-defend + need-not-defend).
6. **§the-italicized-`*assume*`-as-named-emphasis-on-a-load-bearing-trust-assumption**.
7. **§the-mutual-exclusivity-property-named-explicitly-in-the-PassStyleHelper-type-definition**.
8. **§multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants-as-named-discipline**.
9. **§two-cycles-with-prose-encoded-invariants-where-structure-cannot-express** (265 + 266).

## §Recurring meta-pattern counters bumped at cycle 266

- §**four-cycles-with-`export {};`-typedef-only-file-pattern** (254 + 256 + 258 + 266).
- §**two-cycles-with-metalanguage-to-object-language-relationship** (265 CLAUDE.md + 266 internal-types).
- §**two-cycles-with-prose-encoded-invariants-where-structure-cannot-express** (265 + 266).
- §**six-cycles-with-doc-comment-IS-the-contract** (253 + 257 + 260 + 262 + 264 + 266).
- §**ninety-ninth consecutive designs-chat alternation cycles 166-250 + 252-266** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-internal-types.js-pattern-applies-to-game-engine-as-a-§game-engine-internal-types.js:

- §**`export {};`-typedef-only-file** for game-engine-protocol types.
- §**Two-cross-module-typedef-references** — `GameRejector` from `@game/errors/rejector.js` + `GameStyle` from `./types.js`.
- §**The module doc-comment names the architectural discipline** — §game-helpers-are-pure-not-ambient + §game-helpers-get-their-`gameStyleOfRecur`-from-the-caller-not-from-a-module-level-binding.
- §**Three attack classes implicit in the trust model** — §game-helpers-defend-against-malicious-game-tokens + §may-defend-against-bugs-in-the-game-core's-recursion + §need-not-defend-against-malicious-game-cores.
- §**The `GameStyleHelper` typedef** with three properties (styleName + confirmCanBeValid + assertRestValid).
- §**The mutual-exclusivity property** named explicitly — when one game-helper's confirmCanBeValid returns true, no other game-helper's would also return true.

## §Tier-1 borrowing

§two-cycles-with-metalanguage-to-object-language-relationship + §the-internal-types-file-depends-on-the-public-types-not-the-other-way-around + §the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline + §the-three-attack-classes-implicit-in-the-trust-model + §the-italicized-`*assume*`-as-named-emphasis + §the-mutual-exclusivity-property-named-explicitly + §multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants.

## §Tier-2 borrowing

§four-cycles-with-`export {};`-typedef-only-file-pattern + §the-two-`@import`-block-for-cross-module-typedef-references + §the-typedef-uses-the-narrowed-`PassStyle`-string-literal-union-not-`string` + §two-cycles-with-prose-encoded-invariants-where-structure-cannot-express.

## §Tier-3 borrowing

§six-cycles-with-doc-comment-IS-the-contract + §library-reaches-772-sections at cycle 266 + §ninety-ninth consecutive designs-chat alternation cycles 166-250 + 252-266.

## Pattern summary (tag-prefixed)

§the-PassStyleHelper-type-definition-as-metalanguage + §two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side + §`export {};`-typedef-only-file-pattern + §four-cycles-with-`export {};`-typedef-only-file-pattern + §the-internal-types-file-depends-on-the-public-types-not-the-other-way-around + §the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline-named-explicitly + §the-three-attack-classes-implicit-in-the-trust-model (must-defend + may-defend + need-not-defend) + §the-italicized-`*assume*`-as-named-emphasis-on-a-load-bearing-trust-assumption + §the-mutual-exclusivity-property-named-explicitly-in-the-PassStyleHelper-type-definition + §multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants-as-named-discipline + §two-cycles-with-prose-encoded-invariants-where-structure-cannot-express + §six-cycles-with-doc-comment-IS-the-contract.
