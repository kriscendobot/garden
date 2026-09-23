---
title: §Three export styles in one file
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles
---

```js
export const E = makeE(hp);
export { hp as HandledPromise };
export * from './exports.js';
```

§Three-different-export-styles: §named-export-via-binding-factory (`export const E = makeE(hp)`) + §named-export-via-rename-alias (`export { hp as HandledPromise }`) + §star-export-with-source (`export * from './exports.js'`).

§The-`export { hp as HandledPromise }` — §the-local-name-is-`hp`-but-the-external-name-is-`HandledPromise` + §the-`as`-clause-IS-the-renaming-on-export. §When-a-module-uses-a-short-local-alias-but-the-public-API-wants-the-canonical-name, §use-the-`export { local as Public }`-form. §Sibling-pattern-to-cycle-245's-`as` import-rename (cycle 245 imported with a rename; cycle 254 exports with a rename); §two-cycles-with-`as`-rename-in-module-boundary.

§The-`export *`-with-eslint-disable: `// eslint-disable-next-line import/export`. §The-eslint-rule-flags-conflicting-exports-but-the-author-knows-the-conflict-is-intentional. §The-eslint-disable-comment-IS-the-acknowledgment-of-the-known-conflict. §Sibling-pattern-to-cycle-245's-two-eslint-disables-with-distinct-named-justifications (two-cycles-with-named-eslint-disable-acknowledging-known-conflict).

§First-explicit-observation in library of §three-different-export-styles-in-one-file-as-named-shape.
