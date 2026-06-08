---
title: "@endo/check-bundle/src/json.js — parseLocatedJson augments SyntaxError with location + q as direct stringify alias + SyntaxError without new"
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
---

# parseLocatedJson augments SyntaxError with location + q as direct stringify alias + SyntaxError without new

[`@endo/check-bundle/src/json.js`](../sources/endo--packages-check-bundle-src-json-js.md) is a §22-line-file that exports a single function — `parseLocatedJson` — which wraps `JSON.parse` and augments any `SyntaxError` it throws with the location of the offending file. The file is a small but instructive showcase of error-augmentation discipline.

## §The single-function file

§The-file-exports-one-function + §the-name-of-the-function-IS-the-purpose. §When-an-error-augmentation-utility-is-needed-by-multiple-modules, §isolate-it-in-its-own-file-with-a-named-function + §the-named-function-IS-the-API. §Fourth-cycle-with-small-files-that-each-isolate-one-named-decision (cycles 239 + 241 + 243 + 247).

§Sibling-pattern-to-cycle-243's-host-endian.js (9-line single-fact file) — §two-shapes-of-isolated-named-decision: §cycle-243-isolates-a-platform-fact + §cycle-247-isolates-an-error-augmentation. §Two-different-substrates-for-the-isolate-in-own-file-discipline.

## §The q alias — third variant

```js
// For enquoting strings
const q = JSON.stringify;
```

§The-comment-`For enquoting strings` names the purpose of the alias + §the-`q`-alias-IS-the-shortcut-for-JSON.stringify. §Three-variants-of-stringify-aliasing-in-library:

- **Cycle 237**: `const { stringify: q } = JSON;` (destructure-rename — both shorthand and import).
- **Cycle 245**: `const { stringify } = JSON;` (destructure without rename — uses `stringify` directly).
- **Cycle 247**: `const q = JSON.stringify;` (direct property alias).

§Three-different-aliasing-conventions-in-three-cycles. §All-three-achieve-the-same-result + §all-three-have-different-stylistic-conventions. §The-canonical-`q`-name-for-stringify-as-quote-character + §the-comment-`For enquoting strings`-explains-why-the-letter-q. §When-a-codebase-uses-`q`-for-stringify, §the-context-of-each-file-determines-the-aliasing-shape (destructure-rename for `const { stringify: q } = JSON` + direct-property-for `const q = JSON.stringify`).

§First-explicit-observation in library of §three-different-stylistic-conventions-for-the-same-alias as a recurring discipline-with-variations.

## §parseLocatedJson — augment SyntaxError with location

```js
export const parseLocatedJson = (source, location) => {
  try {
    return JSON.parse(source);
  } catch (error) {
    if (error instanceof SyntaxError) {
      throw SyntaxError(`Cannot parse JSON from ${q(location)}, ${error}`);
    }
    throw error;
  }
};
```

§The-function-takes-`source`-AND-`location` + §location-is-passed-but-not-used-by-JSON.parse + §location-is-only-used-on-the-error-path. §When-a-parse-error-occurs-the-caller-wants-to-know-which-file-failed-not-just-that-it-failed. §The-location-is-the-context-the-error-needs-but-doesn't-have.

§First-explicit-observation in library of §augment-the-error-with-location-on-the-error-path-only as named-discipline. §The-location-doesn't-affect-the-success-path + §the-cost-is-only-paid-when-an-error-occurs.

## §Two named error cases — SyntaxError augmented, others rethrown

§The-`catch`-block-discriminates: §SyntaxError-gets-augmented + §non-SyntaxError-rethrown-unchanged. §When-a-try-catch-augments-errors, §discriminate-which-errors-to-augment + §rethrow-the-rest-unchanged + §don't-over-catch.

§The-`instanceof SyntaxError` check — §the-discrimination-IS-the-narrow-augmentation-scope. §When-JSON.parse-throws-something-other-than-SyntaxError-it's-a-bug-not-a-parse-failure + §rethrow-the-unexpected-error-without-wrapping-so-the-caller-sees-it-undisguised.

§Sibling-pattern-to-cycle-241's-`.catch(reject)` propagates-failure — §two-cycles-with-explicit-error-propagation-discrimination: §cycle-241-propagates-failure-on-the-deferred-path + §cycle-247-rethrows-non-SyntaxError-on-the-augmentation-path.

§Two-named-error-cases as design discipline: §expected-error-augmented-with-context + §unexpected-error-rethrown-undisguised. §When-an-error-handler-handles-only-one-kind-of-error, §discriminate-explicitly + §rethrow-the-rest-not-just-ignore-them.

## §SyntaxError without `new`

```js
throw SyntaxError(`Cannot parse JSON from ${q(location)}, ${error}`);
```

§`throw SyntaxError(...)`-WITHOUT-the-`new`-keyword + §Error-subclass-constructors-are-callable-as-functions-since-ES6 + §`new SyntaxError(msg)`-and-`SyntaxError(msg)`-are-semantically-identical. §The-author-chose-the-shorter-form.

§First-explicit-observation in library of §Error-constructor-without-`new` as named stylistic choice. §When-the-error-constructor-doesn't-need-`new`-and-doesn't-allocate-extra-state, §the-shorter-call-syntax-is-equivalent + §the-form-IS-the-choice-not-an-error. §JavaScript's-Error-and-Error-subclass-constructors-explicitly-support-this-since-ES6 (the `[[Construct]]` and `[[Call]]` slots are coherent).

§Sibling-pattern-to-cycle-243's-named-form-over-IIFE-form — §two-cycles-with-deliberate-stylistic-choice-over-equivalent-shorter-or-longer-form. §Cycle-243-prefers-named-form-over-IIFE; §cycle-247-prefers-call-form-over-new-form. §Two-different-axes-of-stylistic-preference.

