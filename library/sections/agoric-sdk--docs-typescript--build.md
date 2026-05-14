---
title: Build (emitDeclarationOnly, runtime code, build-ts-to-js, why not two tsc passes)
source: docs/typescript.md
source_repo: agoric/agoric-sdk
source_commit: ffed404d
source_date: 2026-02-04
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [typescript-conventions, tooling]
status: current
---

> Abstract: 4 H3 sub-sections consolidated: the emitDeclarationOnly: true constraint (.d.ts only, no .js emit), when .ts files have runtime code (escape hatches), using build-ts-to-js for the cases that need it, why not two tsc passes (the design choice agoric-sdk makes vs alternatives).

## Build

### The `emitDeclarationOnly` constraint

The repo-wide `tsconfig-build-options.json` sets `emitDeclarationOnly: true`. This means `tsc` only generates `.d.ts` declaration files, not `.js` runtime files. This is intentional because:

1. Most source files are `.js` with JSDoc annotations (not `.ts`)
2. We don't use a separate `dist/` output directory to avoid requiring a build watcher during development
3. Without `emitDeclarationOnly`, `tsc` would try to write `.js` output for `.js` input files, causing errors like:
   ```
   error TS5055: Cannot write file 'src/cli/bin.js' because it would overwrite input file.
   ```

### When `.ts` files have runtime code

Some `.ts` files contain actual runtime code (functions, constants) rather than just type definitions. Examples include type guard functions, EIP-712 message helpers, etc. These files need corresponding `.js` files when published to npm.

Since `tsc` won't generate `.js` files (due to `emitDeclarationOnly`), we use `build-ts-to-js` to strip types and produce `.js` files.

### Using `build-ts-to-js`

The `build-ts-to-js` script uses `ts-blank-space` to transform `.ts` files into `.js` by replacing type annotations with whitespace. This preserves line numbers (no source maps needed) and is very fast.

Add it to your package's `prepack` script:

```json
{
  "scripts": {
    "prepack": "yarn run -T build-ts-to-js && yarn run -T tsc --build tsconfig.build.json && find src -name '*.ts' ! -name '*.d.ts' -delete",
    "postpack": "git checkout -- '*.ts' && git clean -f '*.d.ts' '*.d.ts.map' '*.js'"
  }
}
```

The script finds all `.ts` files in `src/` (excluding `.d.ts`) and generates corresponding `.js` files. During `prepack`:
1. `build-ts-to-js` generates `.js` runtime files from `.ts` sources
2. `tsc` generates `.d.ts` declaration files for all sources
3. Original `.ts` source files are deleted (so only `.js` and `.d.ts` are published)

The `postpack` script restores `.ts` files from git and cleans up generated files.

### Why not two `tsc` passes?

An alternative would be using two tsconfig files: one with `allowJs: false` to emit `.js` only for `.ts` files, and another for declarations. This was rejected because:

- Requires careful management of `allowJs`/`include`/`exclude` to avoid conflicts
- More complex to maintain and understand
- The `build-ts-to-js` approach is simpler: one tool for `.js`, one for `.d.ts`


Source: [docs/typescript.md](https://github.com/agoric/agoric-sdk/blob/ffed404d/docs/typescript.md) at commit `ffed404d`.
