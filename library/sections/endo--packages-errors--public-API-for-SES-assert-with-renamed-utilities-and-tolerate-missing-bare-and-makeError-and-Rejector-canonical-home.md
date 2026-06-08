---
title: "@endo/errors — §public-API-for-SES-assert + §rename-utilities-split-from-assertions + §tolerate-missing-bare-and-makeError-for-Agoric-bootstrap-vat + §Rejector-canonical-home + §hideAndHardenFunction-canonical-definition"
source-slug: endo--packages-errors
section-id: public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home
url: https://github.com/endojs/endo/tree/master/packages/errors
authors: [Endo contributors]
repo: endojs/endo
path: packages/errors/{index.js,rejector.js,README.md}
status: shipping
ingest-cycle: 217
ingest-date: 2026-06-07
lane: chat
---

# @endo/errors — §public-API-for-SES-assert + §Rejector-canonical-home + §hideAndHardenFunction-canonical-definition

`@endo/errors` is the §public-import-surface for the SES `assert` substrate (cycle 98). 132-line `index.js` + 23-line `rejector.js` + small README. §The-load-bearing-purpose stated in the README:

> When host and guest programs share a JavaScript context, there is some risk that the guest will call a host function and induce it to throw an exception that inadvertently reveals information about its internal state to the guest. [...] For this reason, the `@endo/errors` package provides utilities for constructing errors with redacted messages.

§Redaction-as-a-cross-context-defense — the package §exists-because-information-leaks-between-host-and-guest-are-a-security-problem.

## §Resource-module disclaimer

The opening comment names the package's place in the SES dependency stack:

> This module assumes the existence of a non-standard `assert` host object. SES version 0.11.0 introduces this global object and entangles it with the `console` host object in scope when it initializes [...] To the extent that this `console` is considered a resource, this module must be considered a resource module.

§Resource-module-discipline — the package's import order matters; it transitively depends on `globalThis.assert` being installed by SES first; the §entanglement-with-console gives the package §the-power-to-hide-details-from-guests-but-reveal-them-to-the-debugger-console.

## §Strict-fail-on-load-if-missing-prerequisite

```js
if (globalAssert === undefined) {
  throw Error(
    `Cannot initialize @endo/errors, missing globalThis.assert, import 'ses' before '@endo/errors'`,
  );
}
```

§Fail-loud-not-degrade — same discipline as cycle 100 (makeRejectionHandlers) and cycle 216 (lal-transcript-memory-management). §Error-message-tells-the-user-what-to-do (*import 'ses' before '@endo/errors'*). §Borrowable-pattern: §when-a-module-depends-on-a-side-effect-from-another-module, §load-time-check-with-actionable-error-message.

## §Enumerate-required-methods-and-tolerate-missing-ones

```js
const missing = [
  'typeof', 'fail', 'equal', 'string', 'note', 'details',
  'Fail', 'quote',
  // 'bare',
  // 'makeError',
  'makeAssert',
].filter(name => globalAssert[name] === undefined);
if (globalAssert.makeError === undefined && globalAssert.error === undefined) {
  missing.push('makeError');
}
if (missing.length > 0) {
  throw Error(
    `Cannot initialize @endo/errors, missing globalThis.assert methods ${missing.join(', ')}`,
  );
}
```

§Two-comment-out-lines (`'bare'` and `'makeError'`) are §load-bearing-comments-not-decoration — they §encode-a-tolerance-for-an-older-SES. The §honest-acknowledgment-comment:

> As of 2025-07, the Agoric chain's bootstrap vat runs with a version of SES that predates addition of the 'bare' and 'makeError' methods, so we must tolerate their absence and fall back to other behavior in that environment (see below).

§Named-tolerance-for-a-specific-runtime-environment — sibling to:

| Cycle | Source | Compat hack |
| --- | --- | --- |
| 199 | nat | Apps-Script bigint-literal-workaround |
| 205 | evasive-transform | Babel-traverse default-import-workaround |
| 213 | stream-node | Node-14 unhandled-error-race-defense |
| 217 | errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |

§Four-different-runtime-version-or-environment-compat-hacks now in library. §The-pattern: §name-the-specific-environment-and-the-specific-missing-feature; §don't-pretend-it's-not-there.

## §Rename-utilities-split-from-assertions

