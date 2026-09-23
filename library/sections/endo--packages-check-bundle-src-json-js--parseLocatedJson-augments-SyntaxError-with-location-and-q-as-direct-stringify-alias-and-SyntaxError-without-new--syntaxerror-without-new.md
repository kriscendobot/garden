---
title: §SyntaxError without `new`
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new
---

```js
throw SyntaxError(`Cannot parse JSON from ${q(location)}, ${error}`);
```

§`throw SyntaxError(...)`-WITHOUT-the-`new`-keyword + §Error-subclass-constructors-are-callable-as-functions-since-ES6 + §`new SyntaxError(msg)`-and-`SyntaxError(msg)`-are-semantically-identical. §The-author-chose-the-shorter-form.

§First-explicit-observation in library of §Error-constructor-without-`new` as named stylistic choice. §When-the-error-constructor-doesn't-need-`new`-and-doesn't-allocate-extra-state, §the-shorter-call-syntax-is-equivalent + §the-form-IS-the-choice-not-an-error. §JavaScript's-Error-and-Error-subclass-constructors-explicitly-support-this-since-ES6 (the `[[Construct]]` and `[[Call]]` slots are coherent).

§Sibling-pattern-to-cycle-243's-named-form-over-IIFE-form — §two-cycles-with-deliberate-stylistic-choice-over-equivalent-shorter-or-longer-form. §Cycle-243-prefers-named-form-over-IIFE; §cycle-247-prefers-call-form-over-new-form. §Two-different-axes-of-stylistic-preference.
