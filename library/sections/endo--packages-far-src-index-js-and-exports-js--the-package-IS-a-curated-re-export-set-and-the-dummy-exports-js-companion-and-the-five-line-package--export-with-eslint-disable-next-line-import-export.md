---
title: §`export *` with `eslint-disable-next-line import/export`
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
// eslint-disable-next-line import/export
export * from './exports.js';
```

§Same-pattern-as-cycle-254 — the eslint rule flags potential conflicting exports + the author knows the conflict is intentional. §Two-cycles-with-`export *`-with-eslint-disable (254 + 258). §The-eslint-disable-comment-IS-the-acknowledgment-of-the-known-conflict.

§The-conflict-here: §`exports.js`-is-a-no-op + §`export *`-from-it-adds-nothing-at-runtime + §but-the-`.d.ts`-companion-DOES-add-types + §the-eslint-rule-only-sees-the-`.js`-and-flags-it.