```js
const {
  bare: globalBare,
  details,
  error: globalError,
  Fail,
  makeAssert: _omittedMakeAssert,
  makeError: globalMakeError,
  note,
  quote,
  ...assertions
} = globalAssert;
```

§The-global-assert-mixed-assertions-and-utility-functions. §This-module-splits-them-apart. §The-rest-spread captures everything-not-named-above as the §assertion-functions; the named bindings are §utility-functions.

§Borrowable-pattern: §when-a-substrate-API-mixes-two-different-shapes, §split-them-in-the-public-API + §rename-as-needed-for-domain-readability. The §rest-spread-collects-everything-not-named is the §clean-way-to-discriminate.

§Omit-makeAssert pattern: `makeAssert: _omittedMakeAssert` extracts but does not re-export — §destructure-with-underscore-prefix-to-deliberately-discard.

## §Honest-fallback-policy

```js
const bare = globalBare || quote;
const makeError = globalMakeError || globalError;
```

§Two-named-fallbacks for the §missing-in-pre-1.13.0-SES case. §The-comment-pinpoints-the-fallback:

> As of 2025-07, the Agoric chain's bootstrap vat runs with a version of SES that predates the addition of the 'bare' and 'makeError' methods, so we must fall back to 'quote' for the former and 'error' for the latter.

§Named-runtime-compat-fallback. §The-fallback-is-honest-not-silent (the comment names it explicitly).

## §Conventional-abbreviations + §named-aliases

```js
export const b = bare;
export const X = details;
export const q = quote;

export const annotateError = note;
export const redacted = details;
export const throwRedacted = Fail;
```

§Two-different-naming-conventions-for-the-same-functions:

- §Conventional-abbreviations: `b` / `X` / `q` — §short-names-for-frequent-use-in-template-literals (e.g. `assert(x, X`bad value: ${q(x)}``)`).
- §Named-aliases: `annotateError` / `redacted` / `throwRedacted` — §domain-readable-names-for-prose-call-sites.

§Borrowable-pattern: §when-a-function-is-used-both-in-templates-and-in-prose, §export-it-under-two-names.

## §hideAndHardenFunction canonical definition

This is the canonical home for the §hideAndHardenFunction discipline appearing throughout the library (cycles 102, 134, 138, 142, 148, etc.):

```js
export const hideAndHardenFunction = func => {
  typeof func === 'function' || Fail`${func} must be a function`;
  const { name } = func;
  defineProperty(func, 'name', {
    // Use `String` in case `name` is a symbol.
    value: `__HIDE_${String(name)}`,
  });
  return harden(func);
};
```

The JSDoc explains the mechanism:

> `stackFiltering: 'omit-frames'` and `stackFiltering: 'concise'` omit frames not only of "obvious" infrastructure functions, but also of functions whose `name` property begins with `'__HIDE_'`. (Note: currently these options only work on v8.)

§The-`__HIDE_`-prefix-is-the-protocol — it interlocks with cycle 93's tame-v8-error-constructor.js's `__HIDE_` function-name censor. §The-protocol-bridges-two-packages: the censor lives in `packages/ses/src/error/tame-v8-error-constructor.js`; the §marker-installer lives here.

§Borrowable-pattern: §protocol-via-name-prefix is a §lightweight-cross-module-coordination-shape — no shared symbol, no shared registry, just a §string-prefix-convention. §The-cost-is-that-the-prefix-becomes-a-reserved-string-pattern.

§Use-`String`-in-case-name-is-a-symbol — defensive-coercion for the rare-but-not-impossible §function-with-symbol-named.

§Drop-in-replacement-for-`harden`: §You-can-say-`hideAndHardenFunction(func)`-where-you-would-normally-first-say-`harden(func)`.

§Currently-v8-only — §honest-disclosure-of-implementation-limitation.

## §Rejector canonical home (rejector.js)

The §Rejector type is referenced throughout @endo/patterns and @endo/exo (cycles 102, 104, 110, 115, 120, 123, 125, 127, 150). The canonical definition lives here:

```js
/**
 * Either
 * - `false`
 * - or an object like `Fail`
 *
 * A `Rejector` should be used as
 * ```js
 * cond || reject && reject`...`
 * ```
 * If `cond` is truthy, that is the value of the expression.
 * Else if `reject` is false, it is the value
 * Otherwise, invoke `reject` just like you would invoke `Fail`, with the
 * same template arguments. This throws the same kind of Error object that
 * `Fail` would throw, typically because it is the `Fail` template literal
 * tag itself.
 *
 * See rejector.test.js for illustrative examples.
 *
 * @typedef {false | typeof Fail} Rejector
 */
