---
title: §The error becomes a string via template-literal coercion
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
`Cannot parse JSON from ${q(location)}, ${error}`
```

§The-`${error}`-template-coercion calls `error.toString()` automatically + §the-resulting-string-includes-the-error's-name-and-message-but-not-the-stack. §When-augmenting-an-error-with-a-new-message-and-including-the-original-error's-message-as-context, §use-template-literal-coercion-to-stringify-the-error + §don't-extract-`.message`-explicitly.

§The-resulting-error-loses-the-original's-stack-trace + §the-new-SyntaxError-has-the-augment's-stack-trace-from-the-throw-site + §this-is-a-known-cost. §If-the-original-stack-matters, §use-`{ cause: error }`-instead-of-template-coercion. §Cycle-247-doesn't-do-this — §the-choice-is-implicit: §the-original-stack-is-not-needed-for-parse-errors-because-the-location-string-already-tells-the-user-where.

§First-explicit-observation in library of §template-literal-error-coercion-loses-stack-trace as named-trade-off.
