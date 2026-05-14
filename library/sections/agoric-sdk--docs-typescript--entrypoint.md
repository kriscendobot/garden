---
title: entrypoint
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

> Abstract: How index.js + types-index.js / .d.ts compose as the package entrypoint. Mirrors endo's types-index convention.

## entrypoint

This is usually an `index.js` file which contains a wildcard export like,

```js
// eslint-disable-next-line import/export -- just types
export * from './src/types.js';
```

The `types.js` file either defines the types itself or is an empty file (described above) paired with a `.d.ts` or `.ts` twin.

One option considered is having the conditional package `"exports"` include `"types"` but that has to be a .d.ts file. That could be generated from a `.ts` but it would require a build step, which we've so far avoided.

Once we have [JSDoc export type support](https://github.com/microsoft/TypeScript/issues/48104) we'll be able instead to keep the `index.js` entrypoint and have it export the types from `.ts` files without a runtime import of the module containing them.


Source: [docs/typescript.md](https://github.com/agoric/agoric-sdk/blob/ffed404d/docs/typescript.md) at commit `ffed404d`.