## §The error becomes a string via template-literal coercion

```js
`Cannot parse JSON from ${q(location)}, ${error}`
```

§The-`${error}`-template-coercion calls `error.toString()` automatically + §the-resulting-string-includes-the-error's-name-and-message-but-not-the-stack. §When-augmenting-an-error-with-a-new-message-and-including-the-original-error's-message-as-context, §use-template-literal-coercion-to-stringify-the-error + §don't-extract-`.message`-explicitly.

§The-resulting-error-loses-the-original's-stack-trace + §the-new-SyntaxError-has-the-augment's-stack-trace-from-the-throw-site + §this-is-a-known-cost. §If-the-original-stack-matters, §use-`{ cause: error }`-instead-of-template-coercion. §Cycle-247-doesn't-do-this — §the-choice-is-implicit: §the-original-stack-is-not-needed-for-parse-errors-because-the-location-string-already-tells-the-user-where.

§First-explicit-observation in library of §template-literal-error-coercion-loses-stack-trace as named-trade-off.

## §Location is q-quoted before inclusion

```js
`Cannot parse JSON from ${q(location)}, ${error}`
```

§The-location-string-is-q-quoted-before-being-included-in-the-error-message. §`q(location)`-produces-the-JSON-encoded-form (with surrounding quotes + escaped special characters). §When-a-location-might-contain-special-characters (spaces, quotes, control chars), §JSON-encode-it-for-safe-inclusion-in-the-error-message.

§Sibling-pattern-to-cycle-237's-`q({ a, b })` for-structured-value-in-error-message — §two-cycles-with-q-applied-to-error-message-context. §Cycle-237-q's-a-structured-object; §cycle-247-q's-a-string-for-safe-quoting. §Two-different-uses-of-q-in-error-messages.

§Three-cycles-with-q-in-error-message-context if we count cycle 240's q-from-`@endo/errors` (which is the `q` template-tag, a different shape but same name). §The-name-`q`-is-recurring-with-three-different-call-shapes (single-letter-function-from-JSON + bare-template-tag-from-endo-errors + alias-to-JSON.stringify).

## §Why @endo/check-bundle needs location-aware parsing

§check-bundle-reads-bundle-files-from-disk + §each-bundle-is-a-JSON-document + §a-parse-failure-without-location-context-IS-useless-when-many-bundles-are-being-loaded. §The-location-IS-the-key-to-which-bundle-failed. §The-augmentation-IS-the-difference-between-"some-JSON-failed"-and-"`./foo.bundle`-failed".

§When-a-utility-processes-many-files-and-might-fail-on-any-of-them, §the-error-must-name-the-file-or-the-debug-experience-is-broken. §The-`parseLocatedJson`-name-itself-encodes-the-discipline + §the-parameter-`location`-IS-the-required-context.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §The-single-function-file — isolate one error-augmentation utility in its own named file.
- §Augment-the-error-with-location-on-the-error-path-only — the cost is only paid when an error occurs.
- §Two-named-error-cases — expected error augmented with context + unexpected error rethrown undisguised.
- §The-`instanceof SyntaxError`-discrimination as named narrow scope.
- §Template-literal-error-coercion via `${error}` (with named stack-trace-loss trade-off).
- §Location-q-quoted-before-inclusion via JSON.stringify for safe special-character handling.

**Tier-2 (stylistic patterns):**

- §The-q-alias as direct property alias (`const q = JSON.stringify;`).
- §Comment-`For enquoting strings` explains why the letter q.
- §SyntaxError-without-`new` as stylistic shorter form.
- §The-resulting-error-loses-the-original's-stack-trace as named-trade-off.

**Tier-3 (file-shape patterns):**

- §Twenty-two-lines-as-a-complete-error-augmentation-utility.
- §The-function-name-encodes-the-discipline (`parseLocatedJson` names its augmentation).
- §The-parameter-`location`-IS-the-required-context (parameter name encodes the contract).

## §Synthesis target — slot machine library

For a slot machine library:

- §The-single-function-file — isolate one game-rule-loader-augmentation utility per file.
- §Augment-the-error-with-game-rule-location for §when-a-game-rule-fails-to-parse-the-user-needs-to-know-which-rule.
- §Two-named-error-cases for §game-rule-parse-error-augmented + §unexpected-error-rethrown.
- §The-q-alias as direct property alias for §game-error-messages-with-safe-quoting.
- §SyntaxError-without-`new` as stylistic shorter form for §game-engine-error-construction.
- §The-function-name-encodes-the-discipline for §game-loader-function-names.

## §Library meta-counters

- §Library-reaches-753-sections at cycle 247 (chat-lane @endo/check-bundle/src/json).
- §Eighty-first-consecutive designs-chat alternation cycle (cycles 166-247).
- §First-direct-ingest from `@endo/check-bundle/src/`.
- §Fortieth-member of §small-files-with-large-knowledge-density family.
- §Four-cycles-with-small-files-that-each-isolate-one-named-decision (cycles 239 + 241 + 243 + 247).
- §Three-different-stylistic-conventions-for-q-alias (237 destructure-rename + 245 destructure-no-rename + 247 direct-property).
- §Three-cycles-with-q-in-error-message-context (237 q'd-structured-value + 247 q'd-string).
- §Two-cycles-with-deliberate-stylistic-choice-over-equivalent-form (243 named-vs-IIFE + 247 call-vs-new).
- §First-explicit-observation of four patterns: §augment-the-error-with-location-on-the-error-path-only + §two-named-error-cases (augmented + rethrown) + §Error-constructor-without-`new` + §template-literal-error-coercion-loses-stack-trace.

(Endo Project Contributors authored)
