---
title: §The package IS a curated re-export set
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
// index.js (5 lines)
export { E } from '@endo/eventual-send';
export { Far, getInterfaceOf, passStyleOf } from '@endo/pass-style';

// eslint-disable-next-line import/export
export * from './exports.js';
```

§Four-named-re-exports from §two-named-upstream-packages: §`E` from `@endo/eventual-send` + §`Far`, `getInterfaceOf`, `passStyleOf` from `@endo/pass-style`. §The-package's-existence-IS-the-curation — §`@endo/far` is not a runtime library; it's a single import path that bundles the canonical capability-call operations.

§First-explicit-observation in library of §the-package-IS-a-curated-re-export-set as named-package-purpose. §When-a-package's-job-is-to-name-a-canonical-vocabulary-not-to-implement-it, §the-package-IS-curated-re-exports-from-the-actual-implementations. §The-package-name (`@endo/far`) is the user-facing-name + §the-implementation-packages (`@endo/eventual-send`, `@endo/pass-style`) are the internal-substrate.

§Sibling-pattern-to-cycle-254's-no-shim's-`export *`-with-eslint-disable — §two-cycles-with-`export *`-with-named-eslint-disable (254 + 258). §Three-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254 + 258).

§Sibling-pattern-to-cycle-254's-three-different-export-styles-in-one-file — §cycle-254 had three export styles in one file (`export const`, `export { local as Public }`, `export *`); §cycle-258 has two export styles (`export { name }`, `export *`) but only because the package is pure re-export. §Two-cycles-with-multiple-export-styles-in-one-file.
