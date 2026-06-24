---
title: §Two CompareFn instances with stringCompare nested in pathCompare
source-slug: endo--packages-path-compare-src-index
source-url: https://github.com/endojs/endo/blob/master/packages/path-compare/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/path-compare/src/index.js
total-lines: 84
ingest-cycle: 237
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore
---

`stringCompare` is a one-liner:

```js
export const stringCompare = (a, b) => (a === b ? 0 : a < b ? -1 : 1);
```

§UTF-16-code-unit-comparison-via-JavaScript-`<`-operator. §Nested-ternary-with-eslint-disable: `// eslint-disable-next-line no-nested-ternary` is the named exception to a project lint rule. §Two-eslint-disable-no-nested-ternary in this 84-line file (one for `stringCompare`, one for the undefined branch in `pathCompare`). §When-a-rule-is-disabled-twice-in-a-small-file, §the-rule-is-not-fit-for-this-file's-style + §but-the-disable-comments-keep-the-rule-on-everywhere-else.

`pathCompare` calls `stringCompare(a[i], b[i])` in its loop. §Two-CompareFn-instances + §the-larger-CompareFn-uses-the-smaller-one + §the-smaller-CompareFn-is-the-atomic-element-comparison.

§CompareFn-template-type: `@template T The type of the values to compare` + `@callback CompareFn` + `@param {T} a` + `@param {T} b` + `@returns {number}`. §The-template-typedef-IS-the-contract. §JSDoc-callback-typedef-as-named-reusable-shape. The contract: "Negative integer if `a < b`; positive integer if `a > b`; `0` if equal" — §the-three-named-sign-cases.

§Type-precision: `CompareFn<string>` for `stringCompare` and `CompareFn<string[]|undefined>` for `pathCompare`. §The-type-parameter-encodes-the-comparator's-domain.
