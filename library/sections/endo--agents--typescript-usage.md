---
title: TypeScript usage
source: AGENTS.md
source_repo: endojs/endo
source_commit: 6ea51ece638e2c842a12ec23164c21cbc24f3cbe
source_date: 2026-03-21
source_authors: [Turadg Aleahmad]
ingested: 2026-05-13
ingested_by: liaison
topics: [agent-conventions, typescript-conventions]
status: current
---

> Abstract: Endo's TypeScript rules accommodate `.js` development (this repo) and `.ts` consumers (e.g., agoric-sdk). Six sub-rules apply: no `.ts` in runtime bundles, `.ts` files for type definitions only, the `types-index` convention (paired `.js` and `.d.ts` files for re-exports), placement rules for type definitions, `emitDeclarationOnly: true` is repo-wide, and `.js` files use `/** @import */` JSDoc to pull in types without a runtime module load.

## TypeScript usage

Our TypeScript conventions accommodate `.js` development (this repo) and `.ts` consumers (e.g. agoric-sdk). See [agoric-sdk/docs/typescript.md](https://github.com/Agoric/agoric-sdk/blob/master/docs/typescript.md) for full background.

### No `.ts` in runtime bundles

Never use `.ts` files in modules that are transitively imported into an Endo bundle. The Endo bundler does not understand `.ts` syntax. We avoid build steps for runtime imports.

### `.ts` files are for type definitions only

Use `.ts` files to define exported types. These are never imported at runtime. They are made available to consumers through a `types-index` module.

When a `.ts` file contains runtime code (e.g. `type-from-pattern.ts` with `declare` statements), it still produces only `.d.ts` output. The `declare` keyword ensures no JS is emitted. Actual runtime code belongs in `.js` files.

### The `types-index` convention

Each package that exports types uses a pair of files:

- **`types-index.js`**: Runtime re-exports. Contains `export { ... } from './src/foo.js'` for values that need enhanced type signatures (e.g. `M`, `matches`, `mustMatch`).
- **`types-index.d.ts`**: **Pure re-export index.** Contains only `export type * from` and `export { ... } from` lines. **No type definitions belong here.**

Why: `.d.ts` files are not checked by `tsc` (we use `skipLibCheck: true`). Type definitions in `.d.ts` files silently pass even if they contain errors. Definitions in `.ts` files are checked.

The entrypoint (`index.js`) re-exports from `types-index.js`:

```js
// eslint-disable-next-line import/export
export * from './types-index.js';
```

### Where type definitions go

| What | Where | Why |
|------|-------|-----|
| Interface types, data types | `src/types.ts` | Canonical type definitions |
| Inferred/computed types | `src/type-from-pattern.ts` (or similar `.ts`) | Complex type logic, checked by tsc |
| Value + namespace merges | Same `.ts` file as the namespace | TS requires both in one module for merging |
| `declare function` overrides | `.ts` file alongside related types | Gets type-checked |
| Re-exports only | `types-index.d.ts` | Pure index, no definitions |

### `emitDeclarationOnly`

The repo-wide `tsconfig-build-options.json` sets `emitDeclarationOnly: true`. `tsc` only generates `.d.ts` files, not `.js`. This means `.ts` files with runtime code (not just types) would need `build-ts-to-js` or equivalent. This repo does not currently have that.

Keep `.ts` files type-only.

### Imports in `.js` files

Use `/** @import */` JSDoc comments to import types without runtime module loading:

```js
/** @import { Pattern, MatcherNamespace } from './types.js' */
```

Source: [AGENTS.md](https://github.com/endojs/endo/blob/6ea51ece638e2c842a12ec23164c21cbc24f3cbe/AGENTS.md) at commit `6ea51ece`.
