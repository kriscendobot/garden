---
title: §hideAndHardenFunction canonical definition
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
parent: endo--packages-errors--public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home
---

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
