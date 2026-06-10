---
title: "@endo/promise-kit/src/is-promise.js — Promise.resolve(x) === x as canonical promise detection + type-predicate narrowing + twelve lines"
source-slug: endo--packages-promise-kit-src-is-promise-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
---

# Promise.resolve(x) === x as canonical promise detection + type-predicate narrowing + twelve lines

[`@endo/promise-kit/src/is-promise.js`](../sources/endo--packages-promise-kit-src-is-promise-js.md) is a §twelve-line-file containing one function: `isPromise(maybePromise)`. The function returns `Promise.resolve(maybePromise) === maybePromise`. This is the canonical way to detect whether a value is a genuine Promise (not just a thenable) in JavaScript.

## §The `Promise.resolve(x) === x` trick

```js
export function isPromise(maybePromise) {
  return Promise.resolve(maybePromise) === maybePromise;
}
```

§The-canonical-promise-detection: §Promise.resolve-applied-to-a-Promise-returns-the-same-Promise + §Promise.resolve-applied-to-anything-else-returns-a-new-Promise. §So-the-`===`-check-succeeds-iff-the-input-is-already-a-Promise.

§The-ES-spec-guarantees-this-behavior: §`Promise.resolve(value)`-checks-if-value-is-a-Promise-with-the-same-constructor + §if-so-returns-the-value-unchanged + §otherwise-wraps. §The-`===`-test-IS-the-evidence-of-the-unchanged-return.

§Why-not-duck-typing-via-`.then`: §a-thenable-(any object with a callable `.then`)-would-pass-a-duck-type-check + §but-a-thenable-is-not-the-same-as-a-Promise-instance. §The-Promise.resolve-trick-distinguishes-genuine-Promises-from-mere-thenables. §When-the-distinction-between-genuine-Promise-and-thenable-matters, §use-the-Promise.resolve-equality-trick + §not-the-`.then`-duck-type-check.

§First-explicit-observation in library of §`Promise.resolve(x) === x`-as-canonical-promise-detection.

§Sibling-pattern-to-cycle-243's-host-endian-detection-via-typed-array-aliasing — §two-cycles-with-canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose: §cycle-243-uses-Uint16-aliasing-to-detect-byte-order-from-typed-array-feature + §cycle-252-uses-Promise.resolve-identity-to-detect-Promise-instance-from-Promise.resolve-feature. §Both-tricks-leverage-an-incidental-property-of-the-feature-not-its-stated-purpose. §First-explicit-observation in library of §canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose-as-recurring-named-discipline.

## §Type-predicate narrowing via `maybePromise is Promise`

```js
/**
 * @param {unknown} maybePromise The value to examine
 * @returns {maybePromise is Promise} Whether it is a promise
 */
```

§The-JSDoc-`@returns`-uses-a-type-predicate-narrowing-form: §`{maybePromise is Promise}` tells TypeScript that the boolean-true return narrows the parameter type to `Promise`. §When-a-predicate-function-returns-a-boolean, §the-return-type-can-be-a-type-predicate + §callers-get-automatic-type-narrowing-in-the-`if (isPromise(x)) { ... }`-branch.

§`@param {unknown}`-as-the-honest-input-type: §the-parameter-could-be-anything + §`unknown`-is-the-honest-encoding-of-that + §narrower-types-would-be-misleading-when-the-function-is-being-used-to-discover-the-type.

