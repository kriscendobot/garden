---
title: §The q alias — third variant
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
// For enquoting strings
const q = JSON.stringify;
```

§The-comment-`For enquoting strings` names the purpose of the alias + §the-`q`-alias-IS-the-shortcut-for-JSON.stringify. §Three-variants-of-stringify-aliasing-in-library:

- **Cycle 237**: `const { stringify: q } = JSON;` (destructure-rename — both shorthand and import).
- **Cycle 245**: `const { stringify } = JSON;` (destructure without rename — uses `stringify` directly).
- **Cycle 247**: `const q = JSON.stringify;` (direct property alias).

§Three-different-aliasing-conventions-in-three-cycles. §All-three-achieve-the-same-result + §all-three-have-different-stylistic-conventions. §The-canonical-`q`-name-for-stringify-as-quote-character + §the-comment-`For enquoting strings`-explains-why-the-letter-q. §When-a-codebase-uses-`q`-for-stringify, §the-context-of-each-file-determines-the-aliasing-shape (destructure-rename for `const { stringify: q } = JSON` + direct-property-for `const q = JSON.stringify`).

§First-explicit-observation in library of §three-different-stylistic-conventions-for-the-same-alias as a recurring discipline-with-variations.