```

§Rejector = false | typeof Fail. §Three-line-idiom: `cond || reject && reject\`...\``. §Three-cases:
1. `cond` truthy → value of expression.
2. `cond` falsy + `reject` false → `false` is the value.
3. `cond` falsy + `reject` is Fail-like → throws.

§The-dual-mode-pattern lets one function-shape serve as both §a-predicate (when called with `reject = false`) and §an-assertion (when called with `reject = Fail`). §Borrowable-pattern: §parameter-controlled-error-vs-silent-failure makes one implementation serve both checking patterns.

§Tests-as-illustrative-examples — §See-rejector.test.js-for-illustrative-examples; §the-test-file-is-the-second-half-of-the-documentation.

§Borrowable-pattern: §when-a-pattern-is-hard-to-express-in-prose-or-types, §point-readers-at-the-test-file as the §living-documentation.

## §Resource-module property revisited

The package's §share-the-console-channel-with-SES property is what makes it §a-resource-module:

- Assertions thrown via `Fail`/`assert` are §redacted-in-the-thrown-error-message but §revealed-in-the-developer-console (via cycle 90's track-turns + cycle 93's stack-trace taming + cycle 96's causal-console + cycle 98's assert.js loggedErrorHandler bridge).
- §Two-channels-for-two-audiences: §thrown-Error-for-the-caller (redacted) + §console-log-for-the-debugger (full).

§Borrowable-pattern: §security-vs-diagnostic-tension resolved by §two-channels-with-different-trust-levels. The §debugger-channel-is-the-privileged-side; §the-thrown-error-is-the-untrusted-side.

## §Library scope

The package is the public-API-surface for the SES error/assert substrate. §What-other-cycles-import-from-here:

- §`hideAndHardenFunction` — used by cycles 102, 134, 138, 142, 148.
- §`Rejector` typedef — used by cycles 102, 104, 110, 115, 120, 123, 125, 127, 150.
- §`Fail` / `q` / `X` / `b` — used everywhere assertions are thrown.
- §`assert` / `annotateError` / `note` — used in @endo/marshal, @endo/pass-style, @endo/patterns.

§This-is-the-package-that-makes-the-Rejector-and-hideAndHardenFunction-disciplines-portable. §The-disciplines-themselves-live-in-this-file; §the-application-of-them-lives-everywhere-else.

## Related material in the library

- **cycle 98 ses/src/error/assert.js**: §the-substrate this package re-exports.
- **cycle 90 ses/src/eventual-send/track-turns.js**: §causal-console-annotations producer.
- **cycle 93 ses/src/error/tame-v8-error-constructor.js**: §the-`__HIDE_`-prefix-censor — the §protocol-partner for `hideAndHardenFunction`.
- **cycle 96 ses/src/error/console.js**: §causal-console-renderer.
- **cycle 100 ses/src/error/unhandled-rejection.js**: §GC-driven-rejection-tracking; §fail-loud-not-degrade sibling.
- **cycle 102 @endo/patterns checkKey.js**: §Rejector-trio-pattern; §first concrete use of the Rejector typedef defined here.
- **cycles 199 nat / 205 evasive-transform / 213 stream-node**: §runtime-version-or-environment-compat-hacks siblings; cycle 217 adds the fourth (§pre-1.13.0-SES-Agoric-bootstrap-vat-tolerance).
- **cycle 134 pass-style/remotable.js + cycle 136 pass-style/make-far.js**: §hideAndHardenFunction-discipline consumers.
- **cycle 215 @endo/hex**: §harden-every-export sibling — both packages take §the-belt-and-braces-defensive-stance.
- **cycle 216 lal-transcript-memory-management**: §fail-loud-not-degrade sibling at the application-layer.

## §Library-reaches-723-sections at cycle 217 (chat-lane @endo/errors).

## §Four-different-runtime-version-or-environment-compat-hacks family (now four members):

| Cycle | Source | Hack |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |

§The-pattern-grows-to-four-members. §Each-hack-names-the-specific-environment-and-the-specific-missing-feature; §none-pretend-the-problem-doesn't-exist.

## §Fiftieth-and-first consecutive designs-chat alternation cycle 166-217.