§Two-named-TypeScript-disciplines-in-the-JSDoc: §`unknown`-for-the-honest-input-type + §type-predicate-narrowing-for-the-output. §When-a-detection-function-is-typed, §use-`unknown`-for-input + §use-type-predicate-narrowing-for-output. §First-explicit-observation in library of §`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline.

§Sibling-pattern-to-cycle-249's-`keyof InterfaceName`-as-defense-by-construction — §two-cycles-with-named-TypeScript-discipline-around-validation: §cycle-249-uses-keyof-to-prevent-string-union-drift + §cycle-252-uses-type-predicate-narrowing-to-bind-runtime-check-to-static-type.

## §`harden(isPromise)` immediately after declaration

```js
harden(isPromise);
```

§The-SES-convention-per-the-Endo-CLAUDE.md: *Every named export MUST have a corresponding `harden(exportName)` call immediately after the declaration*. §This-is-enforced-by-the-`@endo/harden-exports`-ESLint-rule.

§The-`harden(isPromise)` call freezes the function deeply + §prevents the function from being mutated by an attacker. §First-explicit-observation in library of §harden-immediately-after-export-as-named-SES-discipline (as a borrowable pattern, distinct from prior mentions where it was incidental).

§Sibling-pattern-to-cycle-247's-`const q = JSON.stringify;` — §two-cycles-with-immediate-post-declaration-treatment: §cycle-247-aliases-a-built-in-immediately + §cycle-252-hardens-an-export-immediately. §Two-different-shapes-of-immediate-post-declaration-step.

## §`harden` imported from `@endo/harden` not from a global

```js
import harden from '@endo/harden';
```

§The-`harden`-function-is-imported-as-a-default-from-`@endo/harden` + §not-relied-upon-as-a-global. §The-Endo-package-structure-IS-the-source-of-`harden` — §the-package-can-run-in-environments-where-SES-lockdown-hasn't-yet-installed-`harden`-as-a-global + §the-package's-tests-can-run-without-needing-SES.

§Sibling-pattern-to-cycle-242's-the-elevator-module — §two-cycles-with-explicit-platform-or-substrate-bridge-via-import: §cycle-242-platform-import-via-elevator-module + §cycle-252-`harden`-import-via-`@endo/harden`. §Two-different-shapes-of-explicit-import-rather-than-relying-on-the-ambient-global.

§First-explicit-observation in library of §`harden`-imported-from-`@endo/harden`-not-from-a-global as named package-portability discipline.

## §The named parameter `maybePromise` self-documents the predicate purpose

§The-parameter-name-`maybePromise` — §the-`maybe`-prefix-IS-the-uncertainty-signal + §the-`Promise`-noun-IS-the-target-type. §When-a-detection-function-takes-a-value-that-might-or-might-not-be-of-the-target-type, §name-the-parameter-`maybe<TargetType>` + §the-name-IS-the-predicate-semantics.

§Sibling-pattern-to-cycle-247's-the-function-name-encodes-the-discipline (`parseLocatedJson`) — §two-cycles-with-named-identifier-encodes-the-discipline: §cycle-247-function-name + §cycle-252-parameter-name. §Two-different-positions-where-the-name-IS-the-documentation.

§First-explicit-observation in library of §`maybe<TargetType>`-as-named-parameter-naming-convention-for-detection-functions.

## §Single-export named the same as the purpose

§The-file-exports-one-function: §`isPromise`. §The-export-name-IS-the-purpose-of-the-file. §When-a-file-contains-one-detection-function, §the-export-name-IS-the-file-name (modulo casing). §The-file-name-`is-promise.js`-mirrors-the-export-name-`isPromise`.

§Sibling-pattern-to-cycle-247's-`parseLocatedJson`-in-`json.js` — §two-cycles-with-single-function-files-whose-export-name-IS-the-file-name (loosely). §When-a-file-has-one-named-purpose, §the-file-name-and-the-export-name-converge.

§Five-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252) — bumped to **six cycles**.

## §Twelve lines as a complete promise-detection utility

§Twelve-lines + §one-import + §one-typedef-JSDoc + §one-function + §one-`harden`-call. §The-file-does-one-thing-exhaustively. §The-twelve-lines-include-the-import-the-JSDoc-the-function-body-and-the-harden-call — §nothing-is-padded.

§Six-cycles-with-small-files-that-each-isolate-one-named-decision (cycles 239 + 241 + 243 + 247 + 249 + 252). §The-recurring-pattern-IS-the-discipline-of-single-purpose-files. §When-a-named-decision-or-utility-can-be-isolated, §isolate-it-in-its-own-file-with-a-name-that-matches-its-export.

## §Why this trick matters for capability systems

§In-an-Endo-context-isPromise-IS-load-bearing — §the-distinction-between-a-genuine-Promise-and-a-thenable-affects-trust + §a-malicious-thenable-could-have-an-arbitrary-`.then`-method + §calling-its-`then`-runs-attacker-code. §Genuine-Promises-have-the-fixed-Promise-prototype + §their-`then`-method-is-the-canonical-Promise.prototype.then.

§When-the-application-deals-with-untrusted-values-and-needs-to-know-if-something-is-a-real-Promise, §the-`Promise.resolve`-trick-is-the-only-reliable-check. §The-trick's-load-bearing-role-IS-the-defense-against-malicious-thenables. §First-explicit-observation in library of §Promise.resolve-trick-as-defense-against-malicious-thenables.

§Sibling-pattern-to-cycle-249's-`applyMethod`-as-atomic-lookup-of-method-and-apply — §two-cycles-with-named-defense-against-substrate-confusion-attacks: §cycle-249-against-method-detach + §cycle-252-against-thenable-impersonation. §Two-different-shapes-of-substrate-confusion-attack-with-named-defenses.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §`Promise.resolve(x) === x`-as-canonical-promise-detection.
- §The-`Promise.resolve`-trick-IS-the-defense-against-malicious-thenables.
- §Canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (sibling to cycle 243's typed-array-aliasing for endianness detection).
- §`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline.
- §`@returns {x is T}`-type-predicate-narrowing for runtime-checks bound to static-types.
- §`harden(exportName)`-immediately-after-declaration as named SES discipline.
- §`harden` imported from `@endo/harden` not from a global — package-portability discipline.
- §`maybe<TargetType>`-as-named-parameter-naming-convention-for-detection-functions.

