---
title: §The dummy `exports.js` companion
source-slug: endo--packages-far-src-index-js-and-exports-js
source-url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package
---

```js
// exports.js (2 lines)
// Just a dummy to use exports.d.ts and satisfy runtime imports.
export {};
```

§The-`exports.js`-IS-a-dummy. §Its-only-job: §let-the-corresponding-`exports.d.ts`-be-the-real-public-types + §satisfy-the-runtime-loader-when-something-does-`import * from './exports.js'`. §First-explicit-observation in library of §the-dummy-`.js`-companion-to-a-`.d.ts`-file as named TypeScript-and-runtime-bridge pattern.

§The-comment-explains-the-non-obvious-purpose: *Just a dummy to use exports.d.ts and satisfy runtime imports*. §When-a-file's-existence-is-non-obvious-because-its-content-is-trivial, §the-comment-IS-the-evidence-of-the-non-obvious-purpose + §don't-leave-the-reader-to-guess-why-the-file-exists.

§Sibling-pattern-to-cycle-247's-the-function-name-encodes-the-discipline and cycle-252's-`maybe<TargetType>`-as-named-parameter-naming-convention — §three-cycles-with-named-identifier-or-comment-encodes-the-discipline (247 function-name + 252 parameter-name + 258 file-purpose-comment). §The-evidence-of-the-design-is-in-the-naming-or-the-comment.

§Sibling-pattern-to-cycle-249's-`export {};`-typedef-only-file + cycle-256's-`export {};`-typedef-only-file — §three-cycles-with-`export {};`-marker (249 + 256 + 258). §Three-different-roles-for-`export {};`: §cycle-249-marks-typedef-only-protocol-file + §cycle-256-marks-typedef-only-Promise-and-ERef-vocabulary + §cycle-258-marks-the-runtime-companion-to-a-.d.ts.

§The-`exports.js`-and-`exports.d.ts`-form-a-pair: §`.d.ts`-IS-the-type-source + §`.js`-IS-the-runtime-marker + §the-pair-IS-how-TypeScript-and-Node.js-cooperate-for-pure-type-imports. §When-a-package-wants-to-export-types-but-no-runtime-values, §the-`.d.ts`-IS-the-source-of-truth + §the-`.js`-IS-the-stub-to-satisfy-the-loader.
