---
title: §string.js — §don't-coerce-input + §env-option-gated-strictness
source-slug: endo--packages-pass-style-helpers-cluster
section-id: PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
---

```js
export const isWellFormedString = hasWellFormedStringMethod
  ? str => typeof str === 'string' && str.isWellFormed()
  : str => {
      if (typeof str !== 'string') {
        return false;
      }
      // ... polyfill iteration ...
    };
```

§Don't-coerce-input — the standard `String.prototype.isWellFormed` §coerces-non-strings-to-strings before checking. §This-package-doesn't-want-that-behavior. The comment:

> Unfortunately, the standard built-in `String.prototype.isWellFormed` does a ToString on its input, causing it to judge non-strings to be well-formed strings if they coerce to a well-formed strings. This recapitulates the mistake in having the global `isNaN` coerce its inputs, causing it to judge non-string to be NaN if they coerce to NaN.

§Borrowable-pattern: §wrap-the-platform-method-with-an-explicit-typeof-check + §explain-why-in-the-comment + §cite-the-isNaN-precedent. §The-coercion-is-the-mistake; §this-package-fixes-it-by-pre-checking-typeof.

§Three-different-shapes-for-don't-coerce-input in library:
- Cycle 142 @endo/pass-style/passStyle-helpers: §isPrimitive's-safer-but-slower-on-XS trade-off (`Object(val) !== val` would be safer but expensive).
- Cycle 227 pass-style/string: §pre-typeof-check-before-platform-method.
- (any other?)

§Borrowable-pattern: §when-the-platform-method-coerces, §guard-it-with-typeof-check.

### §env-option-gated-strictness

```js
const ONLY_WELL_FORMED_STRINGS_PASSABLE =
  getEnvironmentOption('ONLY_WELL_FORMED_STRINGS_PASSABLE', 'disabled', [
    'enabled',
  ]) === 'enabled';

export const assertPassableString = str => {
  typeof str === 'string' || Fail`Expected string ${str}`;
  !ONLY_WELL_FORMED_STRINGS_PASSABLE || assertWellFormedString(str);
};
```

§Env-option-gates-additional-strictness. §The-default-is-disabled because §we-do-not-yet-know-the-performance-impact. §Two-modes-with-explicit-future-plan:

> Currently, `ONLY_WELL_FORMED_STRINGS_PASSABLE` defaults to `'disabled'` because we do not yet know the performance impact. Later, if we decide we can afford it, we'll first change the default to `'enabled'` and ultimately remove the switch altogether. Be prepared for these changes.

§Borrowable-pattern: §env-option-gated-strictness with §named-three-phase-plan (default-disabled → default-enabled → switch-removed). §The-comment-tells-the-consumer-what-to-expect-over-time.

§Sibling to cycle 130 message-breakpoints.js's §env-option-yields-undefined-when-unset (cycle 130's env-option is feature-presence; cycle 227's env-option is strictness-mode). §Two-different-purposes-for-env-options.

§Three-cycles-on-env-option-gated-features now:
- Cycle 130 message-breakpoints.js: feature-presence + zero-cost-when-unset.
- Cycle 217 @endo/errors: load-bearing-comment-out-lines (similar shape — disabled by default).
- Cycle 227 pass-style/string: strictness-mode with named-three-phase-plan.

§Three-different-shapes-for-env-option-controlled-features.