**Tier-2 (file-shape patterns):**

- §Twelve-lines-as-a-complete-promise-detection-utility.
- §Single-export-named-the-same-as-the-purpose.
- §The-file-name-and-the-export-name-converge.
- §The-file-does-one-thing-exhaustively.

**Tier-3 (named comparisons):**

- §Two-cycles-with-canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (243 + 252).
- §Two-cycles-with-named-defense-against-substrate-confusion-attacks (249 + 252).
- §Two-cycles-with-named-TypeScript-discipline-around-validation (249 + 252).
- §Two-cycles-with-named-identifier-encodes-the-discipline (247 + 252).

## §Synthesis target — slot machine library

For a slot machine library:

- §`isGameToken(maybeToken)`-via-Promise.resolve-equivalent — §canonical-game-token-detection via an identity-preserving operation.
- §The-canonical-trick-defense for §game-token-not-game-token-thenable-impersonation.
- §`unknown`-plus-type-predicate-narrowing for §game-token-detection-function-type-discipline.
- §`harden(isGameToken)` immediately after declaration.
- §`maybe<TargetType>`-as-named-parameter-naming-convention for §game-token-detection-functions.
- §Single-export-named-the-same-as-the-purpose for §game-feature-files.
- §The-file-does-one-thing-exhaustively for §game-utility-files.

## §Library meta-counters

- §Library-reaches-758-sections at cycle 252 (chat-lane @endo/promise-kit/src/is-promise).
- §Eighty-fifth-consecutive designs-chat alternation cycle (cycles 166-250 + 252; cycle 251 was out-of-band papers).
- §Forty-second-member of §small-files-with-large-knowledge-density family.
- §Six-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252).
- §Two-cycles-with-canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (243 + 252) — first instance of this meta-pattern.
- §Two-cycles-with-named-defense-against-substrate-confusion-attacks (249 + 252).
- §Two-cycles-with-named-TypeScript-discipline-around-validation (249 + 252).
- §Two-cycles-with-named-identifier-encodes-the-discipline (247 function-name + 252 parameter-name).
- §First-explicit-observation of seven patterns: §`Promise.resolve(x) === x`-as-canonical-promise-detection + §Promise.resolve-trick-as-defense-against-malicious-thenables + §canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose-as-recurring-named-discipline + §`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline + §harden-immediately-after-export-as-named-SES-discipline + §`harden`-imported-from-`@endo/harden`-not-from-a-global + §`maybe<TargetType>`-as-named-parameter-naming-convention.

(Endo Project Contributors authored)
