---
title: .ts modules
source: docs/typescript.md
source_repo: agoric/agoric-sdk
source_commit: ffed404d
source_date: 2026-02-04
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [typescript-conventions]
status: current
---

> Abstract: How .ts files are used in agoric-sdk: type definitions only, no runtime code (mirrors endo's discipline). Detailed coverage of the type-definition-only rule and the exceptions.

## .ts modules

We cannot use `.ts` files in any modules that are transitively imported into an Endo bundle. The reason is that the Endo bundler doesn't understand `.ts` syntax and we don't want it to until we have sufficient auditability of the transformation. Moreover we've tried to avoid a build step in order to import a module. (The one exception so far is `@agoric/cosmic-proto` because we codegen the types. Those modules are written in `.ts` syntax and build to `.js` by a build step that creates `dist`, which is the package export.)

The trick is to use `.ts` for defining types and then make them available in the packages using a `types-index` module that has both `.js` and `.d.ts` files.

**Entrypoint (index.js)**
```js
// eslint-disable-next-line import/export
export * from './src/types-index.js'; // no named exports
```

**types-index.js**
```js
// Empty JS file to correspond with its .d.ts twin
export {};
```

**types-index.d.ts**
```ts
// Export all the types this package provides
export type * from './types.js';
export type * from './other-types.js';
```

The actual type implementation is then written in `types.ts` and `other-types.ts` files (per the example above).
These files are never runtime imported as they are only linked through a `.d.ts` file.



Source: [docs/typescript.md](https://github.com/agoric/agoric-sdk/blob/ffed404d/docs/typescript.md) at commit `ffed404d`.
